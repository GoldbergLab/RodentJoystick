function stats = get_stats_rw(stats,rw)

tstruct = stats.traj_struct;
output = arrayfun(@(y) (y.magtraj(1) < 30*(6.35/100)), tstruct);

stats.traj_struct = tstruct(output);