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
if (length(ax)<1); figure; ax = gca(); end
if logmapping == 1
    colorperc = [0 99];
end

%pick trajectories
if (traj_id == 1)
 for stat_index=1:length(stats)
     tstruct = stats(stat_index).traj_struct;
     output = arrayfun(@(y) ~isempty(find(y.laser == 1)), tstruct);
     tstruct = tstruct(output);
     stats(stat_index).traj_struct=tstruct;
 end
elseif (traj_id==2)
 for stat_index=1:length(stats)
     tstruct = stats(stat_index).traj_struct;
     output = arrayfun(@(y) ~isempty(find(y.laser == 0)), tstruct);
     tstruct = tstruct(output);
     stats(stat_index).traj_struct=tstruct;
 end
else 
 % do nothing, all trajectories go into computation
end

data = trajectorypdf(stats);
labels = draw_heat_map(data, ax, 'Activity Distribution', logmapping, colorperc, radii);

