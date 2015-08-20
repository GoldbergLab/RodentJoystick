function multipcolor_trajectory_analysis(boxdir)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

tmpdirlist = rdir([boxdir, '\*\*']);
for i = 1:length(tmpdirlist)
    if ~tmpdirlist(i).isdir; break; end;
    dirlist(i) = tmpdirlist(i);
end
clear tmpdirlist;
offset = 0;
dirlist = dirlist((1+offset):end);

timerange = [200 800];
bins = 4;

statslist = load_stats(dirlist, 2, 'traj_struct');
for i = 1:bins;
    accumdata(i).median = [];
    accumdata(i).ubd = [];
    accumdata(i).lbd = [];
end

for i = 1:length(statslist);
    stats = statslist(i);
    try
        plotflag = 0;
        bin_summary = trajectory_analysis(stats, ...
            0, bins, timerange, [], plotflag);
        for j = 1:bins
            lbd = bin_summary(j).lowerbnd;
            ubd = bin_summary(j).upperbnd;
            md = bin_summary(j).md;
            accumdata(j).median = [accumdata(j).median; md];
            accumdata(j).ubd = [accumdata(j).ubd; ubd];
            accumdata(j).lbd = [accumdata(j).lbd; lbd];
            xlimits(j) = bin_summary(j).lt-1;
        end
    catch e;
        disp(getReport(e));
        disp(['Failed on Day ', num2str(i+offset)]);
    end
end
clear targ_rew hold_time dist_thresh all_traj_flag plotflag holddist_vect
y = (1:(size(accumdata(1).median, 1)+1))+offset;
figure; 
for i = 1:bins
    median = accumdata(i).median;
    median = [median; zeros(1, size(median, 2))];
    ubd = accumdata(i).ubd;
    ubd = [ubd; zeros(1, size(ubd, 2))];
    lbd = accumdata(i).lbd;
    lbd = [lbd; zeros(1, size(lbd, 2))];
    x = 1:1:xlimits(i);
    ax = subplot(3, bins, i+bins);
    pcolor(ax, x, y, median);
    caxis(ax, [0 100]);
    shading flat;
    title(ax, 'Median Trajectory Deviation');
    xlabel(ax, 'Time(ms)');
    ylabel(ax, 'Day');
    
    ax2 = subplot(3, bins, i);
    pcolor(ax2, x, y, ubd);
    caxis(ax2, [0, 100]);
    shading flat;
    title(ax2, '75th percentile Trajectory Deviation');
    xlabel(ax2, 'Time(ms)');
    ylabel(ax2, 'Day');

    ax3 = subplot(3, bins, i+2*bins);
    pcolor(ax3, x, y, lbd);
    caxis(ax3, [0, 100]);
    shading flat;
    title(ax3, '25th percentile Trajectory Deviation');
    xlabel(ax3, 'Time(ms)');
    ylabel(ax3, 'Day');
%     for j = 1:length(median)
%         k = j+offset;
%         line(ax, [-1000 2000], [k k], 'LineWidth', 1, 'Color', [0 0 0]);
%         line(ax2, [0 2000], [k k], 'LineWidth', 1, 'Color', [0 0 0]);
%         line(ax3, [0 2000], [k k], 'LineWidth', 1, 'Color', [0 0 0]);
%     end
end
