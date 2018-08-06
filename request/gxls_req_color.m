%GXLS_REQ_COLOR Generate request to define the color 
%
% request = gxls_req_color(color)
% 
% gxls_req_color  : Generate request to set up a color.
%
%       color:       color structure.
%
%       COLOR STRUCTURE: 
%           - .red: amount of red in the RGB space. Defined in [0-1].
%           - .green: amount of green in the RGB space. Defined in [0-1].
%           - .blue: amount of blue in the RGB space. Defined in [0-1].
%           - .alpha: Fraction of the color that should be applied. Defined in [0-1].
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

function request = gxls_req_color(color)
request = '';
% ------------------------------------------------------------------------- Blue
if isfield(color,'blue')
    request = [request '''blue'': ' check_color(color.blue) ','];
end
% -------------------------------------------------------------------------- Red
if isfield(color,'red')
    request = [request '''red'': ' check_color(color.red)  ','];
end
% ------------------------------------------------------------------------- Green
if isfield(color,'green')        
    request = [request '''green'': ' check_color(color.green) ','];
end
% ------------------------------------------------------------------------ Alpha
if isfield(color,'alpha')        
    request = [request '''alpha'': ' check_color(color.alpha)];
end

%encapsulate
if request(end)==','
    request(end) = '';
end

request = ['{' request '}'];

% ------------------------------------------------------------------------------
% Make sure the color is defined in the right format
% ------------------------------------------------------------------------------
function c = check_color(col)

if ~ischar(col)
    if col>1
        col = min(1,col/256);
    elseif col<0
        col = 0;
    end
    c = num2str(col,'%.1f');
else
    c = col;
end
