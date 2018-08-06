%GXLS_REQ_CELLDATA Generate request to set up a celldata
%
% request = gxls_req_celldata(celldata)
% 
% gxls_req_celldata  : Generate request to set up a border.
%
%       celldata:       border structure.
%
%       CELLDATA STRUCTURE:
%           - .value: cell value. See GXLS_REQ_EXTENDEDVALUE
%           - .type: type of data. Can be one of the following 
%                     (see Googlesheets API's ExtendedValue)
%                   'numberValue', 'stringValue', 'boolValue' or 'formulaValue'
%                   See GXLS_REQ_EXTENDEDVALUE.
%           - .url: URL the cell(s) point to
%           - .comment: Note associate to the cell(s)
%           - .cellformat: Cell format according to  Googlesheets API's CellFormat.
%                          See GXLS_REQ_CELLFORMAT
%           - .txtformatrun: Runs of rich text applied to subsections of the cell.
%                            See GXLS_REQ_TEXTFORMATRUN
%           - .datavalidation: Data validation rule on the cell. 
%                              See GXLS_REQ_DATAVALIDATIONRULE
%           - .pivottable: A pivot table anchored at this cell
%                          See GXLS_REQ_PIVOTTABLE
%
%       Note: all fields are optional
%
%   The output is part of the request in string format
%
%   See also GXLS_REQ_EXTENDEDVALUE, GXLS_REQ_CELLFORMAT, GXLS_REQ_TEXTFORMATRUN
%   GXLS_REQ_DATAVALIDATIONRULE, GXLS_REQ_PIVOTTABLE
% ------------------------------------------------------------------------------
%   Copyright 2018 Raymond Olympio
%   Version: 1.0 
%   Date: 05-Aug-2018
% ------------------------------------------------------------------------------

function request = gxls_req_celldata(celldata)

request = '';

if isfield(celldata,'value') && ~isempty(celldata.value)
    if ~isfield(celldata,'type')
        celldata.type = '';
    end
    request = [request '''userEnteredValue'': '  gxls_req_extendedvalue(celldata.value, celldata.type)  ','];
end
if isfield(celldata,'cellformat') && ~isempty(celldata.cellformat)
    request = [request '''userEnteredFormat'': '   gxls_req_cellformat(celldata.cellformat) ','];
end
if isfield(celldata,'url') && ~isempty(celldata.url)
    request = [request '''hyperlink'': ''' celldata.url ''','];
end
if isfield(celldata,'comment') && ~isempty(celldata.comment)
    request = [request '''note'': ''' celldata.comment ''','];
end
if isfield(celldata,'txtformatrun') && ~isempty(celldata.txtformatrun)
    request = [request '''textFormatRuns'': [    ' gxls_req_textformatrun(celldata.txtformatrun)    '],'];
end
if isfield(celldata,'datavalidation') && ~isempty(celldata.datavalidation)
    request = [request '''dataValidation'': '    gxls_req_datavalidationrule(celldata.datavalidation)  ','];
end
if isfield(celldata,'pivottable') && ~isempty(celldata.pivottable)
    request = [request '''pivotTable'': ' gxls_req_pivottable(celldata.pivottabl)  ];
end
%encapsulate
if request(end)==','
    request(end) = '';
end

request = ['{' request '}'];
