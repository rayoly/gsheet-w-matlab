function txt=struct2json(name,item,level,varargin)
txt={};
if(~isstruct(item))
	error('input is not a struct');
end
dim=size(item);
if(ndims(squeeze(item))>2) % for 3D or higher dimensions, flatten to 2D for now
    item=reshape(item,dim(1),numel(item)/dim(1));
    dim=size(item);
end
len=numel(item);
forcearray= (len>1 || (jsonopt('SingletArray',0,varargin{:})==1 && level>0));
ws=struct('tab',sprintf('\t'),'newline',sprintf('\n'));
ws=jsonopt('whitespaces_',ws,varargin{:});
padding0=repmat(ws.tab,1,level);
padding2=repmat(ws.tab,1,level+1);
padding1=repmat(ws.tab,1,level+(dim(1)>1)+forcearray);
nl=ws.newline;

if(isempty(item)) 
    if(~isempty(name)) 
        txt={padding0, '"', checkname(name,varargin{:}),'": []'};
    else
        txt={padding0, '[]'};
    end
    txt = sprintf('%s',txt{:});
    return;
end
if(~isempty(name)) 
    if(forcearray)
        txt={padding0, '"', checkname(name,varargin{:}),'": [', nl};
    end
else
    if(forcearray)
        txt={padding0, '[', nl};
    end
end
for j=1:dim(2)
  if(dim(1)>1)
      txt(end+1:end+3)={padding2,'[',nl};
  end
  for i=1:dim(1)
    names = fieldnames(item(i,j));
    if(~isempty(name) && len==1 && ~forcearray)
        txt(end+1:end+5)={padding1, '"', checkname(name,varargin{:}),'": {', nl};
    else
        txt(end+1:end+3)={padding1, '{', nl};
    end
    if(~isempty(names))
      for e=1:length(names)
	    txt{end+1}=obj2json(names{e},item(i,j).(names{e}),...
             level+(dim(1)>1)+1+forcearray,varargin{:});
        if(e<length(names))
            txt{end+1}=',';
        end
        txt{end+1}=nl;
      end
    end
    txt(end+1:end+2)={padding1,'}'};
    if(i<dim(1))
        txt(end+1:end+2)={',' nl};
    end
  end
  if(dim(1)>1)
      txt(end+1:end+3)={nl,padding2,']'};
  end
  if(j<dim(2))
      txt(end+1:end+2)={',' nl};
  end
end
if(forcearray)
    txt(end+1:end+3)={nl,padding0,']'};
end
txt = sprintf('%s',txt{:});