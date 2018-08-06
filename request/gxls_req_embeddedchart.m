%GXLS_REQ_EMBEDDEDCHART Generate request to add an embedded chart
%
% request = gxls_req_embeddedchart(ntype, npattern)
% 
% gxls_req_embeddedchart  : Generate request to add an embedded chart. 
%
%       EChart:       Embedded Chart object structure
%       
%       ECHART STRUCTURE:
%           - .chartID: number indicating the chart ID
%           - .spec: Chart Spect object. See GXLS_REQ_CHARTSPEC.
%
%  See Googlesheet API on "EmbeddedChart"
%
%   The output is part of the request in string format
%    
% ------------------------------------------------------------------------------
%   Copyright 2018 Raymond Olympio
%   Version: 1.0 
%   Date: 05-Aug-2018
% ------------------------------------------------------------------------------

function request = gxls_req_embeddedchart(EChart)

request = '';
if isfield(EChart,'chartId')
    request = [request '''chartId'': ' num2str(EChart.chartId) ','];
end
if isfield(EChart,'spec')
    request = [request '''spec'': ' gxls_req_chartspec(EChart.spec) ','];
end
if isfield(EChart,'position')
    request = [request '''position'': ' gxls_req_embeddedobjectpos(EChart.position) ','];
end
%encapsulate
if ~isempty(request) && request(end)==','
    request(end) = '';
end

request = ['{' request '}'];