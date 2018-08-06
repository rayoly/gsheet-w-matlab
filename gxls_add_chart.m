function [GSheet, status] = gxls_add_chart(url_file,sheetname,Series_name, X_range,Y_range,varargin)

status = 0;
GSheet = [];

if ~exist('url_file','var') || isempty(url_file)
    fprintf(2,'%s::No file provided\n',mfilename);
    return;
end

% --------------------------- Get Constant for proper work with google sheet API
gxls_constants;

if ischar(url_file) %URL of the spreadsheet and sheetid
    %convert file into Gsheet structure
    GSheet = url2gsheet(url_file);
    
elseif isstruct(url_file) && isfield(url_file,'spreadsheetID')
    GSheet = url_file;
    clear file
end

% ------------------------------------------------------------ Processed options
[sheetId, GSheet] = gxls_sheetname2sheetid(GSheet, sheetname);

% ----------------------------------------------------------------- Options
chartId = 1;

chart_type = 'xlColumnClustered';
chart_title = '';
X_title = '';
Y_title = '';
width = 100;
height = 100;
position = [0 0];
position_range = '';
i=1;
while i<=nargin-5
    switch lower(varargin{i})
        case 'chart_type'
            chart_type = varargin{i+1};
            i=i+1;
        case 'chart_title'
            chart_title = varargin{i+1};
            i=i+1;
        case 'x_title'
            X_title = varargin{i+1};
            i=i+1;
        case 'y_title'
            Y_title = varargin{i+1};
            i=i+1;
        case 'type'
            chart_type = varargin{i+1};
            i=i+1;
        case 'width'
            width= varargin{i+1};
            i=i+1;
        case 'height'
            height = varargin{i+1};
            i=i+1;
        case 'position'
            position = varargin{i+1};
            i=i+1;
        case 'position_range'
            position_range = varargin{i+1};
            i=i+1;
        case {'id','chartId'}
            chartId = varargin{i+1};
            i=i+1;            
    end
    i = i+1;
end

%------------------------------------------------- Chart type

%------------------------------------------------- Add data
% %clean up
% for i=Chart.SeriesCollection.Count:-1:1
%     Chart.SeriesCollection(i).Delete;
% end
% %
% for i=1:length(Series_name)
%     invoke(Chart.SeriesCollection,'NewSeries');
%     Chart.SeriesCollection(i).Name = Series_name{i};
%     Chart.SeriesCollection(i).XValues = Excel.ActiveSheet.Range(X_range{1});
%     Chart.SeriesCollection(i).Values = Excel.ActiveSheet.Range(Y_range{i});
% end

%------------------------------------------------- Position
%Chart.Location
%Chart.Move
% if ~isempty(position_range)
%     pos_rng = Excel.ActiveSheet.Range(position_range);
%     Chart.Parent.Top = pos_rng.Top;
%     Chart.Parent.Left = pos_rng.Left;
%     Chart.Parent.Width = pos_rng.Width;
%     Chart.Parent.Height = pos_rng.Height;
% else
%     Chart.Parent.Top = position(1);
%     Chart.Parent.Left = position(2);
%     Chart.Parent.Width = width;
%     Chart.Parent.Height = height;
% end
%don't move or size with cells
% Chart.Parent.Placement = xlFreeFloating;
EChart = def_embedded_chart('basic');
EChart.chartId = chartId;
%Add chart to the current sheet
if ~isempty(sheetId) && sheetId>0
    EChart.position.overlayPosition.anchorCell.sheetId = sheetId;
    EChart.position.overlayPosition.anchorCell.rowIndex = 1;
    EChart.position.overlayPosition.anchorCell.columnIndex = 10;
else
    %EChart.position.sheetid = sheetId;
    EChart.position.newSheet = true;
end
%
if ~isempty(chart_title)
    EChart.spec.title = chart_title;
else
    EChart.spec.title = 'No Title';
end
EChart.spec.(chart_type) = [];
%
%%basicChart.
EChart.spec.basicChart.axis(1).position = 'BOTTOM_AXIS';
EChart.spec.basicChart.axis(2).position = 'LEFT_AXIS';
% Setting the (X-Axis) and (Y-Axis) titles.
if ~isempty(X_title)
    EChart.spec.basicChart.axis(1).title = X_title;
