function load_cred_json(cred_file)

fid = fopen(cred_file,'r');
data = fread(fid,'*char')';
fclose(fid);

jsondecode(data)
end