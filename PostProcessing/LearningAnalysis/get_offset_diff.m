function  [durdiff]= get_offset_diff(stats)

tstruct = stats.traj_struct;
k=0;
for stlen=1:length(tstruct)
    
if tstruct(stlen).rw==1
    k=k+1;
    durdiff(k) = tstruct(stlen).stop_p - tstruct(stlen).trial_end;
end
end
edges = 0:50:1200;
durdiff = durdiff(durdiff>0);
figure;
dist = histc(durdiff,edges);
stairs(edges,dist);