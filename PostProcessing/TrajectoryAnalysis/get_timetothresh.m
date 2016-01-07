function [laser_dist,nonlaser_dist] = get_timetothresh(tstruct,thresh,plotflag)

laser_dist=[];
nonlaser_dist=[];

edges = 1:50:1500;

for i=1:length(tstruct)
    
    index = find(tstruct(i).magtraj>thresh);
    thresh_cross = min(index);
    
    if tstruct(i).laser == 1    
        laser_dist = [laser_dist thresh_cross];
    else
        nonlaser_dist = [nonlaser_dist thresh_cross];
    end
end



if plotflag
    figure;
    l = histc(laser_dist,edges)./(numel(laser_dist));
    nl = histc(nonlaser_dist,edges)./(numel(nonlaser_dist));
    stairs(edges,l,'r');
    hold on;
    stairs(edges,nl,'b');
end