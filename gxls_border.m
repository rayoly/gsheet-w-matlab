function [GSheet, status] = gxls_border(url_file,sheetname,varargin)

%XLSBORDER modifies borders of selected Excel cell(s)
%
% xlsborder(filename,sheetname,'Whole', param,LineStyle,Weight,ColorIndex, ...)
% xlsborder(filename,sheetname,'Find',text, param,LineStyle,Weight,ColorIndex, ...)
% xlsborder(filename,sheetname,range, param,LineStyle,Weight,ColorIndex, ...)
%
% xlsborder  : modifies borders of selected Excel cell(s) in a selected sheet.
%
%       filename:       Name of excel file.
%       sheetname:      sheet name.
%       'Whole':        to select whole sheet.
%       'Find':         to look for specific string 'text' in the sheet to
%                       change the font.
%       text:           string text to look for in sheet using 'Find'.
%
%       USER CONFIGURABLE OPTIONS
%
%       Possible param options are:
%
%           'Box'   - to be followed 3 integers indicating (LineStyle,Weight,ColorIndex)
%           'Cross'     - to be followed by one of the following integers:
%           'DiagonalDown'   - to be followed 3 integers indicating (LineStyle,Weight,ColorIndex)
%           'DiagonalUp'   - to be followed 3 integers indicating (LineStyle,Weight,ColorIndex)
%           'EdgeBottom'   - to be followed 3 integers indicating (LineStyle,Weight,ColorIndex)
%           'EdgeLeft'   - to be followed 3 integers indicating (LineStyle,Weight,ColorIndex)
%           'EdgeRight'   - to be followed 3 integers indicating (LineStyle,Weight,ColorIndex)
%           'EdgeTop'   - to be followed 3 integers indicating (LineStyle,Weight,ColorIndex)
%           'InsideHorizontal'   - to be followed 3 integers indicating (LineStyle,Weight,ColorIndex)
%           'InsideVertical'   - to be followed 3 integers indicating (LineStyle,Weight,ColorIndex)
%
%       LineStyle:  to be assigned one of the following integers:
%               0: None
%               1: Continious
%               2: Dash
%               3: Medium
%               4: Thick
%               5: Dot
%               6: Double
%
%       Weight:     to be assigned one of the following integers:
%                   1: Hairline
%                   2: Thin
%                   3: Medium
%                   4: Thick
%
%       ColorIndex: to be followed by Excel color index number.
%                   (ex. 1:Black 2:White 3:Red 4:Green 5:Blue)
%
% Examples:
%
%   xlsborder('file.xls','Sheet1','A1:A2','Box',1,2,1);
%   xlsborder('file.xls','Sheet1','A1:B2','Cross',6,4,5);
%   xlsborder('file.xls','Sheet1','A1:A2','EdgeTop',1,2,1,'EdgeBottom',4,3,3);
%
%   See also XLSREAD, XLSFINFO, XLSWRITE, XLSCELL, XLSHEETS, , CPTXT2XLS, MSOPEN

%   Copyright 2004 Fahad Al Mahmood
%   Version: 1.0 $  $Date: 21-Mar-2004

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
%
border = def_border_prop();

if ~isempty(varargin)
    range = convert_range(varargin{1});
    range.sheetId = sheetId;
    %
    options = varargin(2:end);
    if ~isempty(options)
        border = process_border_options(options, border);
    end
else
    fprintf(2,'%s::Missing arguments!\n',mfilename);
    return;
end
% ------------------------------------------------------------- Generate request
request = ['''requests'': [',...
    '{',...
    '''updateBorders'': {',...
    '''range'': ' gxls_req_gridrange(range) ',',...
    '''top'': ' gxls_req_border(border.top) ','...
    '''bottom'': ' gxls_req_border(border.bottom) ','...
    '''left'': ' gxls_req_border(border.left) ','...
    '''right'': ' gxls_req_border(border.right) ','...
    '''innerHorizontal'': ' gxls_req_border(border.innerHorizontal) ','...
    '''innerVertical'': ' gxls_req_border(border.innerVertical) ...
    '}',...
    '}]'];

% ----------------------------------------------------------------- Send request
[success, GSheet, connection] = gxls_send_req(GSheet, request);
%
if ~success
    display(['Failed trying to change border in sheet ' sheetname  '. Last response was: ' num2str(connection.getResponseCode) '/' connection.getResponseMessage().toCharArray()']);
end

%-------------------------------------------------------------------------------
function border = process_border_options(options, border)

n=1;
while n<=length(options)
    border_name = lower(options{n});
    %width
    width = options{n+1};
    if ischar(width)
        width = str2double(width);
    end
    
    %Line style
    lstyle = lower(options{n+2});
    if isnumeric(lstyle)
        STYLES = {'none','solid','dash','medium','thick','dot','double'};
        lstyle = STYLES{lstyle+1};
    end
    %Color
    color_index = options{n+3};
    if ischar(color_index) && ~isnan(str2double(color_index))
        color_index = str2double(color_index);
    end
    alpha = 1.0;
    %
    switch border_name
        case 'diagonaldown'
            field = '';
        case 'diagonalup'
            field = '';
        case 'edgebottom'
            field = 'bottom';
        case 'edgeleft'
            field = 'left';
        case 'edgeright'
            field = 'right';
        case 'edgetop'
            field = 'top';
        case 'insidehorizontal'
            field = '';
        case 'insidevertical'
            field = '';
        case 'box'
            field = {'left','right','top','bottom'};
        case 'cross'
            field = '';
        otherwise
            n=n+4;
            continue
    end
    
    for nf=1:length(field)
        if ~isempty(field{nf})
            switch lstyle
                case 'dash'
                    lstyle = 'DASHED';%Dashed line borders.
                case 'dot'
                    lstyle = 'DOTTED';
                case 'solid'
                    lstyle = 'SOLID';%Thin solid line borders.
                case 'medium'
                    lstyle = 'SOLID_MEDIUM';%Medium solid line borders.
                case 'thick'
                    lstyle = 'SOLID_THICK';%Thick solid line borders.
                case 'double'
                    lstyle = 'DOUBLE';%Two solid line borders.
                otherwise
                    lstyle = 'SOLID';
            end
            %
            border.(field{nf}).width = num2str(width,'%.2f');
            %
            border.(field{nf}).style = lstyle;
            %
            color_index = colorindex2color(color_index);
            %
            border.(field{nf}).color.red = color_index(1);
            border.(field{nf}).color.green =  color_index(2);
            border.(field{nf}).color.blue =  color_index(3);
            
            border.(field{nf}).color.alpha = alpha;
        end
    end
    n=n+4;
end

%-------------------------------------------------------------------------------

function border = def_border_prop()

fields = {'top','bottom','right','left','innerHorizontal','innerVertical'};
%
for n=1:length(fields)
    border.(fields{n}).style = 'DASHED';
    border.(fields{n}).width =  '1.0';
    border.(fields{n}).color.blue = '1.0';
    border.(fields{n}).color.red = '0.0';
    border.(fields{n}).color.green = '0.0';
    border.(fields{n}).color.alpha = '0.0';
end