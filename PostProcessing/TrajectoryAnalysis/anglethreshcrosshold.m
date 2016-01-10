function [theta_hist,theta] = anglethreshcrosshold(stats,varargin)
%% argument handling

default = {30*(6.35/100),50*(6.35/100),300,0,1,[],1, 'r'};
numvarargs = length(varargin);
if numvarargs > 8
    error('too many arguments (> 9), only 1 required and 8 optional.');
end
[default{1:numvarargs}] = varargin{:};
[thresh_in,thresh_out,hold_time,trajid,interv,ax,plotflag,color] = default{:};

stats=get_stats_with_trajid(stats,trajid);
tstruct = stats.traj_struct;

k=0;
for i=1:length(tstruct)
    index_in = find(tstruct(i).magtraj>thresh_in);
    thresh_in_cross = min(index_in);    
    if numel(thresh_in_cross)
        if thresh_in_cross>hold_time
            index_out = find(tstruct(i).magtraj>thresh_out);
            thresh_out_cross = min(index_out);
            if numel(thresh_out_cross)
                k=k+1;
                [theta(k),rho] = cart2pol(tstruct(i).traj_x(thresh_out_cross),tstruct(i).traj_y(thresh_out_cross));
            end
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
    plot(edges,theta_hist,color);
    hold off;
end