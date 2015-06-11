function [fh, cache] = np_js_distribution(jstruct, varargin)
%np_js_distribution(jstruct) plots the nose poke joy stick touch
%distribution for the data from a given jstruct
default = {'no'};
numvarargs = length(varargin);
if numvarargs > 1
    error('np_js_distribution: too many arguments (> 2), only one required and one optional.');
end
[default{1:numvarargs}] = varargin{:};
[cacheonly] = default{:};

jstruct_stats = xy_getstats(jstruct);
dist_time = -1000:20:1000;
np_js_plot = histc(jstruct_stats.np_js,dist_time);
np_js_plot = np_js_plot./(sum(np_js_plot));
cache.np_js_plot = np_js_plot;
cache.dist_time = dist_time;
cache.xlabel = 'Time (ms)';
cache.ylabel = 'Probability';
cache.title = 'JS NP distribution';
cache.date = datestr(jstruct(3).real_time, 'mm/dd/yyyy');

if strcmp(cacheonly, 'no')
    fh = figure;  hold on;
    xlabel(cache.xlabel); 
    ylabel(cache.ylabel); 
    title(cache.title);
    stairs(dist_time,cache.np_js_plot,'LineWidth',2);
    legend(cache.date);
end
end

