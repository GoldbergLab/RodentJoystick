function [dur_hist,duration] = traj_duration(stats,varargin)

%TRAJ_DURATION Summary of this function goes here
%   Detailed explanation goes here

default = {0,10,[],1, 'r'};
numvarargs = length(varargin);
if numvarargs > 5
    error('too many arguments (> 6), only 1 required and 5 optional.');
end
[default{1:numvarargs}] = varargin{:};
[trajid,interv,ax,plotflag,color] = default{:};

stats=get_stats_with_trajid(stats,trajid);

tstruct = stats.traj_struct;
for i=1:numel(stats.traj_struct)
    duration(i) = tstruct(i).duration;
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