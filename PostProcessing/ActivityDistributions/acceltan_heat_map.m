function [acceldata, labels] = acceltan_heat_map(dirlist,varargin)
%acceltan_heat_map(dirlist, [ax, data]) plots the median of the tangential 
%acceleration profile of each cell given by the trajectories in dirlist
% ARGUMENTS:
%   dirlist :: list of days (directory struct representation)
%   ax :: an axes handle (can be empty) for where to plot 
%   data :: since the function get_vel_accel_distr is costly, the plotting
%       routine can take in data directly if it has already been computed

default = {[], [], 1};
numvarargs = length(varargin);
if numvarargs > 2
    error('too many arguments (> 3), only 1 required and 2 optional.');
end
[default{1:numvarargs}] = varargin{:};
[ax, acceldata, bin] = default{:};
if isempty(acceldata)
    data = get_vel_accel_distr(dirlist,bin);
    acceldata = data.accel_norm;
end
if length(ax) < 1
    figure;
    ax(1) = gca(); 
end
tstr = 'Normal Acceleration Distribution';
labels = draw_heat_map(acceldata, ax,tstr, 0, [1 85]);

end