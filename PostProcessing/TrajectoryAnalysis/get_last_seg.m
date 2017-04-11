function stats_out = get_last_seg(stats)

tstruct = stats.traj_struct;

output = arrayfun(@(x) numel(x.seginfo)>0,tstruct);
tstruct = tstruct(output);

for i=1:numel(tstruct)
    tstruct(i).seginfo = tstruct(i).seginfo(end);
end

stats_out.traj_struct = tstruct;