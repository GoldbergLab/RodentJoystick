% [stats] = get_stats_with_trajid(stats,trajid, varargin)
%   
%   get_stats_with_trajid modifies the stats structures trajectories based
%   on trajid. Filters trajectories depending on whether they were laser
%   trajectories or not.
%
% ARGS : 
%   
%   stats :: standard stats structure
%   
%   trajid :: an id in [0, 3] indicating which set of trajectories to leave
%       included
%       0 : unchanged
%       1 : laser only
%       2 : catch only
%       3 : catch only (resampled, only as many trajectories as lasers)
%
% OUTPUTS :
%
%   stats :: a standard stats structure with field traj_struct modified to
%       satisfy above condition (described by trajid)
%
function stats = get_stats_with_trajid(stats,traj_id, varargin)
if traj_id
  for stat_index=1:length(stats)
     tstruct = stats(stat_index).traj_struct;
     
     output = arrayfun(@(y) ~isempty(find(y.laser == 1)), tstruct);
     if traj_id >= 2 %get hit trajectories instead, so negate to get catch
        output = ~output;
     end
     if traj_id == 3 %resample trajectories
         lasercount = length(tstruct) - sum(output); %find out how many were hit by laser
         indices = 1:length(tstruct);
         catchindices = indices(output); %indices of trajectories not hit
         permuteind = randperm(length(catchindices)); %permutation of unhit traj
         catchcount = min(lasercount,length(catchindices));
         permuteind = permuteind(1:catchcount); %truncate to minimum
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
