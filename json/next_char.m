function c = next_char
    global pos inStr len
    pos=skip_whitespace(pos,inStr,len);
    if pos > len
        c = [];
    else
        c = inStr(pos);
    end