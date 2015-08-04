function [accelvar, labels] = accelvar_heat_map(dirlist,varargin)
% accelnorm_heat_map(dirlist, [ax, data, bin])
%
%   plots the difference between the 75th and 25th percentiles of the 
%   acceleration profile given by the trajectories in dirlist for a group 
%   of cells with size defined by bin
%
% ARGUMENTS:
%
%       dirlist :: list of days (directory struct representation)
%
% OPTIONAL ARGS:
%
%       ax :: an axes handle (can be empty) for where to plot 
%
%       data :: since the function get_vel_accel_distr is costly, the plotting
%           routine can take in data directly if it has already been computed
%       
%       bin :: bin size for looking at data. Because of the way that
%           data is computed, calling the script with a larger bin size will
%           run faster
%           DEFAULT :: 4

default = {[], [], 4};
numvarargs = length(varargin);
if numvarargs > 3
    error('too many arguments (> 4), only 1 required and 3 optional.');
end
[default{1:numvarargs}] = varargin{:};
[ax, accelvar, bin] = default{:};
if isempty(accelvar)
    data = get_vel_accel_distr(dirlist,bin);
    accelvar = data.accelv;
end
if length(ax) < 1
    figure;
    ax(1) = gca(); 
end
tstr = 'Acceleration Variation Distribution';
labels = draw_heat_map(accelvar, ax,tstr, 0, [10 85]);

end