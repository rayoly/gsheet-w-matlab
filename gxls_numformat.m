% Excel = xls_numformat(filename,sheetname,range, format_str)
%-------------------------------------------------------------------------------
% Description:
%   
%
% Input
%
%
%
%
%
%-------------------------------------------------------------------------------
% Raymond OLYMPIO, raymond.olympio@airbus.com
%-------------------------------------------------------------------------------

function [GSheet, status] = gxls_numformat(url_file, sheetname, range, format_str)

status = 0;
GSheet = [];

if ~exist('url_file','var') || isempty(url_file)
    fprintf(2,'%s::No file provided\n',mfilename);
    return;
end
if ~exist('calc_mode','var') || isempty(calc_mode)
    format_str = 'normal';
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
%Process format
if strcmp(format_str,'percent')
    numfmt_type = 'PERCENT';
    numfmt_pattern = '0.00%';
elseif strcmp(format_str,'scientific')
    numfmt_type = 'SCIENTIFIC';
    numfmt_pattern = '0.00E+00';
elseif strcmp(format_str,'normal')
    numfmt_type = 'NUMBER';
    numfmt_pattern= '0.00';
elseif strcmp(format_str,'integer')
    numfmt_type = 'NUMBER';
    numfmt_pattern='0';
else
    numfmt_type = 'NUMBER';
    numfmt_pattern=format_str;
end
% ------------------------------------------------------------- Generate request

if ischar(url_file) %URL of the spreadsheet and sheetid
    %convert file into Gsheet structure
    GSheet = url2gsheet(url_file);
    
elseif isstruct(url_file) && isfield(url_file,'spreadsheetID')
    GSheet = url_file;
    clear file
end

% ------------------------------------------------------------ Processed options
[sheetId, GSheet] = gxls_sheetname2sheetid(GSheet, sheetname);
%Process range
range = convert_range(range);
range.sheetId = sheetId;
%
% ------------------------------------------------------------- Generate request

request = ['''requests'': [',...
        '{',...
            '''repeatCell'': {',...
                '''range'': ' gxls_req_gridrange(range) ',',...
                '''cell'': {',...
                        '''userEnteredFormat'': {',...
                            '''numberFormat'': ',...
                            gxls_req_numfmt(numfmt_type,numfmt_pattern),...
                        '}',...
                    '},',...
                '''fields'': ''userEnteredFormat.numberFormat'''...
    '}}]'];

% ----------------------------------------------------------------- Send request
[success, GSheet, connection] = gxls_send_req(GSheet, request);
%
if ~success
    display(['Failed trying to change number format in sheet ' sheetname  '. Last response was: ' num2str(connection.getResponseCode) '/' connection.getResponseMessage().toCharArray()']);
end
