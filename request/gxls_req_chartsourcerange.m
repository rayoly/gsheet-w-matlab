%GXLS_REQ_CHARTSOURCERANGE Generate request to define the chart source range
%
% request = gxls_req_chartsourcerange(BasicChartSeries)
%
% gxls_req_chartsourcerange  : Generate request to define the chart source range.
%
%       ChartSourceRange:       Embedded Object Position structure
%
%  BASICCHARTSERIES STRUCTURE
%       - .sources: Grid Range structure, see GLX_REQ_GRIDRANGE
%
%  See also GLX_REQ_GRIDRANGE
%
%   The output is part of the request in string format
%
% ------------------------------------------------------------------------------
%   Copyright 2018 Raymond Olympio
%   Version: 1.0
%   Date: 05-Aug-2018
% ------------------------------------------------------------------------------

function request = gxls_req_chartsourcerange(ChartSourceRange)

request = '';

if isfield(ChartSourceRange,'sources') && ~isempty(ChartSourceRange.sources)
    request = [request '''sources'': ['];
    
    for n=1:length(ChartSourceRange.sources)
        request = [request gxls_req_gridrange(ChartSourceRange.sources) ','];
    end
    if request(end)==','
        request(end) = '';
    end
    request = [request '],'];
end
%encapsulate
if request(end)==','
    request(end) = '';
end
request = ['{' request '}'];
    
