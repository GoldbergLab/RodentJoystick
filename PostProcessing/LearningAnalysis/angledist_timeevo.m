function [theta_nl,theta_nl_rt,theta_l,theta_l_rt,fig_handle] = angledist_timeevo(dirlist,varargin)

default = {45,1};
numvarargs = length(varargin);
if numvarargs > 2
    error('too many arguments (> 3), only 1 required and 2 optional.');
end
[default{1:numvarargs}] = varargin{:};
[dist,save_flag] = default{:};
theta_l = [];
theta_l_rt = [];
theta_nl = [];
theta_nl_rt = [];


for i = 1:length(dirlist)
%   i
    stats = load_stats(dirlist(i),0,1);
    stats = get_stats_with_len(stats,50);
    stats_l = get_stats_with_trajid(stats,1);
    stats_nl = get_stats_with_trajid(stats,2);
    try
    [~,theta_l_t,theta_l_rtime] = anglethreshcross(stats_l,dist*(6.35/100),0,0,1,10,[],0);
    [~,theta_nl_t,theta_nl_rtime] = anglethreshcross(stats_nl,dist*(6.35/100),0,0,1,10,[],0);
    catch
    end
   
    [pathstr_rule,name,ext] = fileparts(dirlist(i).name);
    
    contingency_angle = strsplit(pathstr_rule,'_');
    
    out_thresh = str2num(contingency_angle{end-5});
    hold_time(i) = str2num(contingency_angle{end-4});
    hold_thresh(i) = str2num(contingency_angle{end-3});
    angle1(i) = str2num(contingency_angle{end-2});
    angle2(i) = str2num(contingency_angle{end-1});
    theta_l = [theta_l theta_l_t];
    theta_l_rt = [theta_l_rt theta_l_rtime];
    theta_nl = [theta_nl theta_nl_t];
    theta_nl_rt = [theta_nl_rt theta_nl_rtime];
    angle_index_nl(i) = numel(theta_nl);
    angle_index_l(i) = numel(theta_l);
end
offset = floor(min(theta_l_rt));
theta_l_rt = theta_l_rt - offset;
theta_nl_rt = theta_nl_rt - offset;
end_point = ceil(max(max(theta_l_rt),max(theta_nl_rt)));
fig_handle = figure;
h2 = plot(theta_nl_rt,theta_nl,'ro','MarkerSize',4);
%set(h2,'MarkerFaceColor','r');
hold on;
h1 = plot(theta_l_rt,theta_l,'ko','MarkerSize',4);
%set(h1,'MarkerFaceColor','k');
axis([0 end_point -180 180]);
