function [stats] = get_stats_with_segnum(stats,num_seg)

tstruct = stats.traj_struct;

output = arrayfun(@(x) numel(x.seginfo)>=num_seg,tstruct);
tstruct = tstruct(output);

for i=1:numel(tstruct)
        tstruct(i).seginfo = tstruct(i).seginfo(num_seg);
end

stats.traj_struct = tstruct;