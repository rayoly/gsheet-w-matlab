function [GSheet, status] = gxls_font(url_file,sheetname,range, varargin)

%XLSFONT modifies fonts of selected Excel cell(s)
%
% xlsfont(filename,sheetname,'Whole', param,value, ...)
% xlsfont(filename,sheetname,'Find',text, param,value, ...)
% xlsfont(filename,sheetname,range, param,value, ...)
%
% xlsfont  : modifies fonts of selected Excel cell(s) in a selected sheet.
%
%       filename:       Name of excel file.
%       sheetname:      sheet name.
%       text:           string text to look for in sheet using 'Find'.
% 
%       USER CONFIGURABLE OPTIONS
%  
%       Possible param/value options are:
%
%           'font'         - to be followed by font name (ex. 'Arial')
%           'size'         - to be followed by font size.
%           'fontstyle'   - to be followed by string combination of all or
%                            any of 'bold','italic','regular'.
%                            example ('italic bold','bold','italic','regular italic')
%           'underline'    - to be followed by one of the following integers:
%                               0: None.
%                               1: Single.
%                               2: Single Accounting.
%                               3: Double.
%                               4: Double Accounting.
%           'strikethrough'- to be followed by 0 or 1.
%           'superscript'  - to be followed by 0 or 1.
%           'subscript'    - to be followed by 0 or 1.
%           'color'        - to be followed by Excel color index number.
%                           (ex. 1:Black 2:White 3:Red 4:Green 5:Blue)
%           'interior'     - to be followed 3 integers indicating (ColorIndex,Pattern,PatternColorIndex)
%                           ColorIndex: to be followed by Excel color index number.
%                                       (ex. 1:Black 2:White 3:Red 4:Green 5:Blue)
%                           Pattern: to be followed by one of the following integers:
% 								0: Automatic
% 								1: Solid
% 								2: Gray 75%
% 								3: Gray 50%
% 								4: Gray 25%
% 								5: Gray 16%
% 								6: Gray 8%
% 								7: Horizontal
% 								8: Vertical
% 								9: Down
% 								10: Up
% 								11: Checker
% 								12: Semi Gray 75%
% 								13: Light Horizontal
% 								14: Light Vertical
% 								15: Light Down
% 								16: Light Up
% 								17: Grid
% 								18: Criss Cross
%                           PatternColorIndex: to be followed by Excel color index number.
%                                       (ex. 1:Black 2:White 3:Red 4:Green 5:Blue)
% Examples:
%      
%   xlsfont('file.xls','Sheet1','A1:C3','size',15,'fontstyle','bold italic');
%   xlsfont('file.xls','Sheet1','B:B','size',15,'fontstyle','regular');
%   xlsfont('file.xls','Sheet1','A1','underline',3);
%   xlsfont('file.xls','Sheet1','2:2','interior',1,11,4);
%
%   See also XLSREAD, XLSFINFO, XLSWRITE, XLSCELL, XLSHEETS, , CPTXT2XLS, MSOPEN

%   Copyright 2004 Fahad Al Mahmood
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
range = convert_range(range);
range.sheetId = sheetId;
%
rowdata.cellformat.textformat = def_font_prop;
%
n=1;
while n<=length(varargin)
    if strcmpi(varargin{n},'font')
            rowdata.cellformat.textformat.fontfamily = varargin{n+1};
        n=n+2;
    elseif strcmpi(varargin{n},'fontstyle')
        n=n+1;
        while n<length(varargin)
            s = false;
            if ~isempty(strfind(varargin{n},'bold'))
                rowdata.cellformat.textformat.bold = true;
                s = true;
            end
            if ~isempty(strfind(varargin{n},'italic'))
                rowdata.cellformat.textformat.italic = true;
                s = true;
            end
            if ~isempty(strfind(varargin{n},'regular'))
                rowdata.cellformat.textformat.bold = false;
                rowdata.cellformat.textformat.italic = false;
                rowdata.cellformat.textformat.strikethrough = false;
                rowdata.cellformat.textformat.underline = false;
                s = true;
            end
            if ~s
                break;
            end
            n=n+1;
        end
    elseif strcmpi(varargin{n},'size')
        rowdata.cellformat.textformat.fontsize = varargin{n+1};
        n=n+2;
    elseif strcmpi(varargin{n},'underline')
        rowdata.cellformat.textformat.underline = varargin{n+1}==1;
        n=n+2;
    elseif strcmpi(varargin{n},'strikethrough')
        rowdata.cellformat.textformat.strikethrough = varargin{n+1}==1;
        n=n+2;
    elseif strcmpi(varargin{n},'superscript')
        %
        n=n+2;
    elseif strcmpi(varargin{n},'subscript')
       %
        n=n+2;
    elseif strcmpi(varargin{n},'color')
        color_index = colorindex2color(varargin{n+1});
        rowdata.cellformat.textformat.foregroundcolor.red = color_index(1);
        rowdata.cellformat.textformat.foregroundcolor.green = color_index(2);
        rowdata.cellformat.textformat.foregroundcolor.alpha = color_index(3);
        n=n+2;
    elseif strcmpi(varargin{n},'interior')
        color_index = colorindex2color(varargin{n+1});
        rowdata.cellformat.backgroundcolor = color_index(1);
        rowdata.cellformat.backgroundcolor = color_index(2);
        rowdata.cellformat.backgroundcolor = color_index(3);
        n=n+4;
    else
        n=n+10;
    end
