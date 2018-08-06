function color_index = colorindex2color(color_index)

if ischar(color_index)
    color_index = hex2dec(color_index);
end
if length(color_index)==1
    c = color_index;
    color_index(1) = c - 256*floor(c/256);
    c = c - color_index(1);
    color_index(2) = c/(256) - 256*floor(c/(256*256));
    c = c - color_index(2)*256;
    color_index(3) = floor(c/(256*256));
    
    color_index = color_index/256;
end