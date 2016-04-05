function  [durdiff]= get_offset_diff(stats)

tstruct = stats.traj_struct;
k=0;
for stlen=1:length(tstruct)
    
if tstruct(stlen).rw==0
    k=k+1;
    durdiff(k) = tstruct(stlen).js_offset -  (tstruct(stlen).stop_p-tstruct(stlen).trial_end);
end
end
edges = 0:50:3000;
durdiff = durdiff(abs(durdiff)>2);
hold on
dist = histc(durdiff,edges);
dist = dist/sum(dist);
stairs(edges,dist);
hold off