function [] = redostats(dirlist)

for i=1:length(dirlist)
    i
    load(strcat(dirlist(i).name,'/jstruct.mat'));
    [~] = xy_getstats(jstruct,dirlist(i).name,1,0);
    [~] = xy_getstats(jstruct,dirlist(i).name,0,0);
end