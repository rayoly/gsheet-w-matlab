%GXLS_REQ_TXTPOS Generate request to define the text position
%
% request = gxls_req_txtpos(TextPosition)
% 
% gxls_req_txtpos  : Generate request to define the text position. 
%
%           TextPosition: Structure defining the text position
%
%   TEXTPOSITION STRUCTURE:
%       .horizontalAlignment: string indicating the horizontal alignement. Can be
%                    one of the following: 'LEFT', 'RIGHT', 'CENTER'.
%
%  See Googlesheet API on "ChartSpec"
%
%   The output is part of the request in string format
%    
% ------------------------------------------------------------------------------
%   Copyright 2018 Raymond Olympio
%   Version: 1.0 
%   Date: 05-Aug-2018
% ------------------------------------------------------------------------------

function request = gxls_req_txtpos(TextPosition)

request = '';

if isfield(TextPosition,'horizontalAlignment') && ~isempty(TextPosition.horizontalAlignment)
    request = [request '''horizontalAlignment'': ''' TextPosition.horizontalAlignment ''''];
end

%encapsulate
if ~isempty(request) && request(end)==','
    request(end) = '';
end

request = ['{' request '}'];
