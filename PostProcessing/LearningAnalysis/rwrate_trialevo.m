function [theta_all_l,theta_all_nl,h] = rwrate_trialevo(dirlist,varargin)

default = {45,1};
numvarargs = length(varargin);
if numvarargs > 2
    error('too many arguments (> 3), only 1 required and 2 optional.');
end
[default{1:numvarargs}] = varargin{:};
[dist,save_flag] = default{:};
rw_l = [];
rw_nl = [];
theta_all_l = [];
theta_all_nl = [];
edges = -180:5:180;
windowSize = 100;

try
for i = 1:length(dirlist)
%   i
    [pathstr,name,ext] = fileparts(dirlist(i).name);
    [pathstr_rule,name,ext] = fileparts(dirlist(i).name);
    
    contingency_angle = strsplit(pathstr_rule,'_');

    out_thresh = str2num(contingency_angle{end-5});
    hold_time(i) = str2num(contingency_angle{end-4});
    hold_thresh(i) = str2num(contingency_angle{end-3});
    angle1(i) = str2num(contingency_angle{end-2});
    angle2(i) = str2num(contingency_angle{end-1});

    stats = load_stats(dirlist(i),0,1);
    stats = get_stats_with_len(stats,50);
    stats = get_stats_with_reach(stats,out_thresh*(6.35/100));
    stats_l = get_stats_with_trajid(stats,1);
    stats_nl = get_stats_with_trajid(stats,2);
    try
        rw_l_t = [stats_l.traj_struct.rw];
        rw_nl_t = [stats_nl.traj_struct.rw];
    catch
    end
   

    
    rw_l = [rw_l rw_l_t];
    rw_nl = [rw_nl rw_nl_t];
    angle_index_nl(i) = numel(rw_nl);
    angle_index_l(i) = numel(rw_l);

end
catch
    display(dirlist(i).name);
end
ratio = (angle_index_nl(end)/angle_index_l(end));
angle_index_nl(end) = angle_index_nl(end)-windowSize*ratio;
angle_index_l(end) = angle_index_l(end)-windowSize;


a = 1;
b = ones(windowSize,1)/windowSize;

rw_l_vect = filter(b,a,rw_l);
rw_nl_vect = filter(b,a,rw_nl);


holdtime_changes = find(abs(diff(hold_time))>0);
angle_changes = find(abs(diff(angle1))>0);

h(1) = figure;
try
plot(rw_nl_vect,'b');
hold on
time_ser = 1:(length(rw_nl)/length(rw_l)):length(rw_nl);
plot(time_ser,rw_l_vect,'r');

axis xy;
for i=1:length(angle_changes)
    plot(ceil(angle_index_nl(angle_changes(i)))*ones(1,200),(1/200):(1/200):1,'g','linewidth',2);
end

for i=1:length(holdtime_changes)
    plot(ceil(angle_index_nl(holdtime_changes(i)))*ones(1,73),0:(1/72):1,'k','linewidth',1);
end
axis([1 length(rw_nl) 0 1]);
title('Success Rate');
xlabel('Trial number');
ylabel('Probability');
legend('Intact','Inactivated');
catch
end


% if save_flag
%     
%     rootdirsave = fileparts(matlabroot);
%     save_dir = strcat(rootdirsave,'/',datestr(now,'ddmmyyyy'),'/',datestr(now,'HHMM'));
%     if ~exist(save_dir,'dir')
%         mkdir(save_dir);
%     end
%      
%       savefig(h(1),strcat(save_dir,'/laser_all.fig'));
%       savefig(h(2),strcat(save_dir,'/laser_median.fig'));
%       savefig(h(3),strcat(save_dir,'/nonlaser_all.fig'));
%       savefig(h(4),strcat(save_dir,'/nonlaser_median.fig'));
%       savefig(h(5),strcat(save_dir,'/median_overlay.fig'));
%       savefig(h(6),strcat(save_dir,'/variance_overlay.fig'));
% end