%GXLS_READ Read data from a sheet in a google spreadsheet
%
% [numericData, textData, rawData, customOutput] = gxls_read(url_file, sheetName, range, ~, fun_handle)
%
% gxls_read  : Read data from a sheet in a google spreadsheet.
%
%
%   Inputs:
%       url_file: url of the file or GSheet structure
%       sheetName: sheet name or sheet ID to extract data from
%       range: cell range to indicate which data to export. 
%           If omitted or empty, the complete sheet will be exported.
%       fun_handle: function to execute on all the data
%
%   Outputs:
%       numericData: array of numeric data 
%       textData: stream content in string format
%       rawData:
%       customOutput:
%
%
%
%   This function input and outputs arguments are inspired from the Matlab's
%   xlsread function. As such, the syntax is very similar.
%
%
%   [numericData, textData, rawData] = GXLS_READ(FILE,SHEET) 
%   reads the specified worksheet.
%
%   [numericData, textData, rawData] = GXLS_READ(FILE,SHEET,RANGE) 
%   Reads from the specified SHEET
%   and RANGE. Specify RANGE using the syntax 'C1:C2', where C1 and C2 are
%   opposing corners of the region. Not supported for XLS files in BASIC
%   mode.
%
%
% ------------------------------------------------------------------------------
%   Copyright 2018 Raymond Olympio
%   Version: 1.0
%   Date: 05-Aug-2018
% ------------------------------------------------------------------------------

function [numericData, textData, rawData, customOutput] = gxls_read(url_file, sheetName, range, ~, fun_handle)

get_num = false;
get_txt = false;
get_raw = false;
get_cust = false;
numericData = [];
textData = {};
rawData = {};
GSheet = [];
% --------------------------------------------------------------- Process inputs
if isnumeric(sheetName)
    sheetId = sheetName;
    sheetName = '';
end
%
if nargin>=1
    get_num = true;    
    if nargin>=2
        get_txt = true;
        if nargin>=3
            get_raw = true;
            if exist('fun_handle','var') && nargin>=4
                get_cust = true;
            end
        end
    end
end

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

maxiter=3;
iter=1;
success = 0;
while ~success && iter<maxiter
    iter=iter+1;
    % Retrieve discovery document
    %info = retrieve_discovery_doc(discovery_url);
    %requested_url = info.url;
    
    % Check validatity of the credentials to access the spread sheet
    
    % Establish connection parameters
    if ~exist('range','var') || isempty(range)
        connection = urlreadwrite(mfilename,[REQUESTED_URL GSheet.spreadsheetID '?includeGridData=true']);% REQUESTED_URL);
        full_sheet = true;
    else
        connection = urlreadwrite(mfilename,[REQUESTED_URL GSheet.spreadsheetID '/values/' range]);% REQUESTED_URL);
        full_sheet = false;
    end
    connection.setInstanceFollowRedirects(false);
    connection.setRequestMethod('GET');
    connection.setDoOutput(true);
    connection.setDoInput(true);
    connection.setRequestProperty('Authorization',['Bearer ' GSheet.aSheets]);
    connection.setRequestProperty('Content-Type','application/json; charset=UTF-8');
    connection.setRequestProperty('accept','application/json');
    connection.setRequestProperty('accept-encoding', 'gzip; deflate');
    
    if (connection.getResponseCode()~=200)
        connection.disconnect();
        continue;
    end
    % ------------------------------------------------ retrieve spreadsheet data
    [json_data, ~] = gxls_retrieve_stream_data(connection.getInputStream);
    sheet_data = [];
    if full_sheet
        GSheet.spreadsheetTitle = json_data.properties.title;
        GSheet.spreadsheetID = json_data.spreadsheetId;
        %retrieve spreadsheet data
        for ns=1:length(json_data.sheets)
            %properties
            c_sheetname = json_data.sheets{ns}.properties.title;
            c_sheetid = json_data.sheets{ns}.properties.sheetId;
            if strcmpi(c_sheetname,sheetName) || c_sheetid == sheetId
                %properties
                n_row = json_data.sheets{ns}.properties.gridProperties.rowCount;
                n_col = json_data.sheets{ns}.properties.gridProperties.columnCount;
                %
                if get_raw
                    rawData = cell(n_row,n_col);
                end
                if get_num
                    numericData = NaN(n_row,n_col);
                end
                if get_txt
                    textData = cell(n_row,n_col);
                end
                %process data
                for r=1:length(json_data.sheets{ns}.data{1}.rowData)
                    if isempty(json_data.sheets{ns}.data{1}.rowData{r})
                        continue;
                    end
                    for c=1:length(json_data.sheets{ns}.data{1}.rowData{r}.values)
                        if isempty(json_data.sheets{ns}.data{1}.rowData{r}.values{c})
                            continue;
                        end
                        if get_num && isfield(json_data.sheets{ns}.data{1}.rowData{r}.values{c}.effectiveValue,'numberValue')
                            numericData(r,c) = json_data.sheets{ns}.data{1}.rowData{r}.values{c}.effectiveValue.numberValue;
                        end
                        if get_txt && isfield(json_data.sheets{ns}.data{1}.rowData{r}.values{c}.effectiveValue,'stringValue')
                            textData{r,c} = json_data.sheets{ns}.data{1}.rowData{r}.values{c}.effectiveValue.stringValue;
                        end
                        if get_raw || get_cust
                            rawData{r,c} = json_data.sheets{ns}.data{1}.rowData{r}.values{c};
                        end
                    end
                end
                break;
            end
        end
    else
        %process data
        for r=1:length(json_data.values)
            if isempty(json_data.values{r})
                continue;
            end
            for c=1:length(json_data.values{r})
                if isempty(json_data.values{r}{c})
                    continue;
                end
                if get_num 
                    numericData(r,c) = str2double(json_data.values{r}{c});
                end
                if get_txt 
                    textData{r,c} = json_data.values{r}{c};
                end
                if get_raw || get_cust
                    rawData{r,c} = json_data.values{r}{c};
                end

            end
        end
    end
    %---------------------------------------------------------------------------
    if isempty(sheet_data)
        if ~isempty(sheetName)
            fprintf(2, 'Sheet %s was not found!\n',sheetName);
        else
            fprintf(2, 'Sheet #%d was not found!\n',sheetId);
        end
        return;
    end
    %
    try
        if get_cust
            customOutput = cellfun(@(x) fun_handle(x), rawData,'UniformOutput',false);
        end
    end
    %
    success = true;
end
%
if ~success
    display(['Failed trying to get sheetnames. Last response was: ' num2str(connection.getResponseCode) '/' connection.getResponseMessage().toCharArray()']);
end
