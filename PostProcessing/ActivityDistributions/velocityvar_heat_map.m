function [variationdata, labels] = velocityvar_heat_map(dirlist,varargin)
%velocityvar_heat_map(dirlist, [ax, data, bin]) plots the difference in
%75th and 25th percentiles for the velocity profile of the trajectories in stats
% ARGUMENTS:
%   dirlist :: list of days (directory struct representation)
%   ax :: an axes handle (can be empty) for where to plot 
%   data :: since the function get_vel_accel_distr is costly, the plotting
%       routine can take in data directly if it has already been computed
%   bin :: bin size for looking at acceleration. Because of the way that
%       data is computed, calling the script with a larger bin size will
%       run faster
%       DEFAULT :: 4

default = {[], [], 4};
numvarargs = length(varargin);
if numvarargs > 3
    error('too many arguments (> 4), only 1 required and 3 optional.');
end
[default{1:numvarargs}] = varargin{:};
[ax, variationdata, bin] = default{:};
if isempty(variationdata)
    [data] = get_vel_accel_distr(dirlist,bin);
    variationdata = data.velv;
end
if length(ax) < 1
    figure;
    ax(1) = gca(); 
end
tstr = 'Velocity Variation Distribution';
labels = draw_heat_map(variationdata, ax,tstr, 1, [5 75]);

end