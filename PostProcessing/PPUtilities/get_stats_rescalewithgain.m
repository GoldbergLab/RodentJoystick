function stats = get_stats_rescalewithgain(stats,gain)

stats = get_stats_with_len(stats,50);

tstruct = stats.traj_struct;
output = arrayfun(@(y) ~isempty(find(y.laser == 1)), tstruct);

temp = tstruct(output);
scaled_stat = arrayfun(@(y) y.magtraj*gain, temp,'UniformOutput',false);

ind_list  = find(output);
for i=1:numel(ind_list)
tstruct(ind_list(i)).magtraj = scaled_stat{i};
end

stats.traj_struct=tstruct;
end