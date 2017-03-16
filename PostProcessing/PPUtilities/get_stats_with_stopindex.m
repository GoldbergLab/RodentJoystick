function stats_out = get_stats_with_stopindex(stats,ind)

stats_out = stats;
tstruct= stats.traj_struct;
output = arrayfun(@(x) x.stop_index==ind,tstruct);
tstruct_out = tstruct(output);
stats_out.traj_struct = tstruct_out;