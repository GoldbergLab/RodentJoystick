function stats = get_stats_with_reach(stats,thresh_out)

tstruct = stats.traj_struct;
output = arrayfun(@(y) (sum(y.magtraj>thresh_out)>0), tstruct);

stats.traj_struct = tstruct(output);