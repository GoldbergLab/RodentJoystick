%Takes a statslist and returns a new stats 
function stats = get_stats_with_trajid(stats,traj_id, varargin)
default = {0};
numvarargs = length(varargin);
if numvarargs > 1
    error('too many arguments (> 1), only two required and 1 optional.');
end
[default{1:numvarargs}] = varargin{:};
[resampleflag] = default{:};

if (traj_id == 1)
 for stat_index=1:length(stats)
     tstruct = stats(stat_index).traj_struct;
     output = arrayfun(@(y) ~isempty(find(y.laser == 1)), tstruct);
     tstruct = tstruct(output);
     stats(stat_index).traj_struct=tstruct;
 end
elseif (traj_id==2)
 for stat_index=1:length(stats)
     tstruct = stats(stat_index).traj_struct;
     output = arrayfun(@(y) ~isempty(find(y.laser == 0)), tstruct);
     if resampleflag
         lasercount = length(tstruct) - sum(output); %find out how many were hit by laser
         indices = 1:length(tstruct);
         catchindices = indices(output);
         permuteind = randperm(length(indices));
         permuteind = permuteind(1:lasercount);
         sort(permuteind);
         output = catchindices(permuteind); %still chronological order, but
            %will be resampled each time
     end
     tstruct = tstruct(output);
     stats(stat_index).traj_struct=tstruct;
 end
elseif (traj_id == 3)
    %return cell array with first stats struct all laser trajectories
    % and second all "escape" trajectories
    finalstats{1} = get_stats_with_trajid(stats, 1);
    finalstats{2} = get_stats_with_trajid(stats, 2);
    stats = finalstats;
elseif (traj_id == 4)
    finalstats{1} = get_stats_with_trajid(stats, 1);
    finalstats{2} = get_stats_with_trajid(stats, 2, 1);
    stats = finalstats;
else

 % do nothing, all trajectories go into computation
end
