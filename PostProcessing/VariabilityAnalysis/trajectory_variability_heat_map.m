function [ output_args ] = trajectory_variability_heat_map(stats, varargin)
%[ output_args ] = trajectory_variability_heat_map(stats, [numgroups, min_ht, axlst])
%
%   trajectory_variability_heat_map analyzes the inherent variability in
%   various trajectories by aligning each trajectory by its end point, and
%   then generating a heat map with all these trajectories aligned. It 
%   filters trajectories, looking only at trajectories above a certain hold
%   time, and groups these trajectories into time blocks from stats 
%   (traj_struct is in chronological order)
%
% ARGUMENTS:
%
%   stats :: standard stats structure (typically across an entire
%       contingency to evaluate variability and learning
%
% OPTIONAL ARGS:
%
%   numgroups :: number of chronological blocks that are created for
%       analysis
%       DEFAULT - 3
%
%   ht_range :: only trajectories in the range ht_range will be considered
%       in analysis 
%       DEFAULT - :: [300 800]
%
%   rew_filter :: only rewarded trajectories will be analyzed
%       DEFAULT :: 1
%
%   axlst :: list of axes handles for trajectory_variability_heat_map to
%       plot onto. If provided, must have as many valid axes handles as
%       numgroups. If empty, a new figure with subplots is generated
%       DEFAULT - []
%   
default = {3, [300 800], 50 []};
numvarargs = length(varargin);
if numvarargs > 6
    error('too many arguments (> 7), only 1 required and 6 optional.');
end
[default{1:numvarargs}] = varargin{:};
[numgroups, ht_range, axlst] = default{:};

tstruct = stats.traj_struct;
bin = sort_traj_into_bins(tstruct, ht_range); 
tstruct = bin.traj_struct;

indices = floor(linspace(1, numgroups+1-2*eps(numgroups), length(tstruct)));
endpoints = [1, find(diff(indices)), length(tstruct)];
for i = 2:length(endpoints)
    heat_map = generate_heat_map(tstruct(endpoints(i-1):endpoints(i)));
end


end

%only adds points above a certain range to the heat map
function heat_map = generate_heat_map(trajstruct, threshold)

end

function [rad, theta] = align_target(traj_x, traj_y)
% performs coordinate transformation  of traj_x and traj_y to polar
% coordinate system and then aligns by polar angle of end point.

[theta, rad] = cart2pol(traj_x, traj_y);
theta = theta*180/pi;

%align by angle to radial line of end point.
theta = theta - theta(end);

%now make sure we put everything in the range -180 to 180
theta = theta-360*(theta>180)+360*(theta<180);


end