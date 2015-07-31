function [hold_time_sug, hold_time_suggest_str] = multi_xy_holddist(dirlist, varargin)

default = {20, 0.25, 0};
numvarargs = length(varargin);
if numvarargs > 3
    error('too many arguments (> 5), only 1 required and 3 optional.');
end
[default{1:numvarargs}] = varargin{:};
[holdthresh, rewrate, combineflag] = default{:};
[jslist, dates] = load_jstructs(dirlist, combineflag);
hold_time_sug = zeros(length(jslist), 1);
hold_time_suggest_str = cell(length(jslist), 1);
for i = 1:length(jslist)
    jstruct = jslist{i};
    [hold_time_sug(i)] = xy_holddist(jstruct, holdthresh, rewrate);
    hold_time_suggest_str{i} = [dates{i},': ', num2str(hold_time_sug(i))];
end
end

