%GXLS_COMMENT Adds comment to a specified cell in Excel sheet.
%
% xlscomment(filename,sheetname,cell,comment,visible)
%
%       filename:       Name of excel file.
%       sheetname:      sheet name.
%       cell:           cell location (ex. 'C5', 'B9')
%       comment:        comment to be inserted consisting of string of characters 
%       visible:        0:  to hide comment.
%                       1:  to make comment visible.
% 
% Example:
%      
%   xlscomment('file.xls','Sheet1','B4','This is my Comment!',1)
%
%   See also XLSREAD, XLSFINFO, XLSWRITE, XLSCELL, XLSHEETS, XLSALIGN,
%   XLSBORDER, XLSFONT, MSOPEN

%   Copyright 2004 Fahad Al Mahmood
%   Version: 1.0 $  $Date: 09-Jun-2004

%-------------------------------------------------------------------------------

function [GSheet, status] = gxls_comment(url_file,sheetname,cell_addr,comment, visible)

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

if ~exist('cell_addr','var') || isempty(cell_addr)
    fprintf(2,'%s::No range or cell address provided!\n',mfilename);
    return;
end

if ~exist('comment','var') || isempty(comment)
    fprintf(2,'%s::No comment provided!\n',mfilename);
    return;
end
range = convert_range(cell_addr);
range.sheetId = sheetId;
rowdata.comment = comment;
% ------------------------------------------------------------- Generate request
request = ['''requests'': [',...
        '{',...
            '''updateCells'': {',...
                '''range'': ' gxls_req_gridrange(range) ',',...
                '''rows'': [', gxls_req_rowdata(rowdata) '],',...
                '''fields'': ''note''',...                
            '}',...
    '}]'];

% ----------------------------------------------------------------- Send request
[success, GSheet, connection] = gxls_send_req(GSheet, request);
%
if ~success
    display(['Failed trying to add comment to cell ' cell_addr ' in sheet ' sheetname  '. Last response was: ' num2str(connection.getResponseCode) '/' connection.getResponseMessage().toCharArray()']);
end


