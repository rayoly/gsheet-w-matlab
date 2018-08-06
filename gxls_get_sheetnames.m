function [sheetnames, sheetids, GSheet] = gxls_get_sheetnames(url_file)

sheetnames = {};
sheetids = [];

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
    clear url_file
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
    connection = urlreadwrite(mfilename,[REQUESTED_URL GSheet.spreadsheetID '?includeGridData=false']);% REQUESTED_URL);
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
    %
    [json_data, ~] = gxls_retrieve_stream_data(connection.getInputStream);
    
    %retrieve spreadsheet ID
    GSheet.spreadsheetID = json_data.spreadsheetId;
    for ns=1:length(json_data.sheets)
        %sheet properties
        sheetnames{ns} = json_data.sheets{ns}.properties.title;
        sheetids(ns) = json_data.sheets{ns}.properties.sheetId;
    end
    sheetids = int32(sheetids);
    GSheet.SheetNames = sheetnames;
    GSheet.SheetIds = sheetids;
    %
    success = true;
end
%
if ~success
    display(['Failed trying to get sheetnames. Last response was: ' num2str(connection.getResponseCode) '/' connection.getResponseMessage().toCharArray()']);
end
