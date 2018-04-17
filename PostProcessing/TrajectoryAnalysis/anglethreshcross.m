function [theta_hist,theta,theta_realtime,fig_handle] = anglethreshcross(stats,varargin)
%% argument handling

default = {30*(6.35/100),63*(6.35/100),0,0,10,[],0, 'b',1};
numvarargs = length(varargin);
if numvarargs > 9
    error('too many arguments (> 10), only 1 required and 9 optional.');
end
[default{1:numvarargs}] = varargin{:};
[hold_thresh,out_thresh,trajid,rw_only,interv,ax,plot_flag,color,smoothparam] = default{:};

stats=get_stats_with_trajid(stats,trajid);
theta=[];

k=0;   
  [theta,~,theta_realtime] = tau_theta(stats,hold_thresh*(6.35/100),out_thresh*(6.35/100),0,0,[],1);  
%     if (tstruct(i).rw == rw_only) || ~rw_only
%     index = find(tstruct(i).magtraj>thresh);
%     thresh_cross = min(index);
%     if numel(thresh_cross)
%         k=k+1;
%         [theta(k),rho] = cart2pol(tstruct(i).traj_x(thresh_cross),tstruct(i).traj_y(thresh_cross));
%         theta_realtime(k) = tstruct(i).real_time;
%     end
%     end

%theta = theta*(180/pi);

% theta(sign(theta)==-1) = 2*pi + theta(sign(theta)==-1);
edges = -180:interv:180;
theta_hist = histc(theta,edges);
theta_hist = theta_hist./(sum(theta_hist));

% f = fit(edges.',theta_hist.','gauss1');
% x_pl = dist_theta.*(cosd(0:10:360));
% y_pl = dist_theta.*(sind(0:10:360));
 
%plot

if plot_flag 
    if length(ax)<1;
        fig_handle = figure;
        ax = gca();
    end
    axes(ax);
    hold on
    stairs(edges,smooth(theta_hist,smoothparam),color);
    hold off
    fig_handle = gcf();
end
