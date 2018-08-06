%INIT_GSHEET Initializes a GSheet structure
%
% GSheet = init_gsheet()
%
% url2gsheet  : Initializes a GSheet structure.
%
%
%
%
%
%
% ------------------------------------------------------------------------------
%   Copyright 2018 Raymond Olympio
%   Version: 1.0
%   Date: 05-Aug-2018
% ------------------------------------------------------------------------------
function GSheet = init_gsheet()

GSheet = struct('aSheets',[],...
    'spreadsheetID',[],...
    'spreadsheetTitle','',...
    'spreadsheetUrl',[],...
    'SheetId',int32([]),...
    'SheetName',[],...
    'SheetNames',{''},...
    'SheetIds', int32([]) );