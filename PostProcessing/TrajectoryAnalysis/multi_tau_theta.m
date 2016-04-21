function [console_output,fig_handle] = multi_tau_theta(dirlist,varargin)

default = {30*(6.35/100),0,0,[],1,0,0};
numvarargs = length(varargin);
if numvarargs > 9
    error('too many arguments (> 10), only 1 required and 9 optional.');
end
[default{1:numvarargs}] = varargin{:};
[thresh,trajid,rw_only,ax,plotflag,combineflag,lasercompareflag] = default{:};
fig_handle= [];

if plotflag
    if numel(ax)<1
        fig_handle = figure;
        ax = gca;
    end
end

colors = 'brkmcgyrbkmcgyrbkmcgy';

if (lasercompareflag - 1)>0
    combineflag=1;
    trajid=0;
    
    [statslist, dates] = load_stats(dirlist, combineflag,0, 'traj_struct');
    statshit = get_stats_with_trajid(statslist,1);
    statscatch = get_stats_with_trajid(statslist,lasercompareflag);
    
    dates{2} = strcat(dates{1},'-l');
    dates{1} = strcat(dates{1},'-nl');
    
    statslist(2) = statshit;
    statslist(1) = statscatch;
else
    [statslist, dates] = load_stats(dirlist, combineflag,0, 'traj_struct');
end

for i= 1:length(statslist)
    stats = get_stats_with_trajid(statslist(i),trajid);
    tau_theta(stats,thresh,0,rw_only,ax,plotflag,colors(i));
end

console_output{1} = 'Angle at Thresh vs Time at exit';

if plotflag
    axes(ax);
    legend(dates);
    title(strcat('Angle at threshold Crossing vs Time at exit:',num2str(thresh)));
end


