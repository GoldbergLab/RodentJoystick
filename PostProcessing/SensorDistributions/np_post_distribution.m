function [fh] = np_post_distribution(jstruct, varargin)
%np_js_distribution(jstruct) plots the nose poke vs post touch time
%distribution for the data from a given jstruct
default = {'no', []};
numvarargs = length(varargin);
if numvarargs > 2
    error('trajectory_analysis: too many arguments (> 3), only one required and two optional.');
end
[default{1:numvarargs}] = varargin{:};
[EXISTING, FHANDLE] = default{:};
jstruct_stats = xy_getstats(jstruct);
dist_time = -1000:20:1000;
np_post_plot = histc(jstruct_stats.np_js_post,dist_time);
np_post_plot = np_post_plot./(sum(np_post_plot));
fh = FHANDLE;
if strcmp('no', EXISTING)
    fh = figure;
else
    figure(fh)
end
hold on;
stairs(dist_time,np_post_plot,'LineWidth',2); hold on
xlabel('Time (ms)'); ylabel('Probability');
title('Post NP distribution');
legend(legend, datestr(jstruct(3).real_time, 'mm/dd/yyyy'));
end

