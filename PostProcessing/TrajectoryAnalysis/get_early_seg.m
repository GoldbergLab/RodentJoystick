function stats_out = get_early_seg(stats,num_end)

tstruct = stats.traj_struct;

output = arrayfun(@(x) numel(x.seginfo)>0,tstruct);
tstruct = tstruct(output);

for i=1:numel(tstruct)
    tstruct(i).seginfo = tstruct(i).seginfo(1:(end-num_end));
end

stats_out.traj_struct = tstruct;