function [pos_cross_hist,pos_cross,real_time] = posthreshcross(stats,varargin)
%% argument handling

default = {30*(6.35/100),0,0,1,[],1, 'r'};
numvarargs = length(varargin);
if numvarargs > 7
    error('too many arguments (> 8), only 1 required and 7 optional.');
end
[default{1:numvarargs}] = varargin{:};
[thresh,trajid,rw_only,interv,ax,plotflag,color] = default{:};

stats = get_stats_with_len(stats,50);
tstruct = stats.traj_struct;
pos_cross=[];

k=0;
for i=1:length(tstruct)
    if (tstruct(i).rw == rw_only) || ~rw_only
    index = find(tstruct(i).magtraj>thresh);
    thresh_cross = min(index);
    if numel(thresh_cross)
            k=k+1;
            pos_cross(k) = thresh_cross;
        try
            real_time(k) = tstruct(i).real_time;
        catch
            real_time(k) = 0;
        end
    end
    end
end

% theta(sign(theta)==-1) = 2*pi + theta(sign(theta)==-1);
edges = 0:20:1000;
pos_cross_hist = histc(pos_cross,edges);
pos_cross_hist = pos_cross_hist./(sum(pos_cross_hist));

% x_pl = dist_theta.*(cosd(0:10:360));
% y_pl = dist_theta.*(sind(0:10:360));
 
%plot
if plotflag
    if length(ax)<1;
        figure;
        ax = gca();
    end
    axes(ax);
    hold on;
    stairs(edges,pos_cross_hist,color);
    hold off;
end