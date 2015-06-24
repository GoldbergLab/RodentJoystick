function stats = doallstatsinfolder(wdir)

list = dirrec(wdir,'jstruct*');
for i=1:length(list)
    load(list{i});
    stats(i) = xy_getstats(jstruct);
    clear jstruct;
end

save(strcat(wdir,'/stats.mat'),'stats');