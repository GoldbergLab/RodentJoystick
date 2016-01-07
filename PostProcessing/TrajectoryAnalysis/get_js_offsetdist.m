function [laser_dist,nonlaser_dist] = get_js_offsetdist(tstruct,plotflag)

laser_dist=[];
nonlaser_dist=[];

edges = 1:20:3000;

for i=1:length(tstruct)
    
    if tstruct(i).laser == 1
        laser_dist = [laser_dist tstruct(i).js_offset - tstruct(i).js_onset];
    else
        nonlaser_dist = [nonlaser_dist tstruct(i).js_offset - tstruct(i).js_onset];
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