end


% ------------------------------------------------------------- Generate request
request = ['''requests'': [',...
        '{',...
            '''updateCells'': {',...
                '''range'': ' gxls_req_gridrange(range) ',',...
                '''rows'': [', gxls_req_rowdata(rowdata) '],',...
                '''fields'': ''userEnteredFormat.textFormat''',...                
            '}',...
    '}]'];
% ----------------------------------------------------------------- Send request
[success, GSheet, connection] = gxls_send_req(GSheet, request);
%
if ~success
    display(['Failed trying to change font in sheet ' sheetname  '. Last response was: ' num2str(connection.getResponseCode) '/' connection.getResponseMessage().toCharArray()']);
end

%-------------------------------------------------------------------------------
function border = process_border_options(options, border)

n=1;
while n<=length(options)
    border_name = lower(options{n});
    %width
    width = options{n+1};
    if ischar(width)
        width = str2double(width);
    end
    
    %Line style
    lstyle = lower(options{n+2});
    if isnumeric(lstyle)
        STYLES = {'none','solid','dash','medium','thick','dot','double'};
        lstyle = STYLES{lstyle+1};
    end
    %Color
    color_index = options{n+3};
    if ischar(color_index) && ~isnan(str2double(color_index))
        color_index = str2double(color_index);
    end
    alpha = 1.0;
    %
    switch border_name
        case 'diagonaldown'
            field = '';
        case 'diagonalup'
            field = '';
        case 'edgebottom'
            field = 'bottom';
        case 'edgeleft'
            field = 'left';
        case 'edgeright'
            field = 'right';
        case 'edgetop'
            field = 'top';
        case 'insidehorizontal'
            field = '';
        case 'insidevertical'
            field = '';
        case 'box'
            field = {'left','right','top','bottom'};
        case 'cross'
            field = '';
        otherwise
            n=n+4;
            continue
    end
    
    for nf=1:length(field)
        if ~isempty(field{nf})
            switch lstyle
                case 'dash'
                    lstyle = 'DASHED';%Dashed line borders.
                case 'dot'
                    lstyle = 'DOTTED';
                case 'solid'
                    lstyle = 'SOLID';%Thin solid line borders.
                case 'medium'
                    lstyle = 'SOLID_MEDIUM';%Medium solid line borders.
                case 'thick'
                    lstyle = 'SOLID_THICK';%Thick solid line borders.
                case 'double'
                    lstyle = 'DOUBLE';%Two solid line borders.
                otherwise
                    lstyle = 'SOLID';
            end
            %
            border.(field{nf}).width = num2str(width,'%.2f');
            %
            border.(field{nf}).style = lstyle;
            %
            if ischar(color_index)
                color_index = hex2dec(color_index);
            end
            if length(color_index)==1
                c = color_index;
                color_index(1) = c - 256*floor(c/256);
                c = c - color_index(1);
                color_index(2) = c/(256) - 256*floor(c/(256*256));
                c = c - color_index(2)*256;
                color_index(3) = floor(c/(256*256));
            end
            
            border.(field{nf}).color.red = num2str(color_index(1)/256,'%.1f');
            border.(field{nf}).color.green =  num2str(color_index(2)/256,'%.1f');
            border.(field{nf}).color.blue =  num2str(color_index(3)/256,'%.1f');
            
            border.(field{nf}).color.alpha = num2str(alpha,'%.1f');
        end
    end
    n=n+4;
end

%-------------------------------------------------------------------------------

function font_prop = def_font_prop()

font_prop.foregroundcolor.blue = 1.0;
font_prop.foregroundcolor.red = 1.0;
font_prop.foregroundcolor.green = 1.0;
font_prop.foregroundcolor.alpha = 1.0;
font_prop.fontfamily = 'Arial';
font_prop.fontsize = 12;
font_prop.bold = false;
font_prop.italic = false;
font_prop.strikethrough = false;
font_prop.underline = false;