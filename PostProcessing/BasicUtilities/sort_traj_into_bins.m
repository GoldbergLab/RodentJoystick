% will be a vector of structs containing fields for the range
% each struct has a field for a vector of structs containing
% trajectories
% sortedtraj is a struct with the following fields:
%   sortedtraj(i) contains all trajectories with holdtimes in the range
%   [sortedtraj(i).geq, sortedtraj(i).lt)
%   there is also a field trajectory, which is another struct containing
%       multiple trajectories' information - can be velocity, acceleration,
%       pos.
function sortedtraj = sort_traj_into_bins(tstruct, derivflag, bins)
derivflag = min(max(derivflag, 0), 3);
disp(derivflag);
for i = 2:length(bins)
   sortedtraj(i-1) = struct('geq', bins(i-1),'lt',bins(i));
end
bin_traj_indices = ones(length(bins)-1, 1); 
%each bin has a vector of trajectory structures (simplified from tstruct)
% store the indices so we know at what index to add each new trajectory
for i = 1:length(tstruct)
    %This is where our definition of hold time comes into effect:
    bin_ind = bin_index(bins,tstruct(i).rw_or_stop);
    if bin_ind ~= -1
        traj_ind = bin_traj_indices(bin_ind);
        bin_traj_indices(bin_ind) = bin_traj_indices(bin_ind) + 1;
        data = tstruct(i).magtraj(1:tstruct(i).rw_or_stop);
        derivative = derivflag;
        while derivative
            data = diff(data);
            derivative = derivative - 1;
        end
        sortedtraj(bin_ind).trajectory(traj_ind)= struct('magtraj', data, 'time', tstruct(i).rw_or_stop);
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
