function medians = multipcolor_allht(boxdir)
%this function generates a pcolor hold time distribution progression for
%multiple days

tmpdirlist = rdir([boxdir, '\*\*']);
for i = 1:length(tmpdirlist)
    if ~tmpdirlist(i).isdir; break; end;
    dirlist(i) = tmpdirlist(i);
end
clear tmpdirlist;
offset = 2;
dirlist = dirlist(1+offset:end);

interv = 50;
timerange = [0 1100];
[data, ~, ht_stats] = get_rewardandht_times(dirlist, interv, timerange, 2);

accumdata = []; medians = zeros(length(data), 1);
for i = 1:length(data);
    tmpdata = data{i};
    time = tmpdata(:, 1);
    ht_hist = tmpdata(:, 2);
    accumdata = [accumdata; ht_hist'];
    tmpstats = ht_stats{i};
    medians(i) = tmpstats.ht(2);
end
x = time;
y = (1:size(accumdata, 1))+offset;
figure; ax = gca;
pcolor(ax, x, y, accumdata);
shading flat;
title(ax, 'Hold Time Distribution');
xlabel(ax, 'Hold Time (ms)');
ylabel(ax, 'Day');
colorbar;
for i = 1:length(y)
    j = i+offset;
    line(timerange, [j j], 'LineWidth', 0.5, 'Color', [0 0 0]);
    line([medians(i) medians(i)],[j j+1], 'LineWidth', 2, 'Color', [1 1 1]); 
end
    
set(ax, 'XTick', timerange(1):200:timerange(2));

