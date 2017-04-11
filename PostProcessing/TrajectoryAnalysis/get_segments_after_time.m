function stats = get_segments_after_time(stats,time_l)

tstruct = stats.traj_struct;
for i=1:numel(tstruct)
    if numel(tstruct(i).seginfo)
     ind_vect = (tstruct(i).redir_pts(1:(end-1))>time_l);
     tstruct(i).seginfo = tstruct(i).seginfo(ind_vect);
    end
end

stats.traj_struct = tstruct;