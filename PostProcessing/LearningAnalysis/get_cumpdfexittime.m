function [tau,tau_f,fig_handle,tau_cdist_out] = get_cumpdfexittime(stats,varargin)

default= {60,60,0,[],1};

numvarargs = length(varargin);
if numvarargs > 5
    error('too many arguments (> 6), only 1 required and 5 optional.');
end
[default{1:numvarargs}] = varargin{:};

[dist1,dist2,pdfSwitch,fig_handle,start_at] = default{:};

stats = get_stats_with_len(stats,50);
% stats = get_stats_with_stopindex(stats,1);

stats_l = get_stats_with_trajid(stats,1);
stats_nl = get_stats_with_trajid(stats,2);

% stats_reach_l = get_stats_with_reach(stats_l,dist2*(6.35/100));
% stats_reach_nl = get_stats_with_reach(stats_nl,dist2*(6.35/100));

if pdfSwitch
    edges = 0:10:1000;
    ylimmax = 0.1;
else
    edges = 0:1:1000;
    ylimmax = 1;
end

tau_f.l = 0;tau_f.nl = 0;
tau.tau_l = [];tau.tau_nl = [];
tau_cdist_out.l =[];tau_cdist_out.nl =[];

if numel(stats_nl.traj_struct)>0
    [~,tau_nl,~,ax] = tau_theta(stats_nl,dist1*(6.35/100),dist2*(6.35/100),0,0,[],0, 'b',start_at);
    tau_dist = histc(tau_nl,edges);
    tau_dist = tau_dist/(numel(stats_nl.traj_struct));
    if pdfSwitch
        tau_cumdist = tau_dist;
    else
        tau_cumdist = cumsum(tau_dist);
    end
    if isempty(fig_handle)
        h = figure;
        fig_handle = h;
    else
        h = fig_handle;
    end
    figure(h);
    hold on
    stairs(edges,tau_cumdist,'b');
    ylim([0 ylimmax]);
    xlabel('Time (ms)');
    ylabel('Probability of Reaching Threshold');
    tau_f.nl = max(tau_cumdist);
    tau.tau_nl = tau_nl;
    tau_cdist_out.nl = tau_cumdist;
else
    if isempty(fig_handle)
        h = figure;
        fig_handle = h;
    else
        h = fig_handle;
    end
end


if numel(stats_l.traj_struct)>0
    [~,tau_l,~,ax] = tau_theta(stats_l,dist1*(6.35/100),dist2*(6.35/100),0,0,[],0, 'r',start_at);
    tau_dist = histc(tau_l,edges);
    tau_dist = tau_dist/(numel(stats_l.traj_struct));
    if pdfSwitch
        tau_cumdist = tau_dist;
    else
        tau_cumdist = cumsum(tau_dist);
    end
    figure(h)
    hold on
    stairs(edges,tau_cumdist,'r');
    hold off;
    ylim([0 ylimmax]);
    xlabel('Time (ms)');
    ylabel('Probability of Reaching Threshold');
    tau_f.l = max(tau_cumdist);
    tau.tau_l = tau_l;
    tau_cdist_out.l = tau_cumdist;
end


