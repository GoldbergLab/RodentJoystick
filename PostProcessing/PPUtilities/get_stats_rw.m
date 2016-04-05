function stats = get_stats_rw(stats,rw)

tstruct = stats.traj_struct;
output = arrayfun(@(y) (y.rw == rw), tstruct);

stats.traj_struct = tstruct(output);
