function [acceldata, labels] = accelang_heat_map(dirlist,varargin)
% accelang_heat_map(dirlist, [ax, data, bin])
%
%   plots the median of the angular acceleration profile given by the 
%       trajectories in dirlist for a group of cells with size defined by bin
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
%       bin :: bin size for looking at angular acceleration. 
%           Because of the way that data is computed, calling the script
%           with a larger bin size will run faster
%           DEFAULT :: 4


default = {[], [], 4};
numvarargs = length(varargin);
if numvarargs > 3
    error('too many arguments (> 4), only 1 required and 3 optional.');
end
[default{1:numvarargs}] = varargin{:};
[ax, acceldata, bin] = default{:};
if isempty(acceldata)
    data = get_vel_accel_distr(dirlist,bin);
    acceldata = data.accel_ang;
end
if length(ax) < 1
    figure;
    ax(1) = gca(); 
end
tstr = 'Angular Acceleration Distribution';
labels = draw_heat_map(acceldata, ax,tstr, 1, [0 10]);

end