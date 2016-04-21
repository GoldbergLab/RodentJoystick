clear all
load boutdata.mat

day = b(mod(b,1)<0.5);
night = b(mod(b,1)>0.5);

day_diff = diff(day);
day_diff = day_diff(day_diff>0);

night_diff = diff(night);
night_diff = night_diff(night_diff>0);

edges = logspace(-3,-0.301,50);
day_dist=histc(day_diff,edges)/(numel(day_diff));
night_dist=histc(night_diff,edges)/(numel(night_diff));

figure;
semilogx(edges,day_dist,'r');
%stairs(edges,day_dist(1:end),'r');
hold on;
semilogx(edges,night_dist(1:end),'k');

np_list=[];
for i=1:length(dirlist)
    
    load(strcat(dirlist(i).name,'/jstruct.mat'));
    [~,np] = onsets(jstruct,1);
    np_list = [np_list;np];
end