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
%       DEFAULT - :: 200
%
%   rew_filter :: only rewarded trajectories will be analyzed
%       DEFAULT :: 1
%
%   axlst :: list of axes handles for trajectory_variability_heat_map to
%       plot onto. If provided, must have as many valid axes handles as
%       numgroups. If empty, a new figure with subplots is generated
%       DEFAULT - []
%   
default = {3, 50, []};
numvarargs = length(varargin);
if numvarargs > 6
    error('too many arguments (> 7), only 1 required and 6 optional.');
end
[default{1:numvarargs}] = varargin{:};
[numgroups, min_ht, axlst] = default{:};

trajstruct = filter_trajectories(trajstruct); 


generate_heat_map(trajstruct)

end

function [trajstruct] = filter_trajectories(trajstruct, min_ht, rewflag)
% returns a filtered version of trajstruct - returned value has only
% trajectories above min_ht, and if rewflag is enabled, trajectories that
% were rewarded

end

function [output_args] = align_target(traj_x, traj_y)
% performs coordinate transformation  of traj_x and traj_y to polar
% coordinate system and then aligns by polar angle of end point.

end

function generate_heat_map(trajstruct)

end