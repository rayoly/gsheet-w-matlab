function txt=obj2json(name,item,level,varargin)

if(iscell(item))
    txt=cell2json(name,item,level,varargin{:});
elseif(isstruct(item))
    txt=struct2json(name,item,level,varargin{:});
elseif(ischar(item))
    txt=str2json(name,item,level,varargin{:});
elseif(isobject(item)) 
    txt=matlabobject2json(name,item,level,varargin{:});
else
    txt=mat2json(name,item,level,varargin{:});
end