%GXLS_SEND_REQ Send request
%
% [success, GSheet, connection] = gxls_send_req(GSheet, request)
%
% gxls_send_req : Send request
%
%       GSheet:       Google sheet structure
%       request:      string containing the request.
%
%   Output:
%       success: boolean indicating the success of the request.
%       GSheet: updated Google sheet structure.
%       connection: established connection (disconnected).
%
%   See also GXLS_CREATE_SPREADSHEET, INIT_GSHEET
%
%   Inspired from: Matlab to Google Sheets (matlab2sheets) by Andrew Bogaard
%   https://de.mathworks.com/matlabcentral/fileexchange/59359-matlab-to-google-sheets-matlab2sheets
%
% ------------------------------------------------------------------------------
%   Copyright 2018 Raymond Olympio
%   Version: 1.0
%   Date: 05-Aug-2018
% ------------------------------------------------------------------------------

function [success, GSheet, connection] = gxls_send_req(GSheet, request)

gxls_constants;

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
    connection = urlreadwrite(mfilename,[REQUESTED_URL GSheet.spreadsheetID ':batchUpdate']);% REQUESTED_URL);
    connection.setInstanceFollowRedirects(false);
    connection.setRequestMethod('POST');
    connection.setDoOutput(true);
    connection.setDoInput(true);
    connection.setRequestProperty('Authorization',['Bearer ' GSheet.aSheets]);
    connection.setRequestProperty('Content-Type','application/json; charset=UTF-8');
    connection.setRequestProperty('accept','application/json');
    connection.setRequestProperty('accept-encoding', 'gzip; deflate');
    event = ['{',...
        request,...
        '}'];
    connection.setRequestProperty('Content-Length', num2str(length(event)));
    ps = PrintStream(connection.getOutputStream());
    ps.print(event);
    ps.close();  clear ps event;
    
    resp_code = connection.getResponseCode();
    if (resp_code~=200)
        if resp_code==401 %refresh access rights
            fprintf(1,'Refreshing access token\n');
            GSheet.aSheets = gxls_refreshAccessToken;
        end
        json_error = gxls_retrieve_stream_data(connection.getErrorStream);
        connection.disconnect();
        continue;
    end
    %
    [json_data, ~] = gxls_retrieve_stream_data(connection.getInputStream);
    
    %retrieve spreadsheet ID
    GSheet.spreadsheetID = json_data.spreadsheetId;
    
    success = true;
end
%
if resp_code==400    
    try
        fprintf(2,'CODE: %d\n',json_error.error.code);
        fprintf(2,'STATUS: %s\n',json_error.error.status);
        fprintf(2,'MESSAGE: %s\n',json_error.error.message);
    end
end

