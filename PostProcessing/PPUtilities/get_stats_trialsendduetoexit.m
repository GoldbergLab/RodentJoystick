function stats = get_stats_trialsendduetoexit(stats)
k=0;
tstruct = stats.traj_struct;
for stlen = 1:length(tstruct)   
    
    trial_len = (tstruct(stlen).trial_end);
    js_offset = tstruct(stlen).js_offset;
    post_offset = tstruct(stlen).post_offset;
    np_end = tstruct(stlen).np_end;
    
    a = (trial_len == [js_offset post_offset np_end]);
    if sum(a) == 0
        k=k+1;
        tstruct_new(k)=tstruct(stlen);
    end  
end

stats.traj_struct = tstruct_new;