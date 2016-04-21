function [data, labels, fig_handle] = activity_heat_map(stats, varargin)
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

default = {1, [25 75], [], [1 100], 0, 1, 1};
numvarargs = length(varargin);
if numvarargs > 8
    error('too many arguments (> 9), only one required and 7 optional.');
end
[default{1:numvarargs}] = varargin{:};
[logmapping, colorperc, ax, radii, traj_id, rwonly,plot_flag] = default{:};

if plot_flag==1
    if (length(ax)<1)
        fig_handle = figure;
        ax = gca();
    end
end

if logmapping == 1
    colorperc = [0 99];
end
ext = '';
if traj_id == 1;
    ext = ' (Laser Only)';
elseif traj_id == 2;
    ext = ' (No Laser Only)';
elseif traj_id == 3;
    ext = ' (No Laser Only - Resampled)';
end
if plot_flag==1
    stats = get_stats_with_trajid(stats,traj_id);
    data = trajectorypdf(stats,rwonly);
    labels = draw_heat_map(data, ax, ['Activity Distribution',ext], logmapping, colorperc, radii);
end




