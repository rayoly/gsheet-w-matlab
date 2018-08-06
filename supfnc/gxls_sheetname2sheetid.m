function [sheetid, GSheet] = gxls_sheetname2sheetid(GSheet, sheetname)

if ~isfield(GSheet,'SheetIds') || isempty(GSheet.SheetIds)
     [sheetnames, sheetids, GSheet] = gxls_get_sheetnames(GSheet);
else
    sheetnames = GSheet.SheetNames;
    sheetids = GSheet.SheetIds;
end

if ~isempty(sheetname)
   
    idx = cellfun(@(x) strcmpi(x,sheetname), sheetnames);
    sheetid = sheetids(idx);    
    sheetid = sheetid(1); 
end


