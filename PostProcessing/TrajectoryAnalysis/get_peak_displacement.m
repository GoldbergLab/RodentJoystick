function [peak_displacment] = get_peak_displacement(stats,color)

tstruct = stats.traj_struct;
for i=1:numel(tstruct)
    maxdist(i) = max(tstruct(i).magtraj);
end    

edges = 0:0.05:6.5;
maxdist_dist = histc(maxdist,edges);


%figure;
stairs(edges,maxdist_dist/sum(maxdist_dist),color);
