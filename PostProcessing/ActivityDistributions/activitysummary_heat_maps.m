function activity_summary_heat_maps(stats,varargin)
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

default = {[]};
numvarargs = length(varargin);
if numvarargs > 3
    error('too many arguments (> 4), only one required and three optional.');
end
[default{1:numvarargs}] = varargin{:};
[ax] = default{:};
[vel, velvar, accel, accelvar] = get_vel_accel_distr(stats,varargin);
if length(ax) < 5
    figure;
    for i = 1:6
        ax(i) = subplot(2, 3, i);
    end
end
activity_heat_map(stats, 1, [2 99], ax(1));
%testing to see if this will work
velocity_heat_map([], ax(2), vel);
velocity_heat_map([], ax(3), velvar);
velocity_heat_map([], ax(4), accel);
velocity_heat_map([], ax(5), accelvar);
end