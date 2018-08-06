function [GSheet, status] = gxls_align(url_file,sheetname,varargin)

%XLSALIGN modifies alignment options of selected Excel cell(s)
%
% xlsalign(filename,sheetname,'Whole', param,value, ...)
% xlsalign(filename,sheetname,'Find',text, param,value, ...)
% xlsalign(filename,sheetname,range, param,value, ...)
%
% xlsalign  : modifies alignment options of selected Excel cell(s) in a selected sheet.
%
%       filename:       Name of excel file.
%       sheetname:      sheet name.
%       'Whole':        to select whole sheet.
%       'Find':         to look for specific string 'text' in the sheet to
%                       change the font.
%       text:           string text to look for in sheet using 'Find'.
%
%       USER CONFIGURABLE OPTIONS
%
%       Possible param/value options are:
%
%           'Horizontal'   - to be followed by one of the following integers:
%                           1: General
%                           2: Left
%                           3: Center
%                           4: Right
%                           5: Fill
%                           6: Justify
%                           7: Center Across Selection
%                           8: Distributed
%           'Vertical'     - to be followed by one of the following integers:
%                           1: Top
%                           2: Center
%                           3: Bottom
%                           4: Justify
%                           5: Distributed
%           'WrapText'     - to be followed by 0 or 1.
%           'Orientation'  - to be followed by integer angle between [-90,90]
%           'IndentLevel'  - to be followed by integer value between [0,15]
%           'ShrinkToFit'  - to be followed by 0 or 1.
%           'TextDirection'- to be followed by one of the following integers:
%                               1: Context
%                               2: Left-to-Right
%                               3: Right-to-Left
%           'MergeCells'   - to be followed by 0 or 1.
%
% Examples:
%
%   xlsalign('file.xls','Sheet1','A1:A2','MergeCells',1);
%   xlsalign('file.xls','Sheet1','A1:A2','Horizontal',3,'WrapText',1);
%   xlsalign('file.xls','Sheet1','A1:A2','Orientation',90,'ShrinkToFit',1);
%
%   See also XLSREAD, XLSFINFO, XLSWRITE, XLSCELL, XLSHEETS, , CPTXT2XLS, MSOPEN

%   Copyright 2018 Raymond Olympio
%   Version: 1.0 $  $Date: 21-Mar-2004


status = 0;
GSheet = [];

if ~exist('url_file','var') || isempty(url_file)
    fprintf(2,'%s::No file provided\n',mfilename);
    return;
end

% --------------------------- Get Constant for proper work with google sheet API
gxls_constants;

if ischar(url_file) %URL of the spreadsheet and sheetid
    %convert file into Gsheet structure
    GSheet = url2gsheet(url_file);
    
elseif isstruct(url_file) && isfield(url_file,'spreadsheetID')
    GSheet = url_file;
    clear file
end

% ------------------------------------------------------------ Processed options
[sheetId, GSheet] = gxls_sheetname2sheetid(GSheet, sheetname);
%
%allowable values
HORIZ = {'','LEFT','CENTER','RIGHT','','','',''};
VERT = {'TOP','CENTER','BOTTOM','',''};
TXTDIR = {'','LEFT_TO_RIGHT','RIGHT_TO_LEFT'};
%default
cellformat = def_cellformat;
fields = {};
if ~isempty(varargin)
    range = varargin{1};
    range = convert_range(range);
    range.sheetId = sheetId;
    %
    options = varargin(2:end);
    n=1;
    while n<length(options)
        try
            switch lower(options{n})
                case 'horizontal'
                    a = HORIZ{options{n+1}};
                    if ~isempty(a)
                        cellformat.horiz_align = a;
                    end
                    fields{end+1} = 'horizontalAlignment';
                case 'vertical'
                    a = VERT{options{n+1}};
                    if ~isempty(a)
                        cellformat.vert_align = a;
                    end
                    fields{end+1} = 'verticalAlignment';
                case 'wraptext'
                    if options{n+1}
                        cellformat.wrap = 'WRAP';
                    end
                    fields{end+1} = 'wrapStrategy';
                case 'orientation'
                    cellformat.orientation = options{n+1};
                    fields{end+1} = 'textRotation';
                case 'indentlevel'
                    cellformat.indent = options{n+1};
                case 'shrinktofit'
                    cellformat.shrink = options{n+1};
                case 'textdirection'
                    a = TXTDIR{options{n+1}};
                    if ~isempty(a)
                        cellformat.txt_dir = a;
                    end
                    fields{end+1} = 'textDirection';
                case 'mergecells'
                    cellformat.merge = options{n+1};
                otherwise
            end
        catch err
            fprintf(2,'Could not set %s option\n',options{n});
        end
        n = n+1;
    end
    
    if ~isempty(fields)
        fields_txt = 'userEnteredFormat(';
        a = cellfun(@(x) [x ','],fields,'UniformOutput',false);
        a = [a{:}];
        a(end) = '';
        fields_txt = ['userEnteredFormat(' a ')'];
    else
        fprintf(2,'No valid option set\n');
        return;
    end
else
    fprintf(2,'%s::Missing arguments!\n',mfilename);
    return;
end
% ------------------------------------------------------------- Generate request
request = ['''requests'': [',...
    '{',...
    '''repeatCell'': {',...
    '''range'': ' gxls_req_gridrange(range) ',',...
    '''cell'': {',...
    '''userEnteredFormat'': ', gxls_req_cellformat(cellformat),...
    '},',...
    '''fields'': ''' fields_txt ''''...
    '}}]'];
% ----------------------------------------------------------------- Send request
[success, GSheet, connection] = gxls_send_req(GSheet, request);
%
if ~success
    display(['Failed trying to change text alignmnet in sheet ' sheetname  '. Last response was: ' num2str(connection.getResponseCode) '/' connection.getResponseMessage().toCharArray()']);
end


%-------------------------------------------------------------------------------
%
%-------------------------------------------------------------------------------
function cellformat = def_cellformat()
cellformat.horiz_align = 'LEFT';
cellformat.vert_align = 'TOP';
cellformat.wrap = 0;
cellformat.orientation = 0;
cellformat.indent = 0;
cellformat.shrink = false;
cellformat.txt_dir = 'LEFT_TO_RIGHT';
cellformat.merge = false;