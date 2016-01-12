function [avgvel_hist,avgvel] = seg_avgvel(stats,varargin)

%SEG_PATHLEN Summary of this function goes here
%   Detailed explanation goes here

default = {0,0.01,[],1, 'r'};
numvarargs = length(varargin);
if numvarargs > 5
    error('too many arguments (> 6), only 1 required and 5 optional.');
end
[default{1:numvarargs}] = varargin{:};
[trajid,interv,ax,plotflag,color] = default{:};

stats=get_stats_with_trajid(stats,trajid);

tstruct = stats.traj_struct;

for i=1:numel(stats.traj_struct)
    for j=1:numel(tstruct(i).seginfo)
        if (j>1)
         avgvel{i} = [avgvel{i} mean(tstruct(i).seginfo(j).velprofile)];
        else
         avgvel{i} = mean(tstruct(i).seginfo(j).velprofile);
        end
    end
end
avgvel = [avgvel{:}];
edges = 0:interv:.01;
avgvel_hist = histc(avgvel,edges);

%normalize
avgvel_hist = avgvel_hist./sum(avgvel_hist);

%plot
if plotflag
    if length(ax)<1;
        figure;
        ax = gca();
    end
    axes(ax);
    hold on;
    stairs(edges,avgvel_hist,color);
    hold off;
end