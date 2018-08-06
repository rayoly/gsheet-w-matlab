%GXLS_REQ_BASICCHARTSERIES Generate request to define the basic chart series
%
% request = gxls_req_basicchartseries(BasicChartSeries)
% 
% gxls_req_basicchartseries  : Generate request to define the chart specification. 
%
%       BasicChartSeries:       Embedded Object Position structure
%  
%  BASICCHARTSERIES STRUCTURE
%       - .sheetId: number,
%       - .overlayPosition": {
%       - .newSheet: boolean

%
%  See also GXLS_REQ_OVERLAYPOSITION
%  See Googlesheet API on "ChartSpec"
%
%   The output is part of the request in string format
%    
% ------------------------------------------------------------------------------
%   Copyright 2018 Raymond Olympio
%   Version: 1.0 
%   Date: 05-Aug-2018
% ------------------------------------------------------------------------------

function request = gxls_req_basicchartseries(BasicChartSeries)

request = '';

if isfield(BasicChartSeries,'series') && ~isempty(BasicChartSeries.series)
    request = [request '''series'': ' gxls_req_chartdata(BasicChartSeries.series) ','];
end
if isfield(BasicChartSeries,'targetAxis') && ~isempty(BasicChartSeries.targetAxis)
    request = [request '''targetAxis'': ' BasicChartSeries.targetAxis ','];
end
if isfield(BasicChartSeries,'type') && ~isempty(BasicChartSeries.type)
    request = [request '''type'': ' BasicChartSeries.type ','];
end
if isfield(BasicChartSeries,'lineStyle') && ~isempty(BasicChartSeries.lineStyle)
    request = [request '''lineStyle'': ' gxls_req_linestyle(BasicChartSeries.lineStyle) ','];
end
if isfield(BasicChartSeries,'color') && ~isempty(BasicChartSeries.color)
    request = [request '''color'': ' gxls_req_color(BasicChartSeries.color) ','];
end

%encapsulate
if request(end)==','
    request(end) = '';
end

request = ['{' request '}'];