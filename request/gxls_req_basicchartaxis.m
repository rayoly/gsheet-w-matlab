%GXLS_REQ_BASICCHARTAXIS Generate request to define the chart specification
%
% request = gxls_req_basicchartaxis(ChartAxis)
%
% gxls_req_basicchartaxis  : Generate request to define the basic chart axis.
%
%       ChartAxis:       Chart Axis structure
%
%  CHARTAXIS STRUCTURE
%       - .title: chart's title
%       - .altText: string defining the alternative text to define the chart
%       - .titleTextFormat:
%       - .titleTextPosition:
%       - .subtitle": string
%       - .subtitleTextFormat:
%       - .subtitleTextPosition:
%       - .fontName: string indicating the font name
%       - .maximized: boolean,
%       - .backgroundColor:
%       - .hiddenDimensionStrategy:
%    And one of the following:
%       - .basicChart:
%       - .pieChart:
%       - .bubbleChart:
%       - .candlestickChart:
%       - .orgChart:
%       - .histogramChart:
%       - .waterfallChart:
%       - .treemapChart:
%
%
%  See also GXLS_REQ_COLOR, GXLS_REQ_TXTFMT, GXLS_REQ_TXTPOS
%  See Googlesheet API on "ChartSpec"
%
%   The output is part of the request in string format
%
% ------------------------------------------------------------------------------
%   Copyright 2018 Raymond Olympio
%   Version: 1.0
%   Date: 05-Aug-2018
% ------------------------------------------------------------------------------

function request = gxls_req_basicchartaxis(ChartAxis)

request = '';

for n=1:length(ChartAxis)
    request(end+1) = '{';
    %
    if isfield(ChartAxis,'position') && ~isempty(ChartAxis(n).position)
        request = [request '''position'': ''' ChartAxis(n).position ''','];
    end
    if isfield(ChartAxis,'title') && ~isempty(ChartAxis(n).title)
        request = [request '''title'': ''' ChartAxis(n).title ''','];
    end
    if isfield(ChartAxis,'format') && ~isempty(ChartAxis(n).format)
        request = [request '''format'': ''' gxls_req_txtformat(ChartAxis(n).format) ''','];
    end
    if isfield(ChartAxis,'titleposition') && ~isempty(ChartAxis(n).titleposition)
        request = [request '''titleTextPosition'': ''' gxls_req_txtpos(ChartAxis(n).titleposition) ''','];
    end
    
    %encapsulate
    if request(end)==','
        request(end) = '';
    end
    
    request = [request  '},'];
end
%
if request(end)==','
    request(end) = '';
end
% ------------------------------------------------------------------------------
function v = val2bool(value)

if value
    v = 'true';
else
    v = 'false';
end
