function [theta_hist,theta] = anglethreshcross(stats,varargin)
%% argument handling

default = {30*(6.35/100),0,0,1,[],1, 'r'};
numvarargs = length(varargin);
if numvarargs > 7
    error('too many arguments (> 8), only 1 required and 7 optional.');
end
[default{1:numvarargs}] = varargin{:};
[thresh,trajid,rw_only,interv,ax,plotflag,color] = default{:};

stats=get_stats_with_trajid(stats,trajid);
tstruct = stats.traj_struct;
theta=[];

k=0;
for i=1:length(tstruct)
    if (tstruct(i).rw == rw_only) || ~rw_only
    index = find(tstruct(i).magtraj>thresh);
    thresh_cross = min(index);
    if numel(thresh_cross)
        k=k+1;
        [theta(k),rho] = cart2pol(tstruct(i).traj_x(thresh_cross),tstruct(i).traj_y(thresh_cross));
    end
    end
end

theta = theta*(180/pi);

% theta(sign(theta)==-1) = 2*pi + theta(sign(theta)==-1);
edges = -180:interv:180;
theta_hist = histc(theta,edges);
theta_hist = theta_hist./(sum(theta_hist));

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
    stairs(edges,theta_hist,color);
    hold off;
end