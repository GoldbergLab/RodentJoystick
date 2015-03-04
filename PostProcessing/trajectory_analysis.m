function [sortedtraj ] = trajectory_analysis(stats, bin_length)
%trajectory_analysis(stats, bin_length)
%   ARGUMENTS:

%place into bins (groups), mini structures
%iterate over bin ->
    %normalize (all on 100 ms time scale)-> mean, median, std above, below
    %for each data point
    % don't normalize (all on 100ms time scale) -> (4 above)
% should be able to plot?
TIME_RANGE = 2000;
bins=0:bin_length:TIME_RANGE;
% will be a vector of structs containing fields for the range
% each struct has a field for a vector of structs containing
% trajectories
tstruct=stats.traj_struct; 
holdtimes = hold_time_distr(tstruct, bin_length, 'data');
for i = 2:length(bins)
   sortedtraj(i-1) = struct('geq', bins(i-1),'lt',bins(i));
end

bin_traj_indices = ones(length(bins)-1, 1); 
%each bin has a vector of trajectory structures (simplified)
% store the indices so we know at what index to add each new trajectory
for i = 1:length(holdtimes)
    bin_ind = bin_index(bins, holdtimes(i));
    traj_ind = bin_traj_indices(bin_ind);
    bin_traj_indices(bin_ind) = bin_traj_indices(bin_ind) + 1;
    sortedtraj(bin_ind).trajectory(traj_ind)= struct('magtraj', tstruct(i).magtraj, 'time', holdtimes(i));
end

end
% Bin indexing starts with 1 at the first nonzero element. Ie, If the bins
% are distributed as bins = [0 10 20 30 40],
%       bin_index(bins, 5) = 1, bin_index(bins 0) = 1
%       bin_index(bins, 9) = 1, bin_index(bins 10) = 2

function bin_ind = bin_index(bins, time)
    for i = 2:length(bins)
        if time < bins(i)
            bin_ind = i-1; break;
        end
    end
end