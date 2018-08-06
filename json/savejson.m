function json=savejson(rootname,obj,varargin)
%
% json=savejson(rootname,obj,filename)
%    or
% json=savejson(rootname,obj,opt)
% json=savejson(rootname,obj,'param1',value1,'param2',value2,...)
%
% convert a MATLAB object (cell, struct or array) into a JSON (JavaScript
% Object Notation) string
%
% author: Qianqian Fang (fangq<at> nmr.mgh.harvard.edu)
% created on 2011/09/09
%
% $Id$
%
% input:
%      rootname: the name of the root-object, when set to '', the root name
%        is ignored, however, when opt.ForceRootName is set to 1 (see below),
%        the MATLAB variable name will be used as the root name.
%      obj: a MATLAB object (array, cell, cell array, struct, struct array,
%      class instance).
%      filename: a string for the file name to save the output JSON data.
%      opt: a struct for additional options, ignore to use default values.
%        opt can have the following fields (first in [.|.] is the default)
%
%        opt.FileName [''|string]: a file name to save the output JSON data
%        opt.FloatFormat ['%.10g'|string]: format to show each numeric element
%                         of a 1D/2D array;
%        opt.ArrayIndent [1|0]: if 1, output explicit data array with
%                         precedent indentation; if 0, no indentation
%        opt.ArrayToStruct[0|1]: when set to 0, savejson outputs 1D/2D
%                         array in JSON array format; if sets to 1, an
%                         array will be shown as a struct with fields
%                         "_ArrayType_", "_ArraySize_" and "_ArrayData_"; for
%                         sparse arrays, the non-zero elements will be
%                         saved to _ArrayData_ field in triplet-format i.e.
%                         (ix,iy,val) and "_ArrayIsSparse_" will be added
%                         with a value of 1; for a complex array, the 
%                         _ArrayData_ array will include two columns 
%                         (4 for sparse) to record the real and imaginary 
%                         parts, and also "_ArrayIsComplex_":1 is added. 
%        opt.ParseLogical [0|1]: if this is set to 1, logical array elem
%                         will use true/false rather than 1/0.
%        opt.SingletArray [0|1]: if this is set to 1, arrays with a single
%                         numerical element will be shown without a square
%                         bracket, unless it is the root object; if 0, square
%                         brackets are forced for any numerical arrays.
%        opt.SingletCell  [1|0]: if 1, always enclose a cell with "[]" 
%                         even it has only one element; if 0, brackets
%                         are ignored when a cell has only 1 element.
%        opt.ForceRootName [0|1]: when set to 1 and rootname is empty, savejson
%                         will use the name of the passed obj variable as the 
%                         root object name; if obj is an expression and 
%                         does not have a name, 'root' will be used; if this 
%                         is set to 0 and rootname is empty, the root level 
%                         will be merged down to the lower level.
%        opt.Inf ['"$1_Inf_"'|string]: a customized regular expression pattern
%                         to represent +/-Inf. The matched pattern is '([-+]*)Inf'
%                         and $1 represents the sign. For those who want to use
%                         1e999 to represent Inf, they can set opt.Inf to '$11e999'
%        opt.NaN ['"_NaN_"'|string]: a customized regular expression pattern
%                         to represent NaN
%        opt.JSONP [''|string]: to generate a JSONP output (JSON with padding),
%                         for example, if opt.JSONP='foo', the JSON data is
%                         wrapped inside a function call as 'foo(...);'
%        opt.UnpackHex [1|0]: conver the 0x[hex code] output by loadjson 
%                         back to the string form
%        opt.SaveBinary [0|1]: 1 - save the JSON file in binary mode; 0 - text mode.
%        opt.Compact [0|1]: 1- out compact JSON format (remove all newlines and tabs)
%
%        opt can be replaced by a list of ('param',value) pairs. The param 
%        string is equivallent to a field in opt and is case sensitive.
% output:
%      json: a string in the JSON format (see http://json.org)
%
% examples:
%      jsonmesh=struct('MeshNode',[0 0 0;1 0 0;0 1 0;1 1 0;0 0 1;1 0 1;0 1 1;1 1 1],... 
%               'MeshTetra',[1 2 4 8;1 3 4 8;1 2 6 8;1 5 6 8;1 5 7 8;1 3 7 8],...
%               'MeshTri',[1 2 4;1 2 6;1 3 4;1 3 7;1 5 6;1 5 7;...
%                          2 8 4;2 8 6;3 8 4;3 8 7;5 8 6;5 8 7],...
%               'MeshCreator','FangQ','MeshTitle','T6 Cube',...
%               'SpecialData',[nan, inf, -inf]);
%      savejson('jmesh',jsonmesh)
%      savejson('',jsonmesh,'ArrayIndent',0,'FloatFormat','\t%.5g')
%
% license:
%     BSD or GPL version 3, see LICENSE_{BSD,GPLv3}.txt files for details
%
% -- this function is part of JSONLab toolbox (http://iso2mesh.sf.net/cgi-bin/index.cgi?jsonlab)
%

if(nargin==1)
   varname=inputname(1);
   obj=rootname;
   if(isempty(varname)) 
      varname='root';
   end
   rootname=varname;
else
   varname=inputname(2);
end
if(length(varargin)==1 && ischar(varargin{1}))
   opt=struct('filename',varargin{1});
else
   opt=varargin2struct(varargin{:});
end
opt.IsOctave=exist('OCTAVE_VERSION','builtin');
if(isfield(opt,'norowbracket'))
    warning('Option ''NoRowBracket'' is depreciated, please use ''SingletArray'' and set its value to not(NoRowBracket)');
    if(~isfield(opt,'singletarray'))
        opt.singletarray=not(opt.norowbracket);
    end
end
rootisarray=0;
rootlevel=1;
forceroot=jsonopt('ForceRootName',0,opt);
if((isnumeric(obj) || islogical(obj) || ischar(obj) || isstruct(obj) || ...
        iscell(obj) || isobject(obj)) && isempty(rootname) && forceroot==0)
    rootisarray=1;
    rootlevel=0;
else
    if(isempty(rootname))
        rootname=varname;
    end
end
if((isstruct(obj) || iscell(obj))&& isempty(rootname) && forceroot)
    rootname='root';
end

whitespaces=struct('tab',sprintf('\t'),'newline',sprintf('\n'),'sep',sprintf(',\n'));
if(jsonopt('Compact',0,opt)==1)
    whitespaces=struct('tab','','newline','','sep',',');
end
if(~isfield(opt,'whitespaces_'))
    opt.whitespaces_=whitespaces;
end

nl=whitespaces.newline;

json=obj2json(rootname,obj,rootlevel,opt);
if(rootisarray)
    json=sprintf('%s%s',json,nl);
else
    json=sprintf('{%s%s%s}\n',nl,json,nl);
end

jsonp=jsonopt('JSONP','',opt);
if(~isempty(jsonp))
    json=sprintf('%s(%s);%s',jsonp,json,nl);
end

% save to a file if FileName is set, suggested by Patrick Rapin
filename=jsonopt('FileName','',opt);
if(~isempty(filename))
    if(jsonopt('SaveBinary',0,opt)==1)
	    fid = fopen(filename, 'wb');
	    fwrite(fid,json);
    else
	    fid = fopen(filename, 'wt');
	    fwrite(fid,json,'char');
    end
    fclose(fid);
end
