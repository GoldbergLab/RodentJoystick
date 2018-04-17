function stats_out = get_stats_with_hold(stats,hold_dist,min_time)

stats_out = stats;
tstruct= stats.traj_struct;
output = arrayfun(@(x) min(find((x.magtraj)>(hold_dist*(6.35/100))))>min_time,tstruct,'UniformOutput',false);

t_output = zeros(1,numel(output))>0;
for i=1:length(output)
    if numel(output{i})>0
        t_output(i) = output{i}>0;
    end
end
    
tstruct_out = tstruct(t_output);
stats_out.traj_struct = tstruct_out;