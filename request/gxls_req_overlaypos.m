%GXLS_REQ_OVERLAYPOS Generate request to define the location of an object overlaid on the grid
%
% request = gxls_req_overlaypos(OverlayPos)
% 
% gxls_req_overlaypos  : Generate request to define the location of an object overlaid on the grid.
%
%       OverlayPos:       Embedded Object Position structure
%  
%  OVERLAYPOS STRUCTURE
%       - .anchorCell: GridCoordinates structure, see GXLS_REQ_GRIDCOORD
%       - .offsetXPixels: horizontal offset in pixels
%       - .offsetYPixels: vertical offset in pixels
%       - .widthPixels: width of the object in pixels
%       - .heightPixels: height of the object in pixels
%
%  See also GXLS_REQ_GRIDCOORD
%  See Googlesheet API on "OverlayPosition"
%
%   The output is part of the request in string format
%    
% ------------------------------------------------------------------------------
%   Copyright 2018 Raymond Olympio
%   Version: 1.0 
%   Date: 05-Aug-2018
% ------------------------------------------------------------------------------

function request = gxls_req_overlaypos(OverlayPos)

request = '';

if isfield(OverlayPos,'anchorCell') && ~isempty(OverlayPos.anchorCell)
    request = [request '''anchorCell'': ' gxls_req_gridcoord(OverlayPos.anchorCell) ','];
end
if isfield(OverlayPos,'offsetxpixels') && ~isempty(OverlayPos.offsetxpixels)
    request = [request '''offsetXPixels'': ' OverlayPos.offsetxpixels ','];
end
if isfield(OverlayPos,'offsetypixels') && ~isempty(OverlayPos.offsetypixels)
    request = [request '''offsetYPixels'': ' OverlayPos.offsetypixels ','];
end
if isfield(OverlayPos,'widthpix') && ~isempty(OverlayPos.widthpix)
    request = [request '''widthPixels'': ' OverlayPos.widthpix ','];
end
if isfield(OverlayPos,'heightpix') && ~isempty(OverlayPos.heightpix)
    request = [request '''heightPixels'': ' OverlayPos.heightpix ','];
end

%encapsulate
if request(end)==','
    request(end) = '';
end

request = ['{' request '}'];