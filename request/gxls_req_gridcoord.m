%GXLS_REQ_EMBEDDEDOBJECTPOS Generate request to define the chart specification
%
% request = gxls_req_gridcoord(EOBJECTPOS)
%
% gxls_req_chartspec  : Generate request to define the chart specification.
%
%       EOBJECTPOS:       Embedded Object Position structure
%
%  EOBJECTPOS STRUCTURE
%       - .sheetId: ID of the sheet where to add/edit the embedded object
%       - .overlayPosition: OverlayPosition object. See GXLS_REQ_OVERLAYPOS
%       - .newSheet: boolean indicating whether the object should be added to a new sheet

%
%  See also GXLS_REQ_OVERLAYPOS
%  See Googlesheet API on "ChartSpec"
%
%   The output is part of the request in string format
%
% ------------------------------------------------------------------------------
%   Copyright 2018 Raymond Olympio
%   Version: 1.0
%   Date: 05-Aug-2018
% ------------------------------------------------------------------------------

function request = gxls_req_gridcoord(GridCoordinate)

request = '';

if isfield(GridCoordinate,'sheetId') && ~isempty(GridCoordinate.sheetId)
    request = [request '''sheetId'': ' num2str(GridCoordinate.sheetId) ','];
end
if isfield(GridCoordinate,'rowIndex') && ~isempty(GridCoordinate.rowIndex)
    request = [request '''rowIndex'': ' num2str(GridCoordinate.rowIndex) ','];
end
if isfield(GridCoordinate,'columnIndex') && ~isempty(GridCoordinate.columnIndex) 
    request = [request '''columnIndex'': ' num2str(GridCoordinate.columnIndex) ','];
end 

%encapsulate
if request(end)==','
    request(end) = '';
end

request = ['{' request '}'];
