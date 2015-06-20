function activity_summary_heat_maps(stats,varargin)
%activity_summary_heat_maps(stats) plots the activity heat map, velocity
%and acceleration profiles including variation on a single figure
% ARGUMENTS:
%   stats :: single stats structure
%   OPTIONAL:
%   ax :: at least 5 axes (different) instructing
%       activity_summary_heat_maps where to plot distributions

default = {[]};
numvarargs = length(varargin);
if numvarargs > 3
    error('too many arguments (> 4), only one required and three optional.');
end
[default{1:numvarargs}] = varargin{:};
[ax] = default{:};
[data] = get_vel_accel_distr(stats,varargin);
vel = data.vel; velvar=data.velvar; accel=data.accel; accelvar = data.accelvar;
if length(ax) < 5
    figure;
    ax(1) = subplot(2, 4, [1, 2, 5, 6]);
    j = 2;
    for i = [3,4,7,8]
        ax(j) = subplot(2, 4, i);
        j=j+1;
    end
end
activity_heat_map(stats, 1, [2 99], ax(1));
%testing to see if this will work
velocity_heat_map([], ax(2), vel);
velocityvar_heat_map([], ax(3), velvar);
accel_heat_map([], ax(4), accel);
accelvar_heat_map([], ax(5), accelvar);
end