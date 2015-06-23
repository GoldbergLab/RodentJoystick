function [failed, actual_count] = multi_doAllpp(dir_list, varargin) 
j = 1; actual_count = 0;
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

disp([num2str(actual_count), ' entries out of the input list were actually',...
        ' directories. doAllpp attempted to process those directories.', ...
        ' doAllpp failed on the following directories:');
disp(failed);