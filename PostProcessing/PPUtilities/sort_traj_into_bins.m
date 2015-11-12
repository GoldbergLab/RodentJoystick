function sortedtraj = sort_traj_into_bins(tstruct, bins, varargin)
% sortedtraj = sort_traj_into_bins(tstruct, bins ,[rwfilter, ht_definition]) 
%
%   generates a struct representation of a trajectory struct binned by hold
%   time. Also supports filtering by reward (returns only rewarded
%   trajectories).
%
% OUTPUTS:
%
%   sortedtraj :: struct with length equal to length(bins)-1. 
%       Each cell of sortedtraj (sortedtraj(i)) has the following fields
%
%           qeq :: greater than or equal to - the lower hold time limit 
%               (inclusive) as a double of all trajectories in the cell
%
%           lt :: less than - the upper hold time limit for all
%               trajectories (also a double) in the cell
%
%           traj_struct :: a trajectory structure with the exact same
%               fields as tstruct (from the stats structure). Possibly
%               empty if bins & rwfilter are poorly selected.
%
% ARGUMENTS
%
%   tstruct :: the trajectory structure to be binned (from stats.traj_struct)
%
%   bins :: a vector defining how the trajectories should be binned: 
%       EX: bins = [200 300 400 500] will result in sortedtraj containing 3
%       bins, defined by the ranges 200-300, 300-400, 400-500.
%
% OPTIONAL ARGS
%
%   rwfilter :: a flag indicating whether or not to filter by reward - if
%       on (1), then only trajectories in tstruct that have been rewarded
%       will be sorted and added to the bins. Otherwise bins all
%       trajectories in tstruct (0)
%       DEFAULT - 0
%
%   ht_definition :: flag indicating which definition of hold time should
%       be used for binning;
%       0 - rw_or_stop
%       1 - length(traj_x)
%       DEFAULT - 0

%% Argument Manipulation
default = {0, 0};
numvarargs = length(varargin);
if numvarargs > 2
    error('too many arguments (> 4), only 2 required and 2 optional.');
end
[default{1:numvarargs}] = varargin{:};
[rwfilter, ht_definition] = default{:};

%% Create struct representation based on bins, and indices to keep track of
% where trajectory should go
for i = 2:length(bins)
   sortedtraj(i-1) = struct('geq', bins(i-1),'lt',bins(i));
end
bin_traj_indices = ones(length(bins)-1, 1); 

%% Iterate over each trajectory in tstruct, binning appropriately
%each bin has a vector of trajectory structures (simplified from tstruct)
% store the indices so we know at what index to add each new trajectory
for i = 1:length(tstruct)
    %This is where our definition of hold time comes into effect:
    if ht_definition
        ht = length(tstruct(i).traj_x);
    else
        ht = tstruct(i).rw_or_stop;
    end
    bin_ind = bin_index(bins,ht);
    
    %first check if it was binned in the range, if it was 
    % check that it was rewarded if rwfilter was on
    if bin_ind ~= -1 && (tstruct(i).rw || ~rwfilter)
        traj_ind = bin_traj_indices(bin_ind);
        bin_traj_indices(bin_ind) = bin_traj_indices(bin_ind) + 1;
        sortedtraj(bin_ind).traj_struct(traj_ind)= tstruct(i);
    end
end
end

% Bin indexing starts with 1 at the first nonzero element. Ie, If the bins
% are distributed as bins = [0 10 20 30 40],
%       bin_index(bins, 5) = 1, bin_index(bins 0) = 1
%       bin_index(bins, 9) = 1, bin_index(bins 10) = 2
function bin_ind = bin_index(bins, time)
    bin_ind = -1;
    for i = 2:length(bins)
        if time < bins(i) && time >= bins(i-1)
            bin_ind = i-1; break;
        end
    end
end
