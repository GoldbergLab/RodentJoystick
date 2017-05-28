function [] = redostats(dirlist)

for i=1:length(dirlist)
    i
    jstruct = xy_makestruct(dirlist(i).name);
    save(strcat(dirlist(i).name,'/jstruct.mat'),'jstruct');
    [~] = xy_getstats(jstruct,dirlist(i).name,1,0);
    [~] = xy_getstats(jstruct,dirlist(i).name,0,0);
    [~] = xy_getstats(jstruct,dirlist(i).name,1,0.5);
    [~] = xy_getstats(jstruct,dirlist(i).name,0,0.5);
end