%GXLS_REQ_TREEMAPCHARTCOLORSCALE Generate request to define a color scale
%
% request = gxls_req_color(color)
% 
% gxls_req_treemapchartcolorscale  : Generate request to define a color scale.
%
%       color:       color structure.
%
%       COLORSCALE STRUCTURE: 
%           - .min: the color for cells with a value less than or equal to min value
%           - .max: the color for cells with a value greater than or equal to max value. 
%           - .mid: the color for cells with a value at the midpoint between min and max values. 
%           - .nodata: the color for cells that have no value.
%
%       
%       Note: all fields are optional
%
%   The output is part of the request in string format
%
%   See also GXLS_REQ_COLOR, Googlesheets API's COLOR
% ------------------------------------------------------------------------------
%   Copyright 2018 Raymond Olympio
%   Version: 1.0 
%   Date: 05-Aug-2018
% ------------------------------------------------------------------------------

function request = gxls_req_treemapchartcolorscale(color_scale)
request = '';
% ------------------------------------------------------------------------- Blue
if isfield(color_scale,'min')
    request = [request '''minValueColor'': ' gxls_req_color(color.min) ','];
end
% -------------------------------------------------------------------------- Red
if isfield(color_scale,'mid')
    request = [request '''midValueColor'': ' gxls_req_color(color_scale.mid) ','];
end
% ------------------------------------------------------------------------- Green
if isfield(color_scale,'max')        
    request = [request '''maxValueColor'': ' gxls_req_color(color_scale.max) ','];
end
% ------------------------------------------------------------------------ Alpha
if isfield(color_scale,'nodata')        
    request = [request '''noDataColor'': ' gxls_req_color(color_scale.nodata)];
end

%encapsulate
if ~isempty(request) && request(end)==','
    request(end) = '';
end

request = ['{' request '}'];
