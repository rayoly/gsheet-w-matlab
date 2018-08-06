%GXLS_REQ_CHARTDATA Generate request to define the basic chart data
%
% request = gxls_req_chartdata(ChartData)
% 
% gxls_req_chartdata  : Generate request to define the chart specification. 
%
%       ChartData:       Structure for the data included in a domain or series
%  
%  CHARTDATA STRUCTURE
%       - .sourceRange: ChartSourceRange object structure
%
%  See also GXLS_REQ_CHARTSOURCERANGE
%
%   The output is part of the request in string format
%    
% ------------------------------------------------------------------------------
%   Copyright 2018 Raymond Olympio
%   Version: 1.0 
%   Date: 05-Aug-2018
% ------------------------------------------------------------------------------

function request = gxls_req_chartdata(ChartData)

request = '';

if isfield(ChartData,'sourceRange') && ~isempty(ChartData.sourceRange)
    request = [request '''sourceRange'': ' gxls_req_chartsourcerange(ChartData.sourceRange) ','];
end
%encapsulate
if request(end)==','
    request(end) = '';
end

request = ['{' request '}'];