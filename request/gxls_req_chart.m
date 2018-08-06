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

function request = gxls_req_chart(ChartSpec, type)

request = '';

switch type
    case {'basic','basicChart'}
        %Chart type, mandatory input
        if isfield(ChartSpec,'charttype') && ~isempty(ChartSpec.charttype)
            request = [request '''chartType'': ''' ChartSpec.charttype ''','];
        else
            ChartSpec.charttype = 'SCATTER';
            fprintf(2,'%s:no chart type specified. Assuming SCATTER\n',mfilename);
            request = [request '''chartType'': ''SCATTER'','];
        end
        if strcmp(ChartSpec.charttype,'SCATTER')
            ChartSpec.stackedType = [];
            ChartSpec.lineSmoothing = [];
        end
        %
        if isfield(ChartSpec,'BasicChartLegendPosition') && ~isempty(ChartSpec.BasicChartLegendPosition)
            request = [request '''legendPosition'': ''' ChartSpec.BasicChartLegendPosition ''','];
        end
        if isfield(ChartSpec,'axis') && ~isempty(ChartSpec.axis)
            request = [request '''axis'': [' gxls_req_basicchartaxis(ChartSpec.axis) '],'];
        end
        if isfield(ChartSpec,'domains') && ~isempty(ChartSpec.domains)
            request = [request '''domains'': [' gxls_req_basicchartdomains(ChartSpec.domains) '],'];
        end
        if isfield(ChartSpec,'series') && ~isempty(ChartSpec.series)
            request = [request '''series'': [ ' gxls_req_basicchartseries(ChartSpec.series) '],'];
        end
        if isfield(ChartSpec,'headercount') && ~isempty(ChartSpec.headercount)
            request = [request '''headerCount'': ' num2str(ChartSpec.headercount) ','];
        end
        if isfield(ChartSpec,'dim3D') && ~isempty(ChartSpec.dim3D)
            request = [request '''threeDimensional'': ' val2bool(ChartSpec.dim3D) ','];
        end
        if isfield(ChartSpec,'interpolateNulls') && ~isempty(ChartSpec.interpolateNulls)
            request = [request '''interpolateNulls'': ' val2bool(ChartSpec.interpolateNulls) ','];
        end
        if isfield(ChartSpec,'stackedType') && ~isempty(ChartSpec.stackedType)
            request = [request '''stackedType'': ''' ChartSpec.stackedType ''','];
        end
        if isfield(ChartSpec,'lineSmoothing') && ~isempty(ChartSpec.lineSmoothing)
            request = [request '''lineSmoothing'': '  val2bool(ChartSpec.lineSmoothing) ','];
        end
        if isfield(ChartSpec,'compareMode') && ~isempty(ChartSpec.compareMode)
            request = [request '''compareMode'': ''' ChartSpec.compareMode ''','];
        end
        
    case {'pie','piechart'}
        if isfield(ChartSpec,'PieChartLegendPosition') && ~isempty(ChartSpec.PieChartLegendPosition)
            request = [request '''legendPosition'': ''' ChartSpec.PieChartLegendPosition ''','];
        end
        if isfield(ChartSpec,'ChartDomain') && ~isempty(ChartSpec.ChartDomain)
            request = [request '''domains'': [' gxls_req_basicchartdomains(ChartSpec.ChartDomain) '],'];
        end
        if isfield(ChartSpec,'ChartSeries') && ~isempty(ChartSpec.ChartSeries)
            request = [request '''series'': [ ' gxls_req_basicchartseries(ChartSpec.ChartSeries) '],'];
        end
        if isfield(ChartSpec,'dim3D') && ~isempty(ChartSpec.dim3D)
            request = [request '''threeDimensional'': ' val2bool(ChartSpec.dim3D) ','];
        end
        if isfield(ChartSpec,'piehole') && ~isempty(ChartSpec.piehole)
            request = [request '''pieHole'': ' num2str(ChartSpec.piehole) ','];
        end
    case {'bubble','bubblechart'}
        if isfield(ChartSpec,'BubbleChartLegendPosition') && ~isempty(ChartSpec.BubbleChartLegendPosition)
            request = [request '''legendPosition'': ' ChartSpec.BubbleChartLegendPosition ','];
        end
   
        if isfield(ChartSpec,'ChartDomain') && ~isempty(ChartSpec.ChartDomain)
            request = [request '''domains'': [' gxls_req_basicchartdomains(ChartSpec.ChartDomain) '],'];
        end
        if isfield(ChartSpec,'ChartSeries') && ~isempty(ChartSpec.ChartSeries)
            request = [request '''series'': [ ' gxls_req_basicchartseries(ChartSpec.ChartSeries) '],'];
        end
        if isfield(ChartSpec,'ChartData') && ~isempty(ChartSpec.ChartData) 
            if isfield(ChartSpec.ChartData,'bubbleLabels') && ~isempty(ChartSpec.ChartData.bubbleLabels)
                request = [request '''bubbleLabels'': ' gxls_req_chartdata(ChartSpec.ChartData.bubbleLabels) ','];
            end
            if isfield(ChartSpec.ChartData,'groupIds') && ~isempty(ChartSpec.ChartData.groupIds)
                request = [request '''groupIds'':  ' gxls_req_chartdata(ChartSpec.ChartData.groupIds) ','];
            end
            if isfield(ChartSpec.ChartData,'bubbleSizes') && ~isempty(ChartSpec.ChartData.bubbleSizes)
                request = [request '''bubbleSizes'':  ' gxls_req_chartdata(ChartSpec.ChartData.bubbleSizes) ','];
            end
        end
        if isfield(ChartSpec,'bubbleopacity') && ~isempty(ChartSpec.bubbleopacity)
            request = [request '''bubbleOpacity'': ' num2str(ChartSpec.bubbleopacity) ','];
        end
        if isfield(ChartSpec,'bordercolor') && ~isempty(ChartSpec.bordercolor)
            request = [request '''bubbleBorderColor'': ' gxls_req_color(ChartSpec.bordercolor) ','];
        end
        if isfield(ChartSpec,'maxradius') && ~isempty(ChartSpec.maxradius)
            request = [request '''bubbleMaxRadiusSize'': ' num2str(ChartSpec.maxradius) ','];
        end
        if isfield(ChartSpec,'minradius') && ~isempty(ChartSpec.minradius)
            request = [request '''bubbleMinRadiusSize'': ' num2str(ChartSpec.minradius) ','];
        end
        if isfield(ChartSpec,'txtstyle') && ~isempty(ChartSpec.txtstyle)
            request = [request '''bubbleTextStyle'': ' gxls_req_txtformat(ChartSpec.txtstyle) ','];
        end
    case {'candle','candlestick'}
        if isfield(ChartSpec,'ChartDomain') && ~isempty(ChartSpec.ChartDomain)
            request = [request '''domains'': [' gxls_req_basicchartdomains(ChartSpec.ChartDomain) '],'];
        end
        if isfield(ChartSpec,'Candlestickdata') && ~isempty(ChartSpec.Candlestickdata)
            request = [request '''data'': [' gxls_req_candlestickdata(ChartSpec.Candlestickdata) ']'];
        end
    case {'org','orgchart'}
        if isfield(ChartSpec,'OrgChartNodeSize') && ~isempty(ChartSpec.OrgChartNodeSize)
            request = [request '''nodeSize'': ' ChartSpec.OrgChartNodeSize ','];
        end
        if isfield(ChartSpec,'nodecolor') && ~isempty(ChartSpec.nodecolor)
            request = [request '''nodeColor'': ' gxls_req_color(ChartSpec.nodecolor) ','];
        end
        if isfield(ChartSpec,'selnodecolor') && ~isempty(ChartSpec.selnodecolor)
            request = [request '''selectedNodeColor'': ' gxls_req_color(ChartSpec.selnodecolor) ','];
        end
 
        if isfield(ChartSpec,'ChartData') && ~isempty(ChartSpec.ChartData)
            if isfield(ChartSpec.ChartData,'parentLabels') && ~isempty(ChartSpec.ChartData.parentLabels)
                request = [request '''parentLabels'': ' gxls_req_chartdata(ChartSpec.ChartData.parentLabels)  ','];
            end
            if isfield(ChartSpec.ChartData,'labels') && ~isempty(ChartSpec.ChartData.labels)
                request = [request '''labels'': ' gxls_req_chartdata(ChartSpec.ChartData.labels)  ','];
            end
            if isfield(ChartSpec.ChartData,'tooltips') && ~isempty(ChartSpec.ChartData.tooltips)
                request = [request '''tooltips'': ' gxls_req_chartdata(ChartSpec.ChartData.tooltips)  ','];
            end
        end
    case {'histogram','histogramchart'}
        if isfield(ChartSpec,'chartseries') && ~isempty(ChartSpec.chartseries)
            request = [request '''series'': [ ' gxls_req_basicchartseries(ChartSpec.chartseries) '],'];
        end
        if isfield(ChartSpec,'histogramchartlegendposition') && ~isempty(ChartSpec.histogramchartlegendposition)
            request = [request '''legendPosition'': ' ChartSpec.histogramchartlegendposition ','];
        end
        if isfield(ChartSpec,'showitemdividers') && ~isempty(ChartSpec.showitemdividers)
            request = [request '''showItemDividers'': ' val2bool(ChartSpec.showitemdividers) ','];
        end
        if isfield(ChartSpec,'bucketsize') && ~isempty(ChartSpec.bucketsize)
            request = [request '''bucketSize'':  ' num2str(ChartSpec.bucketsize) ','];
        end
        if isfield(ChartSpec,'outlierpercentile') && ~isempty(ChartSpec.outlierpercentile)
            request = [request '''outlierPercentile'':  ' num2str(ChartSpec.outlierpercentile) ','];
        end
    case {'waterfall','waterfallchart'}
        if isfield(ChartSpec,'Candlestickdata') && ~isempty(ChartSpec.Candlestickdata)
            request = [request '''domains'': [' gxls_req_basicchartdomains(ChartSpec.ChartDomain) '],'];
        end
        if isfield(ChartSpec,'Candlestickdata') && ~isempty(ChartSpec.Candlestickdata)
            request = [request '''series'': [ ' gxls_req_basicchartseries(ChartSpec.ChartSeries) '],'];
        end
        if isfield(ChartSpec,'Candlestickdata') && ~isempty(ChartSpec.Candlestickdata)
            request = [request '''stackedType'': ' WaterfallChartStackedType ','];
        end
        if isfield(ChartSpec,'Candlestickdata') && ~isempty(ChartSpec.Candlestickdata)
            request = [request '''firstValueIsTotal'': ' val2bool(number) ','];
        end
        if isfield(ChartSpec,'Candlestickdata') && ~isempty(ChartSpec.Candlestickdata)
            request = [request '''hideConnectorLines'': ' val2bool(number) ','];
        end
        if isfield(ChartSpec,'Candlestickdata') && ~isempty(ChartSpec.Candlestickdata)
            request = [request '''connectorLineStyle'': ' gxls_req_linestyle(LineStyle) ];
        end
    case {'treemap','treemapchart'}
        if isfield(ChartSpec,'ChartData') && ~isempty(ChartSpec.ChartData)
            if isfield(ChartSpec.ChartData,'labels') && ~isempty(ChartSpec.ChartData.labels)
                request = [request '''labels'': ' gxls_req_chartdata(ChartSpec.ChartData.labels)  ','];
            end
            if isfield(ChartSpec.ChartData,'parentLabels') && ~isempty(ChartSpec.ChartData.parentLabels)
                request = [request '''parentLabels'': ' gxls_req_chartdata(ChartSpec.ChartData.parentLabels)  ','];
            end
            if isfield(ChartSpec.ChartData,'sizeData') && ~isempty(ChartSpec.ChartData.sizeData)
                request = [request '''sizeData'': ' gxls_req_chartdata(ChartSpec.ChartData.sizeData)  ','];
            end
            if isfield(ChartSpec.ChartData,'colorData') && ~isempty(ChartSpec.ChartData.colorData)
                request = [request '''colorData'': ' gxls_req_chartdata(ChartSpec.ChartData.colorData)  ','];
            end
        end
        if isfield(ChartSpec,'Candlestickdata') && ~isempty(ChartSpec.Candlestickdata)
            request = [request '''textFormat'': ' gxls_req_txtformat(textFormat) ','];
        end
        if isfield(ChartSpec,'levels') && ~isempty(ChartSpec.levels)
            request = [request '''levels'': ' num2str(ChartSpec.levels) ','];
        end
        if isfield(ChartSpec,'hintedLevels') && ~isempty(ChartSpec.hintedLevels)
            request = [request '''hintedLevels'': ' num2str(ChartSpec.hintedLevels) ','];
        end
        if isfield(ChartSpec,'minValue') && ~isempty(ChartSpec.minValue)
            request = [request '''minValue'': ' num2str(ChartSpec.minValue) ','];
        end
        if isfield(ChartSpec,'maxValue') && ~isempty(ChartSpec.maxValue)
            request = [request '''maxValue'': ' num2str(ChartSpec.maxValue) ','];
        end
        if isfield(ChartSpec,'headerColor') && ~isempty(ChartSpec.headerColor)
            request = [request '''headerColor'': ' gxls_req_color(ChartSpec.headerColor) ','];
        end
        if isfield(ChartSpec,'colorscale') && ~isempty(ChartSpec.colorscale)
            request = [request '''colorScale'': ' gxls_req_treemapchartcolorscale(ChartSpec.colorscale) ','];
        end
        if isfield(ChartSpec,'hidetooltips') && ~isempty(ChartSpec.hidetooltips)
            request = [request '''hideTooltips'': ' val2bool(ChartSpec.hidetooltips) ];
        end
    otherwise
        %do nothing
end

%encapsulate
if request(end)==','
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
