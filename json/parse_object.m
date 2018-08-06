function object = parse_object(varargin)
    parse_char('{');
    object = [];
    if next_char ~= '}'
        while 1
            str = parseStr(varargin{:});
            if isempty(str)
                error_pos('Name of value at position %d cannot be empty');
            end
            parse_char(':');
            val = parse_value(varargin{:});
            object.(valid_field(str))=val;
            if next_char == '}'
                break;
            end
            parse_char(',');
        end
    end
    parse_char('}');
    if(isstruct(object))
        object=struct2jdata(object);
    end

    