function [console_output] = multi_traj_numseg(dirlist,varargin)
%MULTI_TRAJ_ACCPEAKS Summary of this function goes here
%   Detailed explanation goes here

default = {0,1,[],1,0,0};
numvarargs = length(varargin);
if numvarargs > 6
    error('too many arguments (> 7), only 1 required and 6 optional.');
end
[default{1:numvarargs}] = varargin{:};
[trajid,interv,ax,plotflag,combineflag,lasercompareflag] = default{:};

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
    
    [statslist, dates] = load_stats(dirlist, combineflag, 'traj_struct');
    statshit = get_stats_with_trajid(statslist,1);
    statscatch = get_stats_with_trajid(statslist,lasercompareflag);
    dates{2} = strcat(dates{1},'-nl');
    dates{1} = strcat(dates{1},'-l');
    
    statslist(1) = statshit;
    statslist(2) = statscatch;
else
    [statslist, dates] = load_stats(dirlist, combineflag, 'traj_struct');
end

for i= 1:length(statslist)
    stats = get_stats_with_trajid(statslist(i),trajid);
    [~,numseg{i}] = traj_numseg(stats,0,interv,ax,plotflag,colors(i));    
    console_output{i+1} = sprintf(strcat(dates{i},' Med: %d'),median([numseg{i}]));
end

console_output{1} = 'Num Seg';
if (lasercompareflag-1)
    [h,p] = kstest2([numseg{1}],[numseg{2}]);
    console_output{end+1} = sprintf('P value: %f',p);
end

if plotflag
    axes(ax);
    legend(dates);
end


