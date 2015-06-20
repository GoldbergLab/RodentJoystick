function [accelvar, labels] = accelvar_heat_map(stats,varargin)
%accelvar_heat_map(stats, [ax, data]) plots the difference in
%75th and 25th percentiles for the acceleration profile of the trajectories in stats
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
[ax, accelvar] = default{:};
if isempty(accelvar)
    data = get_vel_accel_distr(stats,varargin);
    accelvar = data.accelvar;
end
if length(ax) < 1
    figure;
    ax(1) = gca(); 
end
tstr = 'Acceleration Variation Distribution';
labels = draw_heat_map(accelvar, ax,tstr, -100:2:100, 0, [10 85]);

end