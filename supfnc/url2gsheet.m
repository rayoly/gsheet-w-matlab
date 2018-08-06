%URL2GSHEET Generate a GSheet structure based on a spreadsheet or sheet url
%
% GSheet = url2gsheet(url)
%
% url2gsheet  : Generate a GSheet structure based on a spreadsheet or sheet url.
%
%       url:       url to the sheet or spreadsheet
%
%
%
%  See also GXLS_REFRESHACCESSTOKEN, INIT_GSHEET
%
%
% ------------------------------------------------------------------------------
%   Copyright 2018 Raymond Olympio
%   Version: 1.0
%   Date: 05-Aug-2018
% ------------------------------------------------------------------------------

function GSheet = url2gsheet(url)

GSheet = init_gsheet();
GSheet.aSheets = gxls_refreshAccessToken;
%
GSheet.spreadsheetUrl = url;
%

%--------------------------------------------
if strfind(url,'edit')
    a = textscan(url,'%*[^:]://%*[^/]/spreadsheets/d/%[^/]/edit#gid=%d');    
    
    GSheet.spreadsheetID = a{1}{1};
    GSheet.SheetName = '';
    GSheet.SheetId = a{2};
    
else
    a = textscan(url,'%*[^:]://%*[^/]/spreadsheets/d/%[^/]%*s');
    GSheet.spreadsheetID = a{1}{1};
    GSheet.SheetId = 0;
    GSheet.SheetName = '';
end

