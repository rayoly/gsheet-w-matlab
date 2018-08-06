%GXLS_REQ_ROWDATA Generate request to set up a row
%
% request = gxls_req_rowdata(rowdata)
% 
% gxls_req_rowdata  : Generate request to set up a row.
%
%       rowdata:       border structure.
%
%       ROWDATA STRUCTURE: Same as CELLDATA structure for GXLS_REQ_CELLDATA 
%
%   The output is part of the request in string format
%
%   See also GXLS_REQ_CELLDATA
% ------------------------------------------------------------------------------
%   Copyright 2018 Raymond Olympio
%   Version: 1.0 
%   Date: 05-Aug-2018
% ------------------------------------------------------------------------------

function request = gxls_req_rowdata(rowdata)

request = ['{''values'': [' gxls_req_celldata(rowdata) ']}'];