end
if ~isempty(Y_title)
    EChart.spec.basicChart.axis(2).title = Y_title;
end
%
% source series
range = convert_range(X_range);
EChart.spec.basicChart.domains.domain.sourceRange.sources.sheetId = sheetId;
EChart.spec.basicChart.domains.domain.sourceRange.sources.startRowIndex = range.start_row;
EChart.spec.basicChart.domains.domain.sourceRange.sources.startColumnIndex = range.start_col;
EChart.spec.basicChart.domains.domain.sourceRange.sources.endRowIndex = range.end_row;
EChart.spec.basicChart.domains.domain.sourceRange.sources.endColumnIndex = range.end_col;

range = convert_range(Y_range);
EChart.spec.basicChart.series(1).series.sourceRange.sources.sheetId = sheetId;
EChart.spec.basicChart.series(1).series.sourceRange.sources.startRowIndex = range.start_row;
EChart.spec.basicChart.series(1).series.sourceRange.sources.startColumnIndex = range.start_col;
EChart.spec.basicChart.series(1).series.sourceRange.sources.endRowIndex = range.end_row;
EChart.spec.basicChart.series(1).series.sourceRange.sources.endColumnIndex = range.end_col;
%
% ------------------------------------------------------------- Generate request
request = ['''requests'': [',...
    '{',...
    '''addChart'': {',...
    '''chart'': ' gxls_req_embeddedchart(EChart) ,...
    '}}]'];
% ----------------------------------------------------------------- Send request
[success, GSheet, connection] = gxls_send_req(GSheet, request);
%
if ~success
    display(['Failed trying to add a chart to sheet ' sheetname  '. Last response was: ' num2str(connection.getResponseCode) '/' connection.getResponseMessage().toCharArray()']);
    request
end

%-------------------------------------------------------------------------------
%
%-------------------------------------------------------------------------------

function echart = def_embedded_chart(type)

txtfmt = struct('foregroundColor', struct('red',1.0, 'green',1.0, 'blue',1.0),...
    'fontFamily','Arial',  'fontSize',12,...
    'bold',[],  'italic',[],  'underline',[]);

txtpos = struct('horizontalAlignment','LEFT');

echart.chartId = 0;
%
echart.position.overlayPosition.anchorCell.sheetid = [];
echart.position.overlayPosition.anchorCell.rowIndex = [];
echart.position.overlayPosition.anchorCell.columnIndex = [];
echart.position.overlayPosition.offsetXPixels = [];
echart.position.overlayPosition.offsetYPixels = [];
echart.position.overlayPosition.widthPixels = [];
echart.position.overlayPosition.heightPixels = [];
echart.position.sheetId = [];
echart.position.newSheet = false;
%
echart.spec.title = '';
echart.spec.altText = '';
echart.spec.titleTextFormat = txtfmt;
echart.spec.titleTextPosition = txtpos;
echart.spec.subtitle = '';
echart.spec.subtitleTextFormat = txtfmt;
echart.spec.subtitleTextPosition = txtpos;
echart.spec.fontName = 'Arial';
echart.spec.maximized = false;
echart.spec.backgroundColor = struct('red',1.0, 'green',0.5, 'blue',0.7);
echart.spec.hiddenDimensionStrategy = 'SKIP_HIDDEN_ROWS_AND_COLUMNS';

if ~exist('type','var')
    type = 'basic';
end

switch type
    case 'basic'
        echart.spec.basicChart.chartType = 'SCATTER';
        echart.spec.basicChart.legendPosition = 'BOTTOM_LEGEND';
        echart.spec.basicChart.axis = [];
        echart.spec.basicChart.domains = [];
        echart.spec.basicChart.series = [];
        echart.spec.basicChart.headerCount = 1;
        echart.spec.basicChart.threeDimensional = false;
        echart.spec.basicChart.interpolateNulls = false;
        echart.spec.basicChart.stackedType = 'NOT_STACKED';
        echart.spec.basicChart.lineSmoothing = true;
        echart.spec.basicChart.compareMode = 'DATUM';
    case 'pie'
    case 'bubble'
    case 'candle'
    case 'org'
    case 'histogram'
    case 'waterfall'
    case 'treemap'
end
