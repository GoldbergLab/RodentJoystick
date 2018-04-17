function [theta_nl,theta_nl_rt,theta_l,theta_l_rt,fig_handle,cont_info] = theta_timeevo(dirlist,varargin)

default = {45,1};
numvarargs = length(varargin);
if numvarargs > 2
    error('too many arguments (> 3), only 1 required and 2 optional.');
end
[default{1:numvarargs}] = varargin{:};
[save_flag] = default{:};
theta_l = [];
theta_l_rt = [];
theta_nl = [];
theta_nl_rt = [];


for i = 1:length(dirlist)
%   i
    [pathstr,name,ext] = fileparts(dirlist(i).name);
    [pathstr_rule,name,ext] = fileparts(pathstr);
    contingency_angle = strsplit(name,'_');
    
    out_thresh(i) = str2num(contingency_angle{2});
    hold_time(i) = str2num(contingency_angle{3});
    hold_thresh(i) = str2num(contingency_angle{4});
    angle1(i) = str2num(contingency_angle{5});
    angle2(i) = str2num(contingency_angle{6});
    
    try
    stats = load_stats(dirlist(i),0,1,12);
    stats = get_stats_with_len(stats,50);
    stats = get_stats_startatzero(stats,hold_thresh(i));
    stats_l = get_stats_with_trajid(stats,1);
    stats_nl = get_stats_with_trajid(stats,2);
    [theta_l_t,~,theta_l_rtime,~] = tau_theta(stats_l,hold_thresh(i)*(6.35/100),out_thresh(i)*(6.35/100),0,0,[],0);
    [theta_nl_t,~,theta_nl_rtime,~] = tau_theta(stats_nl,hold_thresh(i)*(6.35/100),out_thresh(i)*(6.35/100),0,0,[],0);
    
    catch
        theta_l_t = [];theta_l_rtime = [];
        theta_nl_t = [];theta_nl_rtime = [];
    end
   
    theta_l = [theta_l theta_l_t];
    theta_l_rt = [theta_l_rt theta_l_rtime];
    theta_nl = [theta_nl theta_nl_t];
    theta_nl_rt = [theta_nl_rt theta_nl_rtime];
    
    angle_index_nl(i) = numel(theta_nl);
    angle_index_l(i) = numel(theta_l);
end

cont_info.out_thresh = out_thresh;
cont_info.hold_time = hold_time;
cont_info.hold_thresh = hold_thresh;
cont_info.angle1 = angle1;
cont_info.angle2 = angle2;
cont_info.angle_index_nl = angle_index_nl;
cont_info.angle_index_l = angle_index_l;

offset_l = floor(min(theta_l_rt));
offset_nl = floor(min(theta_nl_rt));
theta_l_rt = theta_l_rt - offset_l;
theta_nl_rt = theta_nl_rt - offset_nl;
if isempty(theta_l_rt)
    end_point = ceil(max(theta_nl_rt));
else
    end_point = ceil(max(max(theta_l_rt),max(theta_nl_rt)));
end


fig_handle = figure;

hold on;

for i = 1:end_point  
    basevalue = -180;
    h(i+2) = area([(i-0.5),i],[360,360],basevalue);
    set(h(i+2),'FaceColor',[0 0.75 0.75]);
end

h2 = plot(theta_nl_rt,theta_nl,'ko','MarkerSize',4);
%set(h2,'MarkerFaceColor','r');

h1 = plot(theta_l_rt,theta_l,'ro','MarkerSize',4);
%set(h1,'MarkerFaceColor','k');

axis([0 end_point -180 180]);
