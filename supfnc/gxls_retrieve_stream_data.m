%URL2GSHEET Retrieve the content of a java stream
%
% [json_data, content] = gxls_retrieve_stream_data(stream)
%
% gxls_retrieve_stream_data  : Retrieve the content of a java stream
%
%       stream:       url to the sheet or spreadsheet
%   
%       json_data: stream content in JSON format
%       content: stream content in string format
%
%
%
%
% ------------------------------------------------------------------------------
%   Copyright 2018 Raymond Olympio
%   Version: 1.0
%   Date: 05-Aug-2018
% ------------------------------------------------------------------------------

function [json_data, content] = gxls_retrieve_stream_data(stream)

content = '';

err_sr = java.io.InputStreamReader(stream);
br = java.io.BufferedReader(err_sr);
l = br.readLine();
while ~isempty(l)
    content = [content l];
    l = br.readLine();
end
content = char(content)';
content = content(:)';
    
json_data = loadjson(content);