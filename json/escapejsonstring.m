function newstr=escapejsonstring(str)
newstr=str;
isoct=exist('OCTAVE_VERSION','builtin');
if(isoct)
   vv=sscanf(OCTAVE_VERSION,'%f');
   if(vv(1)>=3.8)
       isoct=0;
   end
end
if(isoct)
  escapechars={'\\','\"','\/','\a','\f','\n','\r','\t','\v'};
  for i=1:length(escapechars);
    newstr=regexprep(newstr,escapechars{i},escapechars{i});
  end
  newstr=regexprep(newstr,'\\\\(u[0-9a-fA-F]{4}[^0-9a-fA-F]*)','\$1');
else
  escapechars={'\\','\"','\/','\a','\b','\f','\n','\r','\t','\v'};
  for i=1:length(escapechars);
    newstr=regexprep(newstr,escapechars{i},regexprep(escapechars{i},'\\','\\\\'));
  end
  newstr=regexprep(newstr,'\\\\(u[0-9a-fA-F]{4}[^0-9a-fA-F]*)','\\$1');
end