function [data, labels] = activity_heat_map(stats, varargin)
% [data, labels] = activity_heat_map(stats, [ax, logmapping, colorperc])
%   
%   plots the probability distribution given by stats.traj_pdf_jstrial onto
%   the axes handle ax if available (otherwise it simply generates a new figure)
%
% ARGUMENTS:
%
%       stats :: single stats structure
%
% OPTIONAL ARGS:
%
%       logmappping :: a flag indicating whether the function should plot using
%           a logarithmic scale, or standard scale (1 or 0)
%
%       colorperc :: [lower upper] - colorperc defines the color percentiles
%           for the color mapping when logarithmic mapping is turned off
%
%       ax :: an axes handle (can be empty) for where activity_color_map should
%           plot
%

default = {1, [25 75], [], [1 100], 0};
numvarargs = length(varargin);
if numvarargs > 5
    error('too many arguments (> 6), only one required and 5 optional.');
end
[default{1:numvarargs}] = varargin{:};
[logmapping, colorperc, ax, radii, traj_id] = default{:};
if (length(ax)<1)
    figure; 
    if traj_id > 2
        ax(1) = subplot(2, 1, 1);
        ax(2) = subplot(2, 1, 2); 
    else
        ax = gca();
    end
end

if logmapping == 1
    colorperc = [0 99];
end

stats = get_stats_with_trajid(stats,traj_id);

if traj_id > 2
    for i = 1:2
        data = trajectorypdf(stats{i});
        labels = draw_heat_map(data, ax(i), 'Activity Distribution', logmapping, colorperc, radii);
    end
else
    data = trajectorypdf(stats);
    labels = draw_heat_map(data, ax(1), 'Activity Distribution', logmapping, colorperc, radii);
end

