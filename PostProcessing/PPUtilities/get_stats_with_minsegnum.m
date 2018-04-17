function [stats] = get_stats_with_minsegnum(stats,num_seg)

tstruct = stats.traj_struct;

output = arrayfun(@(x) numel(x.seginfo)>=num_seg,tstruct);
tstruct = tstruct(output);

stats.traj_struct = tstruct;