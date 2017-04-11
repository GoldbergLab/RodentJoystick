function [peakvel_hist,peakvel] = seg_dur(stats,varargin)

%SEG_PATHLEN Summary of this function goes here
%   Detailed explanation goes here

default = {0,0,1,[],1, 'r'};
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
            peakvel{i} = [tstruct(i).seginfo(1:end).dur];
        end
    end
end
peakvel = [peakvel{:}];
edges = 0:interv:300;
peakvel_hist = histc(peakvel,edges);

%normalize
peakvel_hist = peakvel_hist./sum(peakvel_hist);

%plot
if plotflag
    if length(ax)<1;
        figure;
        ax = gca();
    end
    axes(ax);
    hold on;
    stairs(edges,peakvel_hist,color);
    hold off;
end