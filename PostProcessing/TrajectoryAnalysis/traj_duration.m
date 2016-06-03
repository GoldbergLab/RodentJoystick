function [dur_hist,duration] = traj_duration(stats,varargin)

%TRAJ_DURATION Summary of this function goes here
%   Detailed explanation goes here

default = {0,0,5,[],1, 'r'};
numvarargs = length(varargin);
if numvarargs > 6
    error('too many arguments (> 7), only 1 required and 6 optional.');
end
[default{1:numvarargs}] = varargin{:};
[trajid,rw_only,interv,ax,plotflag,color] = default{:};

stats=get_stats_with_trajid(stats,trajid);
stats=get_stats_with_len(stats,50);

tstruct = stats.traj_struct;
k=0;
for stlen = 1:numel(stats.traj_struct)
    if (tstruct(stlen).rw == rw_only) || ~rw_only        
        k=k+1;
        duration(k) = tstruct(stlen).duration;
    end
end
edges = 0:interv:1000;
dur_hist = histc(duration,edges);

%normalize
dur_hist = dur_hist./sum(dur_hist);

%plot
if plotflag
    if length(ax)<1;
        figure;
        ax = gca();
    end
    axes(ax);
    hold on;
    stairs(edges,dur_hist,color);
    hold off;
end