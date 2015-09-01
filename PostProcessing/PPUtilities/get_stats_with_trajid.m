function stats = get_stats_with_trajid(stats,traj_id)

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
     tstruct = tstruct(output);
     stats(stat_index).traj_struct=tstruct;
 end
else 
 % do nothing, all trajectories go into computation
end
