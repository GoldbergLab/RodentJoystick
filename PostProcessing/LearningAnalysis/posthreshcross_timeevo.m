function [dur_nl,dur_nl_rt,dur_l,dur_l_rt,fig_handle] = posthreshcross_timeevo(dirlist,varargin) 

default = {30,1};
numvarargs = length(varargin);
if numvarargs > 2
    error('too many arguments (> 3), only 1 required and 2 optional.');
end
[default{1:numvarargs}] = varargin{:};
[dist,save_flag] = default{:};
dur_l = [];
dur_nl = [];
dur_l_rt = [];
dur_nl_rt = [];
edges = 50:50:1000;
windowSize = 200;
for i = 1:length(dirlist)
%   i
    stats = load_stats(dirlist(i),0,1);
    stats = get_stats_with_len(stats,50);
    stats_l = get_stats_with_trajid(stats,1);
    stats_nl = get_stats_with_trajid(stats,2);
    try
    [~,dur_l_t,dur_l_t_r] = posthreshcross(stats_l,dist*(6.35/100),0,0,1,10,[],0);
    [~,dur_nl_t,dur_nl_t_r] = posthreshcross(stats_nl,dist*(6.35/100),0,0,1,10,[],0);
    catch
    end
%     [~,theta_l_t] = anglethreshcrosshold(stats_l,30*(6.35/100),dist*(6.35/100),400,0,0,10,[],0);
%     [~,theta_nl_t] = anglethreshcrosshold(stats_nl,30*(6.35/100),dist*(6.35/100),400,0,0,10,[],0);
   
    [pathstr,name,ext] = fileparts(dirlist(i).name);
    [pathstr_rule,name,ext] = fileparts(dirlist(i).name);
    
    contingency_angle = strsplit(pathstr_rule,'_');
    
    out_thresh = str2num(contingency_angle{end-5});
    hold_time(i) = str2num(contingency_angle{end-4});
    hold_thresh(i) = str2num(contingency_angle{end-3});
    angle1(i) = str2num(contingency_angle{end-2});
    angle2(i) = str2num(contingency_angle{end-1});
    dur_l = [dur_l dur_l_t];
    dur_l_rt = [dur_l_rt dur_l_t_r];
    dur_nl = [dur_nl dur_nl_t];
    dur_nl_rt = [dur_nl_rt dur_nl_t_r];
    
    angle_index_nl(i) = numel(dur_nl);
    angle_index_l(i) = numel(dur_l);
end

offset = floor(min(dur_l_rt));
dur_l_rt = dur_l_rt - offset;
dur_nl_rt = dur_nl_rt - offset;
end_point = ceil(max(max(dur_l_rt),max(dur_nl_rt)));

fig_handle = figure;
h2 = plot(dur_nl_rt,dur_nl,'ko','MarkerSize',4);
set(h2,'MarkerFaceColor','k');
axis([0 end_point 0 1000])
hold on
h1 = plot(dur_l_rt,dur_l,'ro','MarkerSize',4);
set(h1,'MarkerFaceColor','r');
axis([0 end_point 0 1000])


