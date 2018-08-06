% [GSheet, status, content] = gxls_create(worksheetTitle)
%-------------------------------------------------------------------------------
% Description:
%    Create a Google spreadsheet
%
% Input
%   spreadsheetTitle: Name of the spreadsheet
%   sheetTitle: Name of the first sheet within the created spreadsheet
%
% Output:
%   Google sheet structure containing:
%       spreadsheetID: ID of the spread sheet
%       sheetID: ID of the first sheet
%       spreadsheetUrl: URL of the spreadsheet
%       SheetName: 1st sheet
%
%-------------------------------------------------------------------------------
% Raymond Olympio, 2018, rayoly@gmail.com
%-------------------------------------------------------------------------------



function [GSheet, status, content] = gxls_create_Spreadsheet(spreadsheetTitle, sheetTitle)

content = '';
GSheet = init_gsheet;

if ~exist('spreadsheetTitle','var')
    spreadsheetTitle = 'test_from_matlab';
end
if ~exist('sheetTitle','var')
    sheetTitle = '';
end
% --------------------------- Get Constant for proper work with google sheet API
gxls_constants;
%
% ------------------------------------------------------------ Get access rights
GSheet.aSheets = gxls_refreshAccessToken; % refresh and retrieve access token
%
% ------------------------------------------------------------
maxiter = 3;
status = 1;   
    
% ------------------------------------------------------------- Generate request
request = ['''properties'': {',...
    '''title'':''', spreadsheetTitle,'''',...
    '}'];
% request = '';
if ~isempty(sheetTitle)
request = [request ',''sheets'': [',...
    '{',...
      '''properties'': {',...
        '''title'': ''' sheetTitle ''',',...
        '''index'': 0,',...
        '''sheetType'': ''GRID'',',...
        '''gridProperties'': {',...
          '''rowCount'': 1000,',...
          '''columnCount'': 26',...
        '}',...
      '}',...
    '}',...
  '],'];
end

iter=1;
success=0;
while ~success && iter<maxiter    
    iter=iter+1;
    %retrieve discovery document
    %info = retrieve_discovery_doc(DISCOVERY_URL);
    %requested_url = info.url;
    %
    connection = urlreadwrite(mfilename,REQUESTED_URL);
    connection.setInstanceFollowRedirects(false);
    connection.setRequestMethod('POST');
    connection.setDoOutput(true);
    connection.setDoInput(true);
    connection.setRequestProperty('Authorization',['Bearer ' GSheet.aSheets]);
    connection.setRequestProperty('Content-Type','application/json; charset=UTF-8');
    %connection.setRequestProperty('X-Upload-Content-Length', '0');
    connection.setRequestProperty('accept','application/json');
    connection.setRequestProperty('accept-encoding', 'gzip; deflate');
    event = ['{',...
                  request,...
                '}'];    
    connection.setRequestProperty('Content-Length', num2str(length(event)));    
    
    ps = PrintStream(connection.getOutputStream());
    ps.print(event);
    ps.close();  clear ps event; 
    
    
    if (connection.getResponseCode()~=200)
        connection.disconnect();
        continue;
    end
    %
    [json_data, content] = gxls_retrieve_stream_data(connection.getInputStream);
    
    %retrieve spreadsheet ID
    GSheet.spreadsheetID = json_data.spreadsheetId;
    GSheet.spreadsheetUrl = json_data.spreadsheetUrl;
    %retrieve sheet ID
    GSheet.SheetId = json_data.sheets{1}.properties.sheetId;
    GSheet.SheetName = json_data.sheets{1}.properties.title;
    
    success=true;
    status = 1;
end

if ~success
    status = 0;
    display(['Failed trying to create spreadsheet. Last response was: ' num2str(connection.getResponseCode) '/' connection.getResponseMessage().toCharArray()']);
end

