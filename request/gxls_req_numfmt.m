%GXLS_REQ_NUMFMT Generate request to set up a number format
%
% request = gxls_req_numfmt(ntype, npattern)
% 
% gxls_req_numfmt  : Generate request to set up a number format. 
%
%       ntype:       The type of the number format.
%       npattern:    Pattern string used for formatting.
%       
%  See Googlesheet API on "NumberFormat"
%
%   The output is part of the request in string format
%    
% ------------------------------------------------------------------------------
%   Copyright 2018 Raymond Olympio
%   Version: 1.0 
%   Date: 05-Aug-2018
% ------------------------------------------------------------------------------

function request = gxls_req_numfmt(ntype, npattern)

request = '';
if exist('ntype','var')
    request = [request '''type'': ''' ntype ''','];
end
if exist('npattern','var')
    request = [request '''pattern'': ''' npattern ''''];
end

%encapsulate
if request(end)==','
    request(end) = '';
end

request = ['{' request '}'];