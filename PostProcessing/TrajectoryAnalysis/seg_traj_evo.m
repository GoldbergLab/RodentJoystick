function [f_vect_dist] = seg_traj_evo(stats,f_text)

tstruct = stats.traj_struct;

seg_info = [stats.traj_struct(:).seginfo];

edges = 10:1:200;
seg_start = [seg_info.start];
seg_stop = [seg_info.stop];


if strcmp(f_text,'pathlen')
    feat_edges = 0.01:0.05:1;
elseif strcmp(f_text,'peakvel')
    feat_edges =  0.0001:0.0005:0.015;
elseif strcmp(f_text,'dur')
    feat_edges = 1:5:100; %logspace(0,3,50);
end

for i=1:(numel(edges))
    vect_temp = (edges(i)>seg_start&edges(i)<seg_stop);
    f_vect{i} = eval(strcat('[seg_info(vect_temp).',f_text,']'));
    f_vect_dist(i,:) = smooth(histc(f_vect{i},feat_edges)/numel(f_vect{i}),3);
    f_vect_mean(i) = mean(f_vect{i});
    i;
end


figure;
pcolor(f_vect_dist');
shading flat

set(gca,'ytick',0:5:15);
set(gca,'yticklabel',['0.000';'0.050';'0.100';'0.150']);

set(gca,'xtick',0:50:200);
set(gca,'xticklabel',['  0';' 50';'100';'150';'200']);

% figure;
% plot(edges,f_vect_mean);ylim([0 0.01]);