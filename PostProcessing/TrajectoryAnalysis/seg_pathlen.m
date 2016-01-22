function [path_hist,pathlen] = seg_pathlen(stats,varargin)

%SEG_PATHLEN Summary of this function goes here
%   Detailed explanation goes here

default = {0,0,0.01,[],1, 'r'};
numvarargs = length(varargin);
if numvarargs > 6
    error('too many arguments (> 7), only 1 required and 6 optional.');
end
[default{1:numvarargs}] = varargin{:};
[trajid,rw_only,interv,ax,plotflag,color] = default{:};

stats=get_stats_with_trajid(stats,trajid);

tstruct = stats.traj_struct;

for i=1:numel(stats.traj_struct)
    if (tstruct(i).rw == rw_only) || ~rw_only
        if numel(tstruct(i).seginfo)
            pathlen{i} = [tstruct(i).seginfo(1:end).pathlen];
        end
    end
end
pathlen = [pathlen{:}];
edges = 0:interv:1;
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