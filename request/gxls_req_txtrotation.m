%GXLS_REQ_TXTROTATION Generate request to set the text rotation
%
% request = gxls_req_txtrotation(txt_rotation)
% 
% gxls_req_txtrotation  : Generate request to set the text rotation.
%
%       TextRotation:       text rotation structure.
%
%       TEXTROTATION STRUCTURE:
%           - .angle: number, angle at which the text is written
%           - .vertical: boolean indicating whether the text is written verically 
%
%       Note: all fields are optional
%
%   The output is part of the request in string format
%
% ------------------------------------------------------------------------------
%   Copyright 2018 Raymond Olympio
%   Version: 1.0 
%   Date: 05-Aug-2018
% ------------------------------------------------------------------------------

function request = gxls_req_txtrotation(txt_rotation)

request = '';

if exist('txt_rotation','var') && ~isempty(txt_rotation)
    if isstruct(txt_rotation)
        if isfield(txt_rotation,'angle')
            request = [request '''angle'': ' num2str(txt_rotation.angle,'%d') ','];
        end
        if isfield(txt_rotation,'veritcal')
            if txt_rotation.vertical
                request = [request '''vertical'': True'];
            else
                request = [request '''vertical'': False'];
            end
        end        
    else
        request = [request '''angle'': ' num2str(txt_rotation,'%d')];
    end
end

if ~isempty(request) && request(end)==','
    request(end) = '';
end

request = ['{' request '}'];
