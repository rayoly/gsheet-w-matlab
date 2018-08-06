function aSheets = gxls_refreshAccessToken

aSheets = [];

if ~exist('google_tokens.mat', 'file')
    disp('Run RunOnce() first and ensure that google_tokens.mat is in MATLAB''s path');
    return
end

if exist('google_tokens.mat','file')
    load google_tokens.mat
    mat_file = true;
else
    jsond = loadjson('credentials.json');
    
    aSheets = jsond.access_token;
    client_id = jsond.client_id;
    client_secret = jsond.client_secret;
    rSheets = jsond.refresh_token;
    tSheets = jsond.token_response.token_type;
    
    mat_file = false;
end

newAccessTokenString=urlread('https://accounts.google.com/o/oauth2/token','POST', ...
    {'client_id', client_id, 'client_secret', client_secret, 'refresh_token', rSheets, 'grant_type', 'refresh_token'});

aSheets=[];

reply_commas=[1 strfind(newAccessTokenString,',') length(newAccessTokenString)];

for i=1:length(reply_commas)-1
    if ~isempty(strfind(newAccessTokenString(reply_commas(i):reply_commas(i+1)),'access_token'))
        tmp=newAccessTokenString(reply_commas(i):reply_commas(i+1));
        index_tmp_colon=strfind(tmp,':');
        tmp=tmp(index_tmp_colon+1:end); clear index_tmp_colon;
        index_quotes=find(tmp=='"');
        aSheets=tmp(index_quotes(1)+1:index_quotes(2)-1); clear index_quotes tmp;
    end
end
%
if isempty(aSheets)
    disp('Cannot do anything without Google API access. See readme'); 
    return;
elseif mat_file
    save('google_tokens.mat', 'aSheets', '-append');
end