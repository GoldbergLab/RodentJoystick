function [] = redostats(dirlist)

for i=1:length(dirlist)
    try
    i
    jstruct = xy_makestruct(dirlist(i).name);
%     save(strcat(dirlist(i).name,'/jstruct.mat'),'jstruct');
%     [a] = xy_getstats(jstruct,dirlist(i).name,1,0);
%     [b] = xy_getstats(jstruct,dirlist(i).name,0,0);
    [c] = xy_getstats(jstruct,dirlist(i).name,1,0.5);
    [d] = xy_getstats(jstruct,dirlist(i).name,0,0.5);
    end
end