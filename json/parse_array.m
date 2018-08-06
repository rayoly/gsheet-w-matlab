function object = parse_array(varargin) % JSON array is written in row-major order
global pos inStr isoct
    parse_char('[');
    object = cell(0, 1);
    dim2=[];
    arraydepth=jsonopt('JSONLAB_ArrayDepth_',1,varargin{:});
    pbar=-1;
    if(isfield(varargin{1},'progressbar_'))
        pbar=varargin{1}.progressbar_;
    end

    if next_char ~= ']'
	if(jsonopt('FastArrayParser',1,varargin{:})>=1 && arraydepth>=jsonopt('FastArrayParser',1,varargin{:}))
            [endpos, e1l, e1r]=matching_bracket(inStr,pos);
            arraystr=['[' inStr(pos:endpos)];
            arraystr=regexprep(arraystr,'"_NaN_"','NaN');
            arraystr=regexprep(arraystr,'"([-+]*)_Inf_"','$1Inf');
            arraystr(arraystr==sprintf('\n'))=[];
            arraystr(arraystr==sprintf('\r'))=[];
            %arraystr=regexprep(arraystr,'\s*,',','); % this is slow,sometimes needed
            if(~isempty(e1l) && ~isempty(e1r)) % the array is in 2D or higher D
        	astr=inStr((e1l+1):(e1r-1));
        	astr=regexprep(astr,'"_NaN_"','NaN');
        	astr=regexprep(astr,'"([-+]*)_Inf_"','$1Inf');
        	astr(astr==sprintf('\n'))=[];
        	astr(astr==sprintf('\r'))=[];
        	astr(astr==' ')='';
        	if(isempty(find(astr=='[', 1))) % array is 2D
                    dim2=length(sscanf(astr,'%f,',[1 inf]));
        	end
            else % array is 1D
        	astr=arraystr(2:end-1);
        	astr(astr==' ')='';
        	[obj, count, errmsg, nextidx]=sscanf(astr,'%f,',[1,inf]);
        	if(nextidx>=length(astr)-1)
                    object=obj;
                    pos=endpos;
                    parse_char(']');
                    return;
        	end
            end
            if(~isempty(dim2))
        	astr=arraystr;
        	astr(astr=='[')='';
        	astr(astr==']')='';
        	astr(astr==' ')='';
        	[obj, count, errmsg, nextidx]=sscanf(astr,'%f,',inf);
        	if(nextidx>=length(astr)-1)
                    object=reshape(obj,dim2,numel(obj)/dim2)';
                    pos=endpos;
                    parse_char(']');
                    if(pbar>0)
                        waitbar(pos/length(inStr),pbar,'loading ...');
                    end
                    return;
        	end
            end
            arraystr=regexprep(arraystr,'\]\s*,','];');
	else
            arraystr='[';
	end
        try
           if(isoct && regexp(arraystr,'"','once'))
                error('Octave eval can produce empty cells for JSON-like input');
           end
           object=eval(arraystr);
           pos=endpos;
        catch
         while 1
            newopt=varargin2struct(varargin{:},'JSONLAB_ArrayDepth_',arraydepth+1);
            val = parse_value(newopt);
            object{end+1} = val;
            if next_char == ']'
                break;
            end
            parse_char(',');
         end
        end
    end
    if(jsonopt('SimplifyCell',0,varargin{:})==1)
      try
        oldobj=object;
        object=cell2mat(object')';
        if(iscell(oldobj) && isstruct(object) && numel(object)>1 && jsonopt('SimplifyCellArray',1,varargin{:})==0)
            object=oldobj;
        elseif(size(object,1)>1 && ismatrix(object))
            object=object';
        end
      catch
      end
    end
    parse_char(']');
    
    if(pbar>0)
        waitbar(pos/length(inStr),pbar,'loading ...');
    end