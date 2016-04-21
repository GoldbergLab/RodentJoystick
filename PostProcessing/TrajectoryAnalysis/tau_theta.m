function [theta,tau,fig_handle] = tau_theta(stats,varargin)
%% argument handling

default = {30*(6.35/100),0,0,[],1, 'b'};
numvarargs = length(varargin);
if numvarargs > 6
    error('too many arguments (> 7), only 1 required and 6 optional.');
end
[default{1:numvarargs}] = varargin{:};
[thresh,trajid,rw_only,ax,plot_flag,color] = default{:};

stats=get_stats_with_trajid(stats,trajid);
tstruct = stats.traj_struct;
theta=[];

k=0;
for i=1:length(tstruct)
    if (tstruct(i).rw == rw_only) || ~rw_only
    index = find(tstruct(i).magtraj>thresh);
    thresh_cross = min(index);
    if numel(thresh_cross) && thresh_cross>50
        k=k+1;
        [theta(k),rho] = cart2pol(tstruct(i).traj_x(thresh_cross),tstruct(i).traj_y(thresh_cross));
        tau(k) = thresh_cross;
    end
    end
end

theta = theta*(180/pi);

% theta(sign(theta)==-1) = 2*pi + theta(sign(theta)==-1);
 
%plot

if plot_flag 
    if length(ax)<1;
        fig_handle = figure;
        ax = gca();
    end
    axes(ax);
    hold on
    scatter(theta,tau,3,color,'fill');
    axis([-180 180 0 1000]);
    hold off
end
