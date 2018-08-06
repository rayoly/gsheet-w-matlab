function txt=matdata2json(mat,level,varargin)

ws=struct('tab',sprintf('\t'),'newline',sprintf('\n'),'sep',sprintf(',\n'));
ws=jsonopt('whitespaces_',ws,varargin{:});
tab=ws.tab;
nl=ws.newline;

if(size(mat,1)==1)
    pre='';
    post='';
    level=level-1;
else
    pre=sprintf('[%s',nl);
    post=sprintf('%s%s]',nl,repmat(tab,1,level-1));
end

if(isempty(mat))
    txt='null';
    return;
end
floatformat=jsonopt('FloatFormat','%.10g',varargin{:});
%if(numel(mat)>1)
    formatstr=['[' repmat([floatformat ','],1,size(mat,2)-1) [floatformat sprintf('],%s',nl)]];
%else
%    formatstr=[repmat([floatformat ','],1,size(mat,2)-1) [floatformat sprintf(',\n')]];
%end

if(nargin>=2 && size(mat,1)>1 && jsonopt('ArrayIndent',1,varargin{:})==1)
    formatstr=[repmat(tab,1,level) formatstr];
end

txt=sprintf(formatstr,mat');
txt(end-length(nl):end)=[];
if(islogical(mat) && jsonopt('ParseLogical',0,varargin{:})==1)
   txt=regexprep(txt,'1','true');
   txt=regexprep(txt,'0','false');
end
%txt=regexprep(mat2str(mat),'\s+',',');
%txt=regexprep(txt,';',sprintf('],\n['));
% if(nargin>=2 && size(mat,1)>1)
%     txt=regexprep(txt,'\[',[repmat(sprintf('\t'),1,level) '[']);
% end
txt=[pre txt post];
if(any(isinf(mat(:))))
    txt=regexprep(txt,'([-+]*)Inf',jsonopt('Inf','"$1_Inf_"',varargin{:}));
end
if(any(isnan(mat(:))))
    txt=regexprep(txt,'NaN',jsonopt('NaN','"_NaN_"',varargin{:}));
end