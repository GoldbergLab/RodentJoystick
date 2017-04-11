function stats_out = get_reach_seg(stats,thresh)

stats = get_stats_with_reach(stats,thresh);
tstruct = stats.traj_struct;

output = arrayfun(@(x) numel(x.seginfo)>0,tstruct);
tstruct = tstruct(output);

for i=1:numel(tstruct)
    try
        ind = find(tstruct(i).magtraj>thresh);
        ind = find(tstruct(i).redir_pts>ind(1));
        if numel(ind)
            ind = min(ind(1),numel(tstruct(i).seginfo));
            tstruct(i).seginfo = tstruct(i).seginfo(ind);
            tstruct(i).reach_seg.index = ind;
            if(ind>1)
                dur_onset = ind-1;
            else
                dur_onset = 1;
            end
            tstruct(i).reach_seg.onset = tstruct(i).redir_pts(dur_onset);
        else
            tstruct(i).seginfo =[];
        end
    catch e
        flag=0;
    end
end

stats_out.traj_struct = tstruct;