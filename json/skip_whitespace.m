function newpos=skip_whitespace(pos,inStr,len)
    newpos=pos;
    while newpos <= len && isspace(inStr(newpos))
        newpos = newpos + 1;
    end
