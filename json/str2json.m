function txt=str2json(name,item,level,varargin)
txt={};
if(~ischar(item))
        error('input is not a string');
end
item=reshape(item, max(size(item),[1 0]));
len=size(item,1);
ws=struct('tab',sprintf('\t'),'newline',sprintf('\n'),'sep',sprintf(',\n'));
ws=jsonopt('whitespaces_',ws,varargin{:});
padding1=repmat(ws.tab,1,level);
padding0=repmat(ws.tab,1,level+1);
nl=ws.newline;
sep=ws.sep;

if(~isempty(name)) 
    if(len>1)
        txt={padding1, '"', checkname(name,varargin{:}),'": [', nl};
    end
else
    if(len>1)
        txt={padding1, '[', nl};
    end
end
for e=1:len
    val=escapejsonstring(item(e,:));
    if(len==1)
        obj=['"' checkname(name,varargin{:}) '": ' '"',val,'"'];
        if(isempty(name))
            obj=['"',val,'"'];
        end
        txt(end+1:end+2)={padding1, obj};
    else
        txt(end+1:end+4)={padding0,'"',val,'"'};
    end
    if(e==len)
        sep='';
    end
    txt{end+1}=sep;
end
if(len>1)
    txt(end+1:end+3)={nl,padding1,']'};
end
txt = sprintf('%s',txt{:});