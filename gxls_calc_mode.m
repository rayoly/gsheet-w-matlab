% [GSheet, status] = gxls_calc_mode(filename,calc_mode)
%-------------------------------------------------------------------------------
% Description:
%   Change the calc mode of the spread sheet
%
% Input
%   url_file: path or GSheet structure of the spreadsheet to modify
%   calc_mode: calculation mode
%       1 for automatic (ON_CHANGE)
%       0 for manual (ON_HOUR)
%
%-------------------------------------------------------------------------------
% Raymond Olympio, 2018, rayoly@gmail.com
%-------------------------------------------------------------------------------


function [GSheet, status] = gxls_calc_mode(url_file, calc_mode)

status = 0;
GSheet = [];

if ~exist('url_file','var') || isempty(url_file)
    fprintf(2,'%s::No file provided\n',mfilename);
    return;
end
if ~exist('calc_mode','var') || isempty(calc_mode)
    calc_mode = -1;
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

switch calc_mode
    case xlCalculateManual 
        calc_mode_str = 'HOUR';
        %calc_mode_str = 'MINUTE';
    case xlCalculationAutomatic
        calc_mode_str = 'ON_CHANGE';
    otherwise
        calc_mode_str = 'ON_CHANGE';
end
% ------------------------------------------------------------- Generate request
request = ['''requests'': [',...
                '{',...
                    '''updateSpreadsheetProperties'': {',...
                        '''properties'': {',...
                            '''autoRecalc'': ', '''' calc_mode_str '''',...
                        '},',...
                        '''fields'': ''autoRecalc''',...
                   '}',...
                '}',...
           '],',...
           '''includeSpreadsheetInResponse'': false'];
       
% ----------------------------------------------------------------- Send request
[success, GSheet, connection] = gxls_send_req(GSheet, request);
%
if ~success
    display(['Failed trying to change calculation mode of the spreadsheet. Last response was: ' num2str(connection.getResponseCode) '/' connection.getResponseMessage().toCharArray()']);
end