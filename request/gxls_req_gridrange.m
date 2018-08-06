%GXLS_REQ_BASICCHARTSERIES Generate request to define the basic chart series
%
% request = gxls_req_gridrange(GridRange)
% 
% gxls_req_gridrange  : Generate request to define the chart specification. 
%
%       GridRange:       Embedded Object Position structure
%  
%  GRIDRANGE STRUCTURE
%       - .sheetId: number,
%       - .startRowIndex: 
%       - .endRowIndex: 
%       - .startColumnIndex: 
%       - .endColumnIndex: 
%
%  See also GXLS_REQ_OVERLAYPOSITION
%  See Googlesheet API on "ChartSpec"
%
%   The output is part of the request in string format
%    
% ------------------------------------------------------------------------------
%   Copyright 2018 Raymond Olympio
%   Version: 1.0 
%   Date: 05-Aug-2018
% ------------------------------------------------------------------------------

function request = gxls_req_gridrange(GridRange)

request = '';

if isfield(GridRange,'sheetId') && ~isempty(GridRange.sheetId)
    request = [request '''sheetId'': ' num2str(GridRange.sheetId) ','];
end
if isfield(GridRange,'startRowIndex') && ~isempty(GridRange.startRowIndex)
    request = [request '''startRowIndex'': ' num2str(GridRange.startRowIndex) ','];
end

if isfield(GridRange,'startColumnIndex') && ~isempty(GridRange.startColumnIndex)
    request = [request '''startColumnIndex'': ' num2str(GridRange.startColumnIndex) ','];
end
if isfield(GridRange,'endRowIndex') && ~isempty(GridRange.endRowIndex)
    if GridRange.endRowIndex==GridRange.startRowIndex
        GridRange.endRowIndex = GridRange.startRowIndex+1;
    end
    request = [request '''endRowIndex'': ' num2str(GridRange.endRowIndex) ','];
end
if isfield(GridRange,'endColumnIndex') && ~isempty(GridRange.endColumnIndex)
    if GridRange.endColumnIndex==GridRange.startColumnIndex
        GridRange.endColumnIndex = GridRange.startColumnIndex+1;
    end    
    request = [request '''endColumnIndex'': ' num2str(GridRange.endColumnIndex) ','];
end

%encapsulate
if request(end)==','
    request(end) = '';
end

request = ['{' request '}'];