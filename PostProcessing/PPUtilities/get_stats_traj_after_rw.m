function stats = get_stats_traj_after_rw(stats,rw)

tstruct = stats.traj_struct;
output = arrayfun(@(y) (y.rw == rw), tstruct);

output = [0 output(1:end-1)];
stats.traj_struct = tstruct((output>0));