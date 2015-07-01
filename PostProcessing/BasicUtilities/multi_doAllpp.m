function [failures, actual_count] = multi_doAll(dir_list, varargin) 
default = {1};
numvarargs = length(varargin);
if numvarargs > 1
    error('too many arguments (> 2), only one required and one optional.');
end
[default{1:numvarargs}] = varargin{:};
[statflag] = default;

others ={};
combinefail={};
jstructfail={};
statsfail={};
actual_count = 0;
for i = 1:length(dir_list)
    try
        if dir_list(i).isdir
            actual_count = 1;
            doAllpp(dir_list(i).name);
        end
    catch
        failed{j} = dir_list(i).name;
        j=j+1;
    end
end

disp([num2str(actual_count), ' entries out of the input list were actually']);
disp('directories. doAllpp attempted to process those directories.');
disp('doAllpp failed on the following directories (possibly none):');
disp(failed);