function [ toprocesslist ] = directories_to_do(expt_dir)
%directories_to_do(expt_dir) generates a list of all directories (days)
%that have not been analyzed yet (and are not the current day);
%Experimentdirectory\Box_<boxnum>\Contingency_Folder\Datefolder
list = rdir([expt_dir, '\*\*\*']);
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