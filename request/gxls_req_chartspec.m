%GXLS_REQ_CHARTSPEC Generate request to define the chart specification
%
% request = gxls_req_chartspec(ChartSpec)
% 
% gxls_req_chartspec  : Generate request to define the chart specification. 
%
%       ChartSpec:       Chart specification structure
%  
%  CHARTSPEC STRUCTURE
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

function request = gxls_req_chartspec(ChartSpec)

request = '';
if isfield(ChartSpec,'title') && ~isempty(ChartSpec.title)
    request = [request '''title'': ''' ChartSpec.title ''','];
end
if isfield(ChartSpec,'altText') && ~isempty(ChartSpec.altText)
    request = [request '''altText'': ''' ChartSpec.altText ''','];
end
if isfield(ChartSpec,'titleTextFormat') && ~isempty(ChartSpec.titleTextFormat)
    request = [request '''titleTextFormat'': ' gxls_req_txtformat(ChartSpec.titleTextFormat) ','];
end
if isfield(ChartSpec,'titleTextPosition') && ~isempty(ChartSpec.titleTextPosition)
    request = [request '''titleTextPosition'': ' gxls_req_txtpos(ChartSpec.titleTextPosition) ','];
end
%
if isfield(ChartSpec,'subtitle') && ~isempty(ChartSpec.subtitle)
    request = [request '''subtitle'': ''' ChartSpec.subtitle ''','];
end
if isfield(ChartSpec,'subtitleTextFormat') && ~isempty(ChartSpec.subtitleTextFormat)
    request = [request '''subtitleTextFormat'': ' gxls_req_txtformat(ChartSpec.subtitleTextFormat) ','];
end
if isfield(ChartSpec,'subtitleTextPosition') && ~isempty(ChartSpec.subtitleTextPosition)
    request = [request '''subtitleTextPosition'': ' gxls_req_txtpos(ChartSpec.subtitleTextPosition) ','];
end

%
if isfield(ChartSpec,'fontName') && ~isempty(ChartSpec.fontName)
    request = [request '''fontName'': ''' ChartSpec.fontName ''','];
end
if isfield(ChartSpec,'maximized') && ~isempty(ChartSpec.maximized)
    request = [request '''maximized'': ' val2bool(ChartSpec.maximized) ','];
end
%
if isfield(ChartSpec,'backgroundColor') && ~isempty(ChartSpec.backgroundColor)
    request = [request '''backgroundColor'': ' gxls_req_color(ChartSpec.backgroundColor) ','];
end
%
if isfield(ChartSpec,'hiddenDimensionStrategy') && ~isempty(ChartSpec.hiddenDimensionStrategy)
    request = [request '''hiddenDimensionStrategy'': ''' ChartSpec.hiddenDimensionStrategy ''','];
end
%
chart_types = {'basicChart','pieChart','bubbleChart','candlestickChart','orgChart','histogramChart','waterfallChart','treemapChart'};
for n=1:length(chart_types)
    field = chart_types{n};
    if isfield(ChartSpec,field) && ~isempty(ChartSpec.(field))
        request = [request '''' chart_types{n} ''': ' gxls_req_chart(ChartSpec.(field),field) ','];
        break;
    end
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
