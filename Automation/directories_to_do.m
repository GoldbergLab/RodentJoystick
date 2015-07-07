function [ toprocesslist ] = directories_to_do(expt_dir)
disp(expt_dir);
expt_dir = 'C:\Users\GolderbergLab\Documents\MATLAB\RodentJoystick\SampleData\0002';
%directories_to_do(expt_dir) generates a list of all directories (days)
%that have not been analyzed yet (and are not the current day);
list = rdir([expt_dir, '\*\*']);
disp(length(list));
k = 1;
toprocesslist = struct('name', {}, 'isdir', []);
for i = 1:length(list)
    split_up = strsplit(list(i).name, '\');
    folderday = split_up{end};
    date = datestr(now, 'mm_dd_yyyy');
    if list(i).isdir && ~(strcmp(date, folderday))
        if exist([list(i).name, '\jstruct.mat'],'file')~=2
           toprocesslist(k).name = list(i).name; 
           toprocesslist(k).isdir = list(i).isdir;
           k = k+1;
        end
    end
end
if isempty(toprocesslist)
    toprocesslist = [];
end