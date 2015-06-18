function [mediandata, labels] = velocity_heat_map(stats,varargin)
%activity_color_map(stats [plotflag, ax, logmapping, colorperc ]) plots a velocity heat map given
%by the valid trajectories
% ARGUMENTS:
%   stats :: single stats structure
%   logmappping :: a flag indicating whether the function should plot using
%       a logarithmic scale, or standard scale (1 or 0)
%   colorperc :: [lower upper] - colorperc defines the color percentiles
%       for the color mapping when logarithmic mapping is turned off
%   ax :: an axes handle (can be empty) for where activity_color_map should
%       plot 

default = {[], []};
numvarargs = length(varargin);
if numvarargs > 3
    error('too many arguments (> 4), only one required and three optional.');
end
[default{1:numvarargs}] = varargin{:};
[ax, mediandata] = default{:};
if isempty(mediandata)
    [mediandata] = get_vel_accel_distr(stats,varargin);
end
if length(ax) < 1
    figure;
    ax(1) = gca(); 
end
tstr = 'Velocity Distribution';
labels = draw_heat_map(mediandata, ax,tstr, -100:1:100, 1, [5 80]);

end