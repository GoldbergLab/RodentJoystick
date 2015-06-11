function [fh, cache] = np_post_distribution(jstruct, varargin)
%np_js_distribution(jstruct) plots the nose poke vs post touch time
%distribution for the data from a given jstruct
default = {'no'};
numvarargs = length(varargin);
if numvarargs > 1
    error('trajectory_analysis: too many arguments (> 3), only one required and two optional.');
end
[default{1:numvarargs}] = varargin{:};
[cacheonly] = default{:};

jstruct_stats = xy_getstats(jstruct);
dist_time = -1000:20:1000;
np_post_plot = histc(jstruct_stats.np_js_post,dist_time);
np_post_plot = np_post_plot./(sum(np_post_plot));
cache.np_post_plot = np_post_plot;
cache.dist_time = dist_time;
cache.xlabel = 'Time (ms)';
cache.ylabel = 'Probability';
cache.title = 'Post NP distribution';
cache.date = datestr(jstruct(3).real_time, 'mm/dd/yyyy');
if strcmp(cacheonly, 'no')
    stairs(dist_time,cache.np_post_plot,'LineWidth',2);
    xlabel(cache.xlabel); ylabel(cache.ylabel);
    legend(cache.date);
end

