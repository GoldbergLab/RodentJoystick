function stats = get_stats_tillthresh(stats,thresh_out)

tstruct = stats.traj_struct;
output = arrayfun(@(y) find(y.magtraj>thresh_out,1,'first'), tstruct,'UniformOutput',false);

vect_keep = zeros(numel(tstruct),1);

for i=1:numel(output)
    if numel(output{i})
        ind = output{i};
        tstruct(i).vel_x = tstruct(i).vel_x(1:ind);
        tstruct(i).vel_y = tstruct(i).vel_y(1:ind);     
        vect_keep(i) = 1;
    end
end

stats.traj_struct = tstruct(vect_keep>0);