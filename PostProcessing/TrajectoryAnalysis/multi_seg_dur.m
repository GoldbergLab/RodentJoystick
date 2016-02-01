function [console_output] = multi_seg_dur(dirlist,varargin)
%MULTI_SEG_PATHLEN Summary of this function goes here
%   Detailed explanation goes here

default = {0,0,1,[],1,0,0,0};
numvarargs = length(varargin);
if numvarargs > 8
    error('too many arguments (> 9), only 1 required and 8 optional.');
end
[default{1:numvarargs}] = varargin{:};
[trajid,rw_only,interv,ax,plotflag,combineflag,lasercompareflag,to_stop] = default{:};

if plotflag
    if numel(ax)<1
        figure;
        ax = gca;
    end
end

colors = 'rbkmcgyrbkmcgyrbkmcgy';

if (lasercompareflag-1)
    combineflag=1;
    trajid=0;
    
    [statslist, dates] = load_stats(dirlist, combineflag, to_stop,'traj_struct');
    statshit = get_stats_with_trajid(statslist,1);
    statscatch = get_stats_with_trajid(statslist,lasercompareflag);
    dates{2} = strcat(dates{1},'-nl');
    dates{1} = strcat(dates{1},'-l');
    
    statslist(1) = statshit;
    statslist(2) = statscatch;
else
    [statslist, dates] = load_stats(dirlist, combineflag,to_stop, 'traj_struct');
end

for i= 1:length(statslist)
    stats = get_stats_with_trajid(statslist(i),trajid);
    [~,duration{i}] = seg_dur(stats,0,rw_only,interv,ax,plotflag,colors(i));    
    console_output{i+1} = sprintf(strcat(dates{i},' Med: %d'),median([duration{i}]));
end

console_output{1} = 'Seg Duration';
if (lasercompareflag-1)
    [h,p] = kstest2([duration{1}],[duration{2}]);
    console_output{end+1} = sprintf('P value: %f',p);
end

if plotflag
    axes(ax);
    legend(dates);
end


