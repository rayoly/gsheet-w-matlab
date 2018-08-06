function [GSheet, status] = gxls_mergecells(url_file,sheetname,range,box_width,title_str, merge_type)
% xls_mergecells(filename,sheetname,range,box_width, title_str, merge_type)
%
% merge_type=
%     0: merge all
%     1: merge by column
%     2: merge by rows
%     anything elese: unmerge
%-------------------------------------------------------------------------------
% Raymond Olympio
%-------------------------------------------------------------------------------

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

% ---------------------------------------------------------------------- Options
%Line property
xlHairline = 1;
xlThin = 2;
xlMedium = -4138;
xlThick = 4;
%Line Style

xlContinuous = 1;

if ~exist('box_width','var')
    box_width = 0;
end
if ~exist('title_str','var')
    title_str = '';
end
if ~exist('merge_type','var')
    merge_type = 0;
end
% Sheet ID and range
[sheetId, GSheet] = gxls_sheetname2sheetid(GSheet, sheetname);
range = convert_range(range);
range.sheetId = sheetId;

% border width
switch(box_width)
    case 0
        weight_opt=0;
    case 1
        weight_opt=xlHairline;
    case 2
        weight_opt=xlThin;
    case 3
        weight_opt=xlMedium;
    case 4
        weight_opt=xlThick;
end
% line style
if weight_opt~=0
    line_style=xlContinuous;
    color_idx = 1;
end

% ------------------------------------------------------------- Generate request
switch merge_type
    case 0
        merge_type = 'MERGE_ALL';
    case 1
        merge_type = 'MERGE_COLUMNS';
    case 2
        merge_type = 'MERGE_ROWS';
    otherwise
        merge_type = '';
end

request = ['''requests'': [{',...
    '''mergeCells'': {',...
    '''range'': ' gxls_req_gridrange(range),...
    ];
if ~isempty(merge_type)
    request = [request ',''mergeType'': ''', merge_type ''''];
end
request = [request  '}}]'];
% ----------------------------------------------------------------- Send request
[success, GSheet, connection] = gxls_send_req(GSheet, request);
%
if ~success
    display(['Failed trying to merge cells in sheet ' sheetname  '. Last response was: ' num2str(connection.getResponseCode) '/' connection.getResponseMessage().toCharArray()']);
end
