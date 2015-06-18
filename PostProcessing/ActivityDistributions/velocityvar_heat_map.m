function [variationdata, labels] = velocityvar_heat_map(stats,varargin)
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