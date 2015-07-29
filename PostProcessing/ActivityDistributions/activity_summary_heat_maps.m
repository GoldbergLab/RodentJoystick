function activity_summary_heat_maps(dirlist,varargin)
% activity_summary_heat_maps(dirlist, [bin]) 
%
%   plots the activity, velocity, velocity variation, acceleration,
%   acceleration variation, normal acceleration, and radial acceleration on a
%   single figure
%
% ARGUMENTS:
%
%       dirlist :: list of days (directory struct representation)
%
% OPTIONAL:
%       ax :: at least 6 axes (different) instructing
%           activity_summary_heat_maps where to plot distributions
tic;
default = {5, []};
numvarargs = length(varargin);
if numvarargs > 3
    error('too many arguments (> 4), only one required and three optional.');
end
[default{1:numvarargs}] = varargin{:};
[bin, ax] = default{:};
[data] = get_vel_accel_distr(dirlist,bin);
vel = data.vel; velvar=data.velv; accel=data.accel; 
accelvar = data.accelv; accelnorm = data.accel_norm;
accelang = data.accel_ang;
if length(ax) < 7
    figure;    
    for j = 1:7
        ax(j) = subplot(2, 4, j);
    end
end
statscombined = load_stats(dirlist, 1);
activity_heat_map(statscombined, 1, [2 99], ax(1));
%testing to see if this will work - shouldn't matter that no valid stats
%struct is passed
velocity_heat_map([], ax(2), vel);
velocityvar_heat_map([], ax(3), velvar);
accel_heat_map([], ax(4), accel);
accelvar_heat_map([], ax(5), accelvar);
accelnorm_heat_map([], ax(6), accelnorm);
accelang_heat_map([], ax(7), accelang);
toc;
end