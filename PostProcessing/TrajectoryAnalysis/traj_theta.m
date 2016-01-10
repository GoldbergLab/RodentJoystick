function [numseg_hist,numseg] = traj_numseg(stats,varargin)

%TRAJ_AVGVEL Summary of this function goes here
%   Detailed explanation goes here

default = {0,1,[],1, 'r'};
numvarargs = length(varargin);
if numvarargs > 5
    error('too many arguments (> 6), only 1 required and 5 optional.');
end
[default{1:numvarargs}] = varargin{:};
[trajid,interv,ax,plotflag,color] = default{:};

stats=get_stats_with_trajid(stats,trajid);

tstruct = stats.traj_struct;
k=0;
for i=1:numel(stats.traj_struct)
    if numel(tstruct(i).accpeaks)
        k=k+1;
        numseg(k) = numel(tstruct(i).seginfo);
    else
        continue; 
    end
end
edges = 1:interv:60;
numseg_hist = histc(numseg,edges);

%normalize
numseg_hist = numseg_hist./sum(numseg_hist);

%plot
if plotflag
    if length(ax)<1;
        figure;
        ax = gca();
    end
    axes(ax);
    hold on;
    stairs(edges,numseg_hist,color);
    hold off;
end