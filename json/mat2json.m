function txt=mat2json(name,item,level,varargin)
if(~isnumeric(item) && ~islogical(item))
        error('input is not an array');
end
ws=struct('tab',sprintf('\t'),'newline',sprintf('\n'),'sep',sprintf(',\n'));
ws=jsonopt('whitespaces_',ws,varargin{:});
padding1=repmat(ws.tab,1,level);
padding0=repmat(ws.tab,1,level+1);
nl=ws.newline;
sep=ws.sep;

if(length(size(item))>2 || issparse(item) || ~isreal(item) || ...
   (isempty(item) && any(size(item))) ||jsonopt('ArrayToStruct',0,varargin{:}))
    if(isempty(name))
    	txt=sprintf('%s{%s%s"_ArrayType_": "%s",%s%s"_ArraySize_": %s,%s',...
              padding1,nl,padding0,class(item),nl,padding0,regexprep(mat2str(size(item)),'\s+',','),nl);
    else
    	txt=sprintf('%s"%s": {%s%s"_ArrayType_": "%s",%s%s"_ArraySize_": %s,%s',...
              padding1,checkname(name,varargin{:}),nl,padding0,class(item),nl,padding0,regexprep(mat2str(size(item)),'\s+',','),nl);
    end
else
    if(numel(item)==1 && jsonopt('SingletArray',0,varargin{:})==0 && level>0)
        numtxt=regexprep(regexprep(matdata2json(item,level+1,varargin{:}),'^\[',''),']','');
    else
        numtxt=matdata2json(item,level+1,varargin{:});
    end
    if(isempty(name))
    	txt=sprintf('%s%s',padding1,numtxt);
    else
        if(numel(item)==1 && jsonopt('SingletArray',0,varargin{:})==0)
           	txt=sprintf('%s"%s": %s',padding1,checkname(name,varargin{:}),numtxt);
        else
    	    txt=sprintf('%s"%s": %s',padding1,checkname(name,varargin{:}),numtxt);
        end
    end
    return;
end
dataformat='%s%s%s%s%s';

if(issparse(item))
    [ix,iy]=find(item);
    data=full(item(find(item)));
    if(~isreal(item))
       data=[real(data(:)),imag(data(:))];
       if(size(item,1)==1)
           % Kludge to have data's 'transposedness' match item's.
           % (Necessary for complex row vector handling below.)
           data=data';
       end
       txt=sprintf(dataformat,txt,padding0,'"_ArrayIsComplex_": ','1', sep);
    end
    txt=sprintf(dataformat,txt,padding0,'"_ArrayIsSparse_": ','1', sep);
    if(size(item,1)==1)
        % Row vector, store only column indices.
        txt=sprintf(dataformat,txt,padding0,'"_ArrayData_": ',...
           matdata2json([iy(:),data'],level+2,varargin{:}), nl);
    elseif(size(item,2)==1)
        % Column vector, store only row indices.
        txt=sprintf(dataformat,txt,padding0,'"_ArrayData_": ',...
           matdata2json([ix,data],level+2,varargin{:}), nl);
    else
        % General case, store row and column indices.
        txt=sprintf(dataformat,txt,padding0,'"_ArrayData_": ',...
           matdata2json([ix,iy,data],level+2,varargin{:}), nl);
    end
else
    if(isreal(item))
        txt=sprintf(dataformat,txt,padding0,'"_ArrayData_": ',...
            matdata2json(item(:)',level+2,varargin{:}), nl);
    else
        txt=sprintf(dataformat,txt,padding0,'"_ArrayIsComplex_": ','1', sep);
        txt=sprintf(dataformat,txt,padding0,'"_ArrayData_": ',...
            matdata2json([real(item(:)) imag(item(:))],level+2,varargin{:}), nl);
    end
end
txt=sprintf('%s%s%s',txt,padding1,'}');