%GXLS_REQ_CELLFORMAT Generate request to set up a cellformat
%
% request = gxls_req_cellformat(cellformat)
% 
% xlsborder  : Generate request to set up a cellformat.
%
%       cellformat:       cellformat structure.
%
%       CELLFORMAT STRUCTURE:
%           - .numberformat: number format object. See GXLS_REQ_NUMFMT.
%           - .backgroundcolor: color object. See GXLS_REQ_COLOR.
%           - .borders: borders object. See GXLS_REQ_BORDER.
%           - .padding: padding object. See GXLS_REQ_PADDING.
%           - .horiz_align: string indicating the horizontal alignement. Can be
%                    one of the following: 'LEFT', 'RIGHT', 'CENTER'.
%           - .vert_align: string indicating the horizontal alignement. Can be
%                    one of the following: 'TOP', 'MIDDLE', 'BOTTOM'.
%           - .wrap: string indicating the wrapping strategy. Can be one of the
%                    following: 'OVERFLOW_CELL', 'LEGACY_WRAP', 'CLIP', 'WRAP'
%           - .txt_dir: string indicating the text direction. Can be one of the
%                    following: 'RIGHT_TO_LEFT', 'LEFT_TO_RIGHT'.
%           - .textformat: Text format object. See GXLS_REQ_TXTFORMAT.
%           - .hyperlinkdisplaytype: string indicating the hyperling rendering. 
%                    Can be one of the following: 'LINKED', 'PLAIN_TEXT'
%           - .txt_rotation: TextRotation object. See GXLS_RES_TXTROTATION.
%
%       Note: all fields are optional
%
%   The output is part of the request in string format
%
%   See also GXLS_REQ_NUMFMT, GXLS_REQ_BORDER, GXLS_REQ_COLOR
%   See Googlesheet API Reference.
% ------------------------------------------------------------------------------
%   Copyright 2018 Raymond Olympio
%   Version: 1.0 
%   Date: 05-Aug-2018
% ------------------------------------------------------------------------------
function request = gxls_req_cellformat(cellformat)

request = '';

if ~isstruct(cellformat)
    return;
end

% Number format
if isfield(cellformat,'numberformat') && ~isempty(cellformat.numberformat)
    request = [request '''numberFormat'': ''' gxls_req_numfmt(cellformat.numberFormat) ''','];
end
% - Background color
if isfield(cellformat,'backgroundcolor') && ~isempty(cellformat.backgroundcolor)
    request = [request '''backgroundColor'': ' gxls_req_color(cellformat.backgroundcolor) ','];
end
% Borders
if isfield(cellformat,'borders') && ~isempty(cellformat.borders)
    request = [request '''borders'': ''' gxls_req_borders(cellformat.borders) ''','];
end
%Padding
if isfield(cellformat,'padding') && ~isempty(cellformat.padding)
    request = [request '''padding'': ''' gxls_req_padding(cellformat.padding) ''','];
end
% Horizontal alignment
if isfield(cellformat,'horiz_align') && ~isempty(cellformat.horiz_align)
    request = [request '''horizontalAlignment'': ''' cellformat.horiz_align ''','];
end
% ----------------------------------------------------------- Vertical alignment
if isfield(cellformat,'vert_align') && ~isempty(cellformat.vert_align)
    request = [request '''verticalAlignment'': ''' cellformat.vert_align ''','];
end
% ---------------------------------------------------------------- Wrap strategy
if isfield(cellformat,'wrap') && ~isempty(cellformat.wrap)
    request = ['''wrapStrategy'': ''' cellformat.wrap ''','];
end
% --------------------------------------------------------------- text direction
if isfield(cellformat,'txt_dir') && ~isempty(cellformat.txt_dir)
    request = ['''textDirection'': ''' cellformat.txt_dir ''','];
end
% ------------------------------------------------------------------ Text Format
if isfield(cellformat,'textformat') && ~isempty(cellformat.textformat)
    request = [request '''textFormat'': ' gxls_req_txtformat(cellformat.textformat) ','];
end
% -------------------------------------------------------- Hyperlink disply type
if isfield(cellformat,'hyperlinkdisplaytype') && ~isempty(cellformat.hyperlinkdisplaytype)
    request = [request '''hyperlinkDisplayType'': ' gxls_req_hldisptype(cellformat.hyperlinkdisplaytype) ''','];
end
% ---------------------------------------------------------------- Text rotation
if isfield(cellformat,'txt_rotation') && ~isempty(cellformat.txt_rotation)
    request = ['''textRotation'': ' gxls_req_txtrotation(cellformat.txt_rotation) ','];
end

%encapsulate
if request(end)==','
    request(end) = '';
end

request = ['{' request '}'];
