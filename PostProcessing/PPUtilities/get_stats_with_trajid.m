%Takes a statslist and returns a new stats with some subset based on laser
%inhibition
function stats = get_stats_with_trajid(stats,traj_id, varargin)
if traj_id
  for stat_index=1:length(stats)
     tstruct = stats(stat_index).traj_struct;
     output = arrayfun(@(y) ~isempty(find(y.laser == 1)), tstruct);
     if traj_id >= 2 %get hit trajectories instead, so negate
        output = ~output;
     end
     if traj_id == 3 %resample trajectories
         lasercount = length(tstruct) - sum(output); %find out how many were hit by laser
         indices = 1:length(tstruct);
         catchindices = indices(output); %indices of trajectories not hit
         permuteind = randperm(length(catchindices)); %permutation of unhit traj
         permuteind = permuteind(1:lasercount); %truncate to minimum
         sort(permuteind);
         output = catchindices(permuteind); %still chronological order, but
            %will be resampled each time
     end
     tstruct = tstruct(output);
     stats(stat_index).traj_struct=tstruct;
 end   
end

 % do nothing, all trajectories go into computation
end
