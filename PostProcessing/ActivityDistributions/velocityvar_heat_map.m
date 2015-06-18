function [variationdata, labels] = velocityvar_heat_map(stats,varargin)
%velocityvar_heat_map(stats, [ax, data]) plots the difference in
%75th and 25th percentiles for the velocity profile of the trajectories in stats
% ARGUMENTS:
%   stats :: single stats structure
%   ax :: an axes handle (can be empty) for where to plot 
%   data :: since the function get_vel_accel_distr is costly, the plotting
%       routine can take in data directly if it has already been computed

default = {[], []};
numvarargs = length(varargin);
if numvarargs > 2
    error('too many arguments (> 3), only 1 required and 2 optional.');
end
[default{1:numvarargs}] = varargin{:};
[ax, variationdata] = default{:};
if isempty(variationdata)
    [~, variationdata] = get_vel_accel_distr(stats,varargin);
end
if length(ax) < 1
    figure;
    ax(1) = gca(); 
end
tstr = 'Velocity Variation Distribution';
labels = draw_heat_map(variationdata, ax,tstr, -100:1:100, 1, [5 75]);

end