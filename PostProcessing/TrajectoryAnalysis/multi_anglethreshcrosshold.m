function [console_output] = multi_anglethreshcrosshold(dirlist,varargin)

default = {30*(6.35/100),50*(6.35/100),300,0,0,1,[],1,0,0};
numvarargs = length(varargin);
if numvarargs > 11
    error('too many arguments (> 12), only 1 required and 11 optional.');
end
[default{1:numvarargs}] = varargin{:};
[thresh_in,thresh_out,hold_time,trajid,rw_only,interv,ax,plotflag,combineflag,lasercompareflag] = default{:};

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
    
    [statslist, dates] = load_stats(dirlist, combineflag, 1, 0,{'traj_struct'});
    statshit = get_stats_with_trajid(statslist,1);
    statscatch = get_stats_with_trajid(statslist,lasercompareflag);
    dates{2} = strcat(dates{1},'-nl');
    dates{1} = strcat(dates{1},'-l');
    
    statslist(1) = statshit;
    statslist(2) = statscatch;
else
    [statslist, dates] = load_stats(dirlist, combineflag, 1, 0,{'traj_struct'});
end

for i= 1:length(statslist)
    stats = get_stats_with_trajid(statslist(i),trajid);
    [~,theta{i}] = anglethreshcrosshold(stats,thresh_in,thresh_out,hold_time,0,rw_only,interv,ax,plotflag,colors(i));    
    console_output{i+1} = sprintf(strcat(dates{i},' Med: %d'),median([theta{i}]));
end

console_output{1} = 'Angle at Thresh after Hold';
if (lasercompareflag-1)
    [h,p] = kstest2([theta{1}],[theta{2}]);
    console_output{end+1} = sprintf('P value: %f',p);
end

if plotflag
    axes(ax);
    legend(dates);
end


