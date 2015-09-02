function [alltrajcounts] = multipcolor_trajectory_analysis(boxdir, dayrange)
% multipcolor_trajectory_analysis(boxdir, dayrange)
%   
%   generates a p color plot showing the median deviation for trajectories
%   binned by hold time plotting the distribution starts. 
%
% ARGUMENTS
%
%   boxdir :: the directory containing all data for a specific mouse
%       Currently can only be one entry (haven't handled cases of switched
%       boxes)
%
%   dayrange :: it's unlikely that the first couple of days will have
%       nough data to run trajectory_analysis. dayrange provides a start
%       and end day for trajectory_analysis to run on
%       
%

pcolorflag = 1;

dayoffset = dayrange(1);
endday = dayrange(2);

tmpdirlist = rdir([boxdir, '\*\*']);
k=0;
for i = 1:length(tmpdirlist)
    if ~tmpdirlist(i).isdir; break; end;
    dirlist(i) = tmpdirlist(i);
    day = strsplit(dirlist(i).name, '\');
    day = day{end};
    if ~(exist('prevday', 'var') && strcmp(prevday, day))
        k = k+1;
    end
    [thresh2, ht, thresh] ...
            = extract_contingency_info(dirlist(i).name);
    prevday = day;
    radii(k, 1) = thresh2; radii(k, 2) = thresh;
    holdtimes(k) = ht; 
end
clear tmpdirlist;
dirlist = dirlist(1:end);

timerange = [200 600];
bins = 2;

statslist = load_stats(dirlist, 2, 'traj_struct');
for i = 1:bins;
    accumdata(i).median = [];
end
endday = min(length(statslist), endday);
statslist = statslist(dayoffset:endday);
radii = radii(dayoffset:endday, :);
alltrajcounts = [];

for i = 1:length(statslist);
    stats = statslist(i);
    try
        plotflag = 0;
        bin_summary = trajectory_analysis(stats, ...
             0, bins, timerange, [], plotflag);
        allbincounts = [];
        for j = 1:bins
            md = smooth(bin_summary(j).md, 5)';
            accumdata(j).median = [accumdata(j).median; md];
            xlimits(j) = bin_summary(j).lt-1;
            counts = [bin_summary(j).trajcount, bin_summary(j).alltrajcount];
            allbincounts = [allbincounts, counts];
        end
    catch e;
        disp(getReport(e));
        disp(['Failed on Day ', num2str(i+dayoffset)]);
    end
    alltrajcounts = [alltrajcounts; allbincounts];
end
clear targ_rew hold_time dist_thresh all_traj_flag plotflag holddist_vect
y = (0:(size(accumdata(1).median, 1)))+dayoffset;
figure; 

factor = 6.35/100;
colorscale = [0 80].*factor;
for i = 1:bins
    median = accumdata(i).median;
    median = [median; zeros(1, size(median, 2))].*factor;
    x = 1:1:xlimits(i);
    ax = subplot(1, bins, i);
    if pcolorflag
        pcolor(ax, x, y, median); caxis(ax, colorscale); 
    else
        sfhandle = surf(x, y, median);
        set(sfhandle, 'MeshStyle', 'row');
        set(sfhandle, 'XLim', [0 200*i+200]);
    end
    shading flat;
    bin = [0 200]+i*[200 200];
    title(ax, ['Median Trajectory Displacement: ', ...
        num2str(bin(1)), ' - ' num2str(bin(2))] );
    xlabel(ax, 'Time(ms)');
    ylabel(ax, 'Day');
    set(ax, 'XTick', 0:100:(xlimits(i)+1));
    for j = y(1:end-1)
        line([0 2000], [j j], 'LineWidth', 0.5, 'Color', [0 0 0]);
        line([holdtimes(j) holdtimes(j)],[j j+1], 'LineWidth', 2, ...
            'Color', [1 1 1]*1); 
    end

end
figure;
x = 1:2;
radii = [radii; zeros(1, size(radii, 2))];
radii = [radii, zeros(size(radii, 1), 1)];

ax2= subplot(1, 2, 1);
data = radii(:, 1:2).*factor;
pcolor(ax2, x, y, data);
caxis(ax2, colorscale); shading flat;
set(ax2, 'XTickLabel', {''});
title(ax2, 'Displacement Threshold'); ylabel(ax2, 'Day');

ax3= subplot(1, 2, 2);
data =  radii(:, 2:3).*factor;
pcolor(ax3, x, y, data);
caxis(ax3, colorscale); shading flat;
set(ax3, 'XTickLabel', {''});
title(ax3, 'Hold Threshold'); ylabel(ax3, 'Day');
colorbar; 

axes(ax2);
for i = y
    line([-1 2], [i i], 'LineWidth', 0.5, 'Color', [0 0 0]);
end
axes(ax3);
for i = y
    line([-1 2], [i i], 'LineWidth', 0.5, 'Color', [0 0 0]);
end

