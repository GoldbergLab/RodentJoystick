function [] = seg_traj_evo(stats,f_text)

tstruct = stats.traj_struct;

seg_info = [stats.traj_struct(:).seginfo];

edges = 10:1:200;
seg_start = [seg_info.start];
seg_stop = [seg_info.stop];

feat_edges =  0.0001:0.001:0.015;
for i=1:(numel(edges))
    vect_temp = (edges(i)>seg_start&edges(i)<seg_stop);
    f_vect{i} = eval(strcat('[seg_info(vect_temp).',f_text,']'));
    f_vect_dist(i,:) = histc(f_vect{i},feat_edges)/numel(f_vect{i});
    f_vect_mean(i) = mean(f_vect{i});
    i;
end

figure;
pcolor(f_vect_dist');
shading flat

% set(gca,'ytick',0.0001:0.0005:0.015);
% set(gca,'xtick',0:10:40);
% set(gca,'xticklabel',['  0';' 50';'100';'150';'200']);

figure;
plot(edges,f_vect_mean);ylim([0 0.01]);