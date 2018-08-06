%GXLS_REQ_EMBEDDEDOBJECTPOS Generate request to define the chart specification
%
% request = gxls_req_embeddedobjectpos(EOBJECTPOS)
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

function request = gxls_req_embeddedobjectpos(EObjectPos)

request = '';

if isfield(EObjectPos,'sheetId') && ~isempty(EObjectPos.sheetId)
    request = [request '''sheetId'': ' num2str(EObjectPos.sheetId) ','];
end
if isfield(EObjectPos,'overlayPosition') && ~isempty(EObjectPos.overlayPosition)
    request = [request '''overlayPosition'': ' gxls_req_overlaypos(EObjectPos.overlayPosition) ','];
end
if isfield(EObjectPos,'newSheet') && ~isempty(EObjectPos.newSheet) && EObjectPos.newSheet
    request = [request '''newSheet'': true,']; %can only be true
end 

%encapsulate
if request(end)==','
    request(end) = '';
end

request = ['{' request '}'];
