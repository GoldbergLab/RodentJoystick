function [acceldata, labels] = accel_heat_map(stats,varargin)
%velocityvar_heat_map(stats, [ax, data]) plots a velocity heat map given
%by the valid trajectories
% ARGUMENTS:
%   stats :: single stats structure
%   ax :: an axes handle (can be empty) for where activity_color_map should
%       plot 

default = {[], []};
numvarargs = length(varargin);
if numvarargs > 2
    error('too many arguments (> 3), only 1 required and 2 optional.');
end
[default{1:numvarargs}] = varargin{:};
[ax, acceldata] = default{:};
if isempty(acceldata)
    [~, ~, acceldata] = get_vel_accel_distr(stats,varargin);
end
if length(ax) < 1
    figure;
    ax(1) = gca(); 
end
tstr = 'Acceleration Distribution';
labels = draw_heat_map(acceldata, ax,tstr, -100:1:100, 0, [10 85]);

end