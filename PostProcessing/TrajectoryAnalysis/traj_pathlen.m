function [path_hist,pathlen] = traj_pathlen(stats,varargin)

%TRAJ_PATHLEN Summary of this function goes here
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
for i=1:numel(stats.traj_struct)
    pathlen(i) = tstruct(i).pathlen;
end
edges = 0:interv:40;
path_hist = histc(pathlen,edges);

%normalize
path_hist = path_hist./sum(path_hist);

%plot
if plotflag
    if length(ax)<1;
        figure;
        ax = gca();
    end
    axes(ax);
    hold on;
    stairs(edges,path_hist,color);
    hold off;
end