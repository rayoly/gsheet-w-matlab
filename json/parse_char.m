function parse_char(c)
    global pos inStr len
    pos=skip_whitespace(pos,inStr,len);
    if pos > len || inStr(pos) ~= c
        error_pos(sprintf('Expected %c at position %%d', c));
    else
        pos = pos + 1;
        pos=skip_whitespace(pos,inStr,len);
    end