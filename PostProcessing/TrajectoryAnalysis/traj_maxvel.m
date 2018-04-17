function [maxvel_hist,maxvel,maxvel_time] = traj_maxvel(stats,varargin)

%TRAJ_AVGVEL Summary of this function goes here
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
k=0;
for stlen=1:numel(stats.traj_struct)
    if (tstruct(stlen).rw == rw_only) || ~rw_only
        k = k+1;
        maxvel(k) = max(tstruct(stlen).vel_mag(50:end))*1000;
        maxvel_time(k) = tstruct(stlen).real_time;
    end
end
edges = 0:interv:300;
maxvel_hist = histc(maxvel,edges);

%normalize
maxvel_hist = maxvel_hist./sum(maxvel_hist);

%plot
if plotflag
    if length(ax)<1;
        figure;
        ax = gca();
    end
    axes(ax);
    hold on;
    stairs(edges,smooth(maxvel_hist,3),color);
    hold off;
end