%GXLS_REQ_RANGE Generate request to define a range
%
% request = gxls_req_range(sheetId, range)
% 
% gxls_req_range : Generate request to define a range.
%
%       sheetId:       ID of the google sheet to edit. See also GXLS_SHEETNAME2SHEETID
%       range:         range structure.
%
%       RANGE STRUCTURE:
%           - .start_row: 0-based index of the first row.
%           - .end_row: 0-based index of the last row.
%           - .start_col: 0-based index of the first column of the range.
%           - .end_col: 0-based index of the last column of the range.
%
%       Note: all fields are optional
%
%   The output is part of the request in string format
%
%   See also GXLS_SHEETNAME2SHEETID
% ------------------------------------------------------------------------------
%   Copyright 2018 Raymond Olympio
%   Version: 1.0 
%   Date: 05-Aug-2018
% ------------------------------------------------------------------------------

function request = gxls_req_range(sheetId, range)


request = ['''sheetId'': ' num2str(sheetId)];

if isfield(range,'start_row') && ~isempty(range.start_row)
    request = [request ',''startRowIndex'': ' num2str(range.start_row)];
end
if isfield(range,'end_row') && ~isempty(range.end_row)
    request = [request ',''endRowIndex'': ' num2str(range.end_row)];
end
if isfield(range,'start_col') && ~isempty(range.start_col)        
    request = [request ',''startColumnIndex'': ' num2str(range.start_col)];
end
if isfield(range,'end_col') && ~isempty(range.end_col)    
    request = [request ',''endColumnIndex'': ' num2str(range.end_col)];
end

%encapsulate
if ~isempty(request) && request(end)==','
    request(end) = '';
end

request = ['{' request '}'];
