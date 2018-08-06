%GXLS_REQ_TXTFORMAT Generate request to set up the text formatting.
%
% request = gxls_req_txtformat(font_prop)
% 
% gxls_req_txtformat  : Generate request to set up the text formatting.
%
%       font_prop:       font property structure.
%
%       FONT PROPERTY STRUCTURE:
%           - .foregroundcolor: Color object to set up the foregound. 
%                   See GXLS_REQ_COLOR.
%           - .fontfamily: string to indicate the font name
%           - .fontsize: number to set the font size
%           - .bold:  boolean to indicate whether the text is bold or not.
%           - .italic: boolean to indicate whether the text is italic or not.
%           - .strikethrough: boolean to indicate whether the text is struck through or not.
%           - .underline: boolean to indicate whether the text is underlined or not.
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

function request = gxls_req_txtformat(font_prop)

request = '';

% ------------------------------------------------------------- foregroung color
if isfield(font_prop,'foregroundcolor') && ~isempty(font_prop.foregroundcolor)
    request = [request '''foregroundColor'': '  gxls_req_color(font_prop.foregroundcolor)  ','];
end
% ------------------------------------------------------------------ font family
if isfield(font_prop,'fontfamily') && ~isempty(font_prop.fontfamily)
  request = [request '''fontFamily'': ''' font_prop.fontfamily ''','];
end
% -------------------------------------------------------------------- font size
if isfield(font_prop,'fontsize') && ~isempty(font_prop.fontsize)
  request = [request '''fontSize'': ' num2str(font_prop.fontsize) ','];
end
% -------------------------------------------------------------------- bold
if isfield(font_prop,'bold') && ~isempty(font_prop.bold)
  request = [request '''bold'': ' val2bool(font_prop.bold) ','];
end
% -------------------------------------------------------------------- italic
if isfield(font_prop,'italic') && ~isempty(font_prop.italic)
  request = [request '''italic'': ' val2bool(font_prop.italic) ','];
end
% -------------------------------------------------------------------- strikethrough
if isfield(font_prop,'strikethrough') && ~isempty(font_prop.strikethrough)
  request = [request '''strikethrough'': ' val2bool(font_prop.strikethrough) ','];
end
% -------------------------------------------------------------------- underline
if isfield(font_prop,'underline') && ~isempty(font_prop.underline)
  request = [request '''underline'': ' val2bool(font_prop.underline)];
end


%encapsulate
if ~isempty(request) && request(end)==','
    request(end) = '';
end

request = ['{' request '}'];

% ------------------------------------------------------------------------------
function v = val2bool(value)

if value
    v = 'true';
else
    v = 'false';
end
