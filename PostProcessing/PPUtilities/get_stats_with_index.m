function stats = get_stats_with_index(stats,id_list)

tstruct = stats.traj_struct;
stlen = numel(tstruct);

indexlist = arrayfun( @(x) sum(x.js_trialnum == id_list)>0, tstruct);
tstruct_new = tstruct(indexlist);
stats.traj_struct = tstruct_new;