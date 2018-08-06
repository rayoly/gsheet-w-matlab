%GXLS_REQ_EXTENDEDVALUE Generate request to set up an extendedvalue
%
% request = gxls_req_extendedvalue(value, type)
% 
% gxls_req_extendedvalue  : Generate request to set up a border.
%
%       value:       value.
%       type:        type of value. Can be one of the following: 'number', 'string', 'bool'
%
%   The output is part of the request in string format
%
% ------------------------------------------------------------------------------
%   Copyright 2018 Raymond Olympio
%   Version: 1.0 
%   Date: 05-Aug-2018
% ------------------------------------------------------------------------------

%
function request = gxls_req_extendedvalue(value, type)

request = '';
if ~exist('type','var')
    type = '';
end

% Union field value can be only one of the following:
if isnumeric(value) || strcmpi(type,'number')
    request = [request '''numberValue'': ' num2str(value) ];
elseif ischar(value) || strcmpi(type,'string')
    request = [request '''stringValue'': ' value ];
elseif islogical(value) || strcmpi(type,'bool')
    if value
        value = 'true';
    else
        value = 'false';
    end
    request = [request '''boolValue'': ' value ];
elseif strcmpi(type,'formula')
    request = [request '''formulaValue'': ' value ];
elseif strcmpi(type,'error')
    request = [request '''errorValue'': ' gxls_req_errorval(value)];
end

request = ['{' request '}'];