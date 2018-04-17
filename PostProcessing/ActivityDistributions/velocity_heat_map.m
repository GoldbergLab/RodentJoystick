function [mediandata, labels] = velocity_heat_map(stats,varargin)
%velocity_heat_map(dirlist, [ax, data, bin]) plots the median of the velocity
%profile given by the trajectories in dirlist
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
[ax, mediandata,bin] = default{:};
stats = get_stats_with_len(stats,50);
if isempty(mediandata)
    [data] = get_velaccel_xy(stats);
    mediandata = (data.vel_hist)./(data.vel_count);
end
if length(ax) < 1
    figure;
    ax(1) = gca(); 
end
tstr = 'Velocity Distribution';
labels = draw_heat_map(mediandata, ax,tstr, 0, [5 90]);

end