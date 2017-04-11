function [segonset_hist,onset_time] = seg_onset(stats,varargin)

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

for i=1:numel(tstruct)
   if (tstruct(i).rw == rw_only) || ~rw_only
       if numel(tstruct(i).seginfo)
           onset_time(i) = tstruct(i).reach_seg.onset;
       else
           onset_time(i) = NaN;
       end       
   end
end

onset_time = onset_time(~isnan(onset_time));

edges = 0:interv:500;
segonset_hist = histc(onset_time,edges);

%normalize
segonset_hist = segonset_hist./sum(segonset_hist);

%plot
if plotflag
    if length(ax)<1;
        figure;
        ax = gca();
    end
    axes(ax);
    hold on;
    stairs(edges,segonset_hist,color);
    hold off;
end