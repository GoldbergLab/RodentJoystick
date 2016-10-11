function [theta,tau,ax] = tau_theta(stats,varargin)
%% argument handling

default = {30*(6.35/100),60*(6.35/100),0,0,[],1, 'b'};
numvarargs = length(varargin);
if numvarargs > 7
    error('too many arguments (> 8), only 1 required and 7 optional.');
end
[default{1:numvarargs}] = varargin{:};
[thresh1,thresh2,trajid,rw_only,ax,plot_flag,color] = default{:};

stats=get_stats_with_trajid(stats,trajid);
stats=get_stats_with_len(stats,50);
tstruct = stats.traj_struct;
theta=[];

k=0;
for i=1:length(tstruct)
    if (tstruct(i).rw == rw_only) || ~rw_only
    index = find(tstruct(i).magtraj>thresh1);
    index2 = find(tstruct(i).magtraj>thresh2);
    thresh_cross = min(index);
    thresh_cross2 = min(index2);
    if numel(thresh_cross) && numel(thresh_cross2)
        k=k+1;
        [theta(k),rho] = cart2pol(tstruct(i).traj_x(thresh_cross2),tstruct(i).traj_y(thresh_cross2));
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
    scatter(tau,theta,3,color,'fill');
    axis([0 1000 -180 180]);
    hold off
end
