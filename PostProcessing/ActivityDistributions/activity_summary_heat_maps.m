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
vel = data.vel; velvar=data.velvar; accel=data.accel; 
accelvar = data.accelvar; acceltan = data.accel_tan;
if length(ax) < 5
    figure;    
    for j = 1:6
        ax(j) = subplot(2, 3, j);
    end
end
activity_heat_map(stats, 1, [2 99], ax(1));
%testing to see if this will work
velocity_heat_map([], ax(2), vel);
velocityvar_heat_map([], ax(3), velvar);
accel_heat_map([], ax(4), accel);
accelvar_heat_map([], ax(5), accelvar);
acceltan_heat_map([], ax(6), acceltan);
end