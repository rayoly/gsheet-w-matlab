function txt=cell2json(name,item,level,varargin)
txt={};
if(~iscell(item))
        error('input is not a cell');
end

dim=size(item);
if(ndims(squeeze(item))>2) % for 3D or higher dimensions, flatten to 2D for now
    item=reshape(item,dim(1),numel(item)/dim(1));
    dim=size(item);
end
len=numel(item);
ws=jsonopt('whitespaces_',struct('tab',sprintf('\t'),'newline',sprintf('\n'),'sep',sprintf(',\n')),varargin{:});
padding0=repmat(ws.tab,1,level);
padding2=repmat(ws.tab,1,level+1);
nl=ws.newline;
bracketlevel=~jsonopt('singletcell',1,varargin{:});
if(len>bracketlevel)
    if(~isempty(name))
        txt={padding0, '"', checkname(name,varargin{:}),'": [', nl}; name=''; 
    else
        txt={padding0, '[', nl};
    end
elseif(len==0)
    if(~isempty(name))
        txt={padding0, '"' checkname(name,varargin{:}) '": []'}; name=''; 
    else
        txt={padding0, '[]'};
    end
end
for i=1:dim(1)
    if(dim(1)>1)
        txt(end+1:end+3)={padding2,'[',nl};
    end
    for j=1:dim(2)
       txt{end+1}=obj2json(name,item{i,j},level+(dim(1)>1)+(len>bracketlevel),varargin{:});
       if(j<dim(2))
           txt(end+1:end+2)={',' nl};
       end
    end
    if(dim(1)>1)
        txt(end+1:end+3)={nl,padding2,']'};
    end
    if(i<dim(1))
        txt(end+1:end+2)={',' nl};
    end
    %if(j==dim(2)) txt=sprintf('%s%s',txt,sprintf(',%s',nl)); end
end
if(len>bracketlevel)
    txt(end+1:end+3)={nl,padding0,']'};
end
txt = sprintf('%s',txt{:});
