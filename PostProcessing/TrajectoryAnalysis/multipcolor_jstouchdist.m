function [medians] = multipcolor_jstouchdist(boxdir, offset)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

tmpdirlist = rdir([boxdir, '\*\*']);
for i = 1:length(tmpdirlist)
    if ~tmpdirlist(i).isdir; break; end;
    dirlist(i) = tmpdirlist(i);
end
clear tmpdirlist;
interv = 20;
timerange = [0 600];

%jstouch args
hold_time = 300;
targ_rew = 0.25;
dist_thresh = 100;
all_traj_flag = 0;
plotflag = 0;
statslist = load_stats(dirlist, 2, 'traj_struct');
offset(2) = min(length(statslist), offset(2));
statslist = statslist(offset(1):offset(2));
accumdata = []; medians = zeros(length(statslist), 1);
for i = 1:length(statslist);
    stats = statslist(i);
    try
        [~, holddist_vect, medians(i)] = js_touch_dist(stats, interv, hold_time, ...
            targ_rew,dist_thresh, all_traj_flag, plotflag);
        accumdata = [accumdata; holddist_vect];
    catch e;
        disp(['Failed on Day ', num2str(i)]);
    end
end
clear targ_rew hold_time dist_thresh all_traj_flag plotflag holddist_vect
accumdata = [accumdata; zeros(1, size(accumdata, 2))];
x = 0:interv:timerange(2);
y = (1:size(accumdata, 1))+offset(1)-1;
figure; ax = gca;
pcolor(ax, x, y, accumdata);
shading flat;
title(ax, 'JS Hold Time Distribution');
xlabel(ax, 'Hold Time (ms)');
ylabel(ax, 'Day');
colorbar;
for i = 1:length(medians)
    j = i-1 + offset(1);
    line([timerange(1)-200 timerange(2)+200], ([j j]), 'LineWidth', 0.5, 'Color', [0 0 0]);
    line([medians(i) medians(i)],[j j+1], 'LineWidth', 4, 'Color', [1 1 1]*0); 
end
    
set(ax, 'XTick', timerange(1):200:timerange(2));

