%GXLS_REQ_BORDER Generate request to set up a border
%
% request = gxls_req_border(border_style)
% 
% gxls_req_border  : Generate request to set up a border.
%
%       border_style:       border structure.
%
%       BORDER STRUCTURE:
%           - .style: string indicating the border style. As per Googlesheet API, 
%                     it can be one of the following:
%                       DOTTED	The border is dotted.
%                       DASHED	The border is dashed.
%                       SOLID	The border is a thin solid line.
%                       SOLID_MEDIUM	The border is a medium solid line.
%                       SOLID_THICK	The border is a thick solid line.
%                       NONE	No border. Used only when updating a border in order to erase it.
%                       DOUBLE	The border is two solid lines.
%           - .width: number 
%           - .color: color object. See GXLS_REQ_COLOR
%
%       Note: all fields are optional
%
%   The output is part of the request in string format
%
%   See also GXLS_REQ_COLOR
% ------------------------------------------------------------------------------
%   Copyright 2018 Raymond Olympio
%   Version: 1.0 
%   Date: 05-Aug-2018
% ------------------------------------------------------------------------------

function request = gxls_req_border(border_style)

request = '';

% ------------------------------------------------------------------------ style
if isfield(border_style,'style') && ~isempty(border_style.style)
    request = [request '''style'':''' border_style.style ''','];
end
% ------------------------------------------------------------------------ width
if isfield(border_style,'width') && ~isempty(border_style.width)
    request = [request '''width'':' (border_style.width) ','];
end
% ------------------------------------------------------------------------ color
if isfield(border_style,'color') && ~isempty(border_style.color)
    request = [request '''color'': ' gxls_req_color(border_style.color)];
end

%encapsulate
if request(end)==','
    request(end) = '';
end

request = ['{' request '}'];
