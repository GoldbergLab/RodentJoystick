function [mediandata, labels] = velocity_heat_map(dirlist,varargin)
%velocity_heat_map(dirlist, [ax, data]) plots the median of the velocity
%profile given by the trajectories in dirlist
% ARGUMENTS:
%   dirlist :: list of days (directory struct representation)
%   ax :: an axes handle (can be empty) for where to plot 
%   data :: since the function get_vel_accel_distr is costly, the plotting
%       routine can take in data directly if it has already been computed

default = {[], []};
numvarargs = length(varargin);
if numvarargs > 3
    error('too many arguments (> 4), only one required and three optional.');
end
[default{1:numvarargs}] = varargin{:};
[ax, mediandata] = default{:};
if isempty(mediandata)
    [data] = get_vel_accel_distr(dirlist,varargin);
    mediandata = data.vel;
end
if length(ax) < 1
    figure;
    ax(1) = gca(); 
end
tstr = 'Velocity Distribution';
labels = draw_heat_map(mediandata, ax,tstr, -100:2:100, 1, [5 80]);

end