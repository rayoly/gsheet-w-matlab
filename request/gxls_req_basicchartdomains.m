%GXLS_REQ_BASICCHARTDOMAINS Generate request to define the domain of a basic chart
%
% request = gxls_req_basicchartdomains(domains)
%
% gxls_req_basicchartdomains  : Generate request to define the domain of a basic chart.
%
%       domain:       domain structure.
%
%       DOMAIN STRUCTURE:
%           - .domain: amount of red in the RGB space. Defined in [0-1].
%           - .reversed: amount of green in the RGB space. Defined in [0-1].
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

function request = gxls_req_basicchartdomains(domains)
request = '';
% ------------------------------------------------------------------------- Blue
for n=1:length(domains)
    request = [request '{'];
    if isfield(domains,'domain') && ~isempty(domains(n).domain)
        request = [request '''domain'': ' gxls_req_chartdata(domains.domain) ','];
    end
    % -------------------------------------------------------------------------- Red
    if isfield(domains,'reversed')
        request = [request '''reversed'': ' val2bool(domains.reversed) ];
    end
    if ~isempty(request) && request(end)==','
        request(end) = '';
    end
    request = [request '},'];
end
%encapsulate
if ~isempty(request) && request(end)==','
    request(end) = '';
end


