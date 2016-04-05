function [] = redostats(dir_list)

for i=1:length(dir_list)
    load(dir_list(i).name);
    [~] = xy_getstats(jstruct,dir_list(i).name(1:(end-12)),1);
    [~] = xy_getstats(jstruct,dir_list(i).name(1:(end-12)),0);
end