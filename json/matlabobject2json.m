function txt=matlabobject2json(name,item,level,varargin)
if numel(item) == 0 %empty object
    st = struct();
else
    % "st = struct(item);" would produce an inmutable warning, because it
    % make the protected and private properties visible. Instead we get the
    % visible properties
    propertynames = properties(item);
    for p = 1:numel(propertynames)
        for o = numel(item):-1:1 % aray of objects
            st(o).(propertynames{p}) = item(o).(propertynames{p});
        end
    end
end
txt=struct2json(name,st,level,varargin{:});