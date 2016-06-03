function [dur_hist_l,dur_hist_nl,dur_all_l,dur_all_nl,fig_handle] = posthreshcross_trialevo(dirlist,varargin) 

default = {30,1};
numvarargs = length(varargin);
if numvarargs > 2
    error('too many arguments (> 3), only 1 required and 2 optional.');
end
[default{1:numvarargs}] = varargin{:};
[dist,save_flag] = default{:};
dur_l = [];
dur_nl = [];
dur_all_l = [];
dur_all_nl = [];
edges = 50:50:1000;
windowSize = 50;
for i = 1:length(dirlist)
%   i
    try
    stats = load_stats(dirlist(i),0,1);
    stats = get_stats_with_len(stats,50);
    stats_l = get_stats_with_trajid(stats,1);
    stats_nl = get_stats_with_trajid(stats,2);
    
    [~,dur_l_t] = posthreshcross(stats_l,dist*(6.35/100),0,0,1,10,[],0);
    [~,dur_nl_t] = posthreshcross(stats_nl,dist*(6.35/100),0,0,1,10,[],0);
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
    dur_nl = [dur_nl dur_nl_t];
    angle_index_nl(i) = numel(dur_nl);
    angle_index_l(i) = numel(dur_l);
end

for i = 1:((numel(dur_l)-windowSize)/10)
    index = (((i-1)*10+1):(i*10+(windowSize-10)));
    dur_hist_l(i,:) = histc(dur_l(index),edges)/windowSize;
    dur_all_l = [dur_all_l dur_l(index)'];
end

for i = 1:((numel(dur_nl)-windowSize)/10)
    index = (((i-1)*10+1):(i*10+(windowSize-10)));
    dur_hist_nl(i,:) = histc(dur_nl(index),edges)/windowSize;
    dur_all_nl = [dur_all_nl dur_nl(index)'];
end

angle_changes = find(abs(diff(angle1))>0);
for i=1:length(angle_changes)
    plot(ceil(angle_index_l(angle_changes(i))/10)*ones(1,200),1:200,'w','linewidth',2);
end

fig_handle(1) = figure;
imagesc(dur_hist_l');
axis xy
hold on;
angle_index_l = [0 angle_index_l];
for i=1:(length(angle_index_l)-1)
    edges = (ceil(angle_index_l(i)/10)+1):ceil(angle_index_l(i+1)/10);
    plot(edges,(hold_time(i)/50)*ones(numel(edges),1),'w','linewidth',2);
end

for i=1:length(angle_changes)
    plot(ceil(angle_index_l(angle_changes(i))/10)*ones(1,200),1:200,'w','linewidth',2);
end

set(gca,'ytick',[1 10 20]);
set(gca,'yticklabel',['  50';' 500';'1000']);

fig_handle(2) = figure;
imagesc(dur_hist_nl');
axis xy
hold on;
angle_index_nl = [0 angle_index_nl];
for i=1:(length(angle_index_nl)-1)
    edges = (ceil(angle_index_nl(i)/10)+1):ceil(angle_index_nl(i+1)/10);
    plot(edges,(hold_time(i)/50)*ones(numel(edges),1),'w','linewidth',2);
end

for i=1:length(angle_changes)
    plot(ceil(angle_index_nl(angle_changes(i))/10)*ones(1,200),1:200,'w','linewidth',2);
end

set(gca,'ytick',[1 10 20]);
set(gca,'yticklabel',['  50';' 500';'1000']);

