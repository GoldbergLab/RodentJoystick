function [ toprocesslist, list] = directories_to_do(expt_dir)
%directories_to_do(expt_dir) generates a list of all directories (days)
%that have not been analyzed yet (and are not the current day);
%expt_dir\data\Box_<boxnum>_<mouseid>\ContingencyDate_Folder
list = rdir([expt_dir, '\data\*\*']);
k = 1;
toprocesslist = struct('name', {}, 'isdir', []);
for i = 1:length(list)
    split_up = strsplit(list(i).name, '\');
    folderday = split_up{end};
    date = datestr(now, 'mmddyy');
    if list(i).isdir && ~(strcmp(date, folderday(1:6)))
        testlist = rdir([list(i).name, '\*.dat']);
        if ~isempty(testlist)
           toprocesslist(k).name = list(i).name; 
           toprocesslist(k).isdir = list(i).isdir;
           k = k+1;
        end
    end
end
if isempty(toprocesslist)
    toprocesslist = [];
end