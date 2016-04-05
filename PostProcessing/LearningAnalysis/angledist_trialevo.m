function [theta_all_l,theta_all_nl,theta_hist_l,theta_hist_nl] = angledist_trialevo(dirlist,varargin)

default = {45,1};
numvarargs = length(varargin);
if numvarargs > 2
    error('too many arguments (> 3), only 1 required and 2 optional.');
end
[default{1:numvarargs}] = varargin{:};
[dist,save_flag] = default{:};
theta_l = [];
theta_nl = [];
theta_all_l = [];
theta_all_nl = [];
edges = -180:5:180;
windowSize = 100;

for i = 1:length(dirlist)
%   i
    stats = load_stats(dirlist(i),0,1);
    stats = get_stats_with_len(stats,50);
    stats_l = get_stats_with_trajid(stats,1);
    stats_nl = get_stats_with_trajid(stats,2);
    try
    [~,theta_l_t] = anglethreshcross(stats_l,dist*(6.35/100),0,0,1,10,[],0);
    [~,theta_nl_t] = anglethreshcross(stats_nl,dist*(6.35/100),0,0,1,10,[],0);
    catch
    end
%     [~,theta_l_t] = anglethreshcrosshold(stats_l,30*(6.35/100),dist*(6.35/100),400,0,0,10,[],0);
%     [~,theta_nl_t] = anglethreshcrosshold(stats_nl,30*(6.35/100),dist*(6.35/100),400,0,0,10,[],0);
   
    [pathstr,name,ext] = fileparts(dirlist(i).name);
    [pathstr_rule,name,ext] = fileparts(dirlist(i).name);
    
    contingency_angle = strsplit(pathstr_rule,'_');
    
    out_thresh = str2num(contingency_angle{2});
    hold_time(i) = str2num(contingency_angle{3});
    hold_thresh(i) = str2num(contingency_angle{4});
    angle1(i) = str2num(contingency_angle{5});
    angle2(i) = str2num(contingency_angle{6});
    theta_l = [theta_l theta_l_t];
    theta_nl = [theta_nl theta_nl_t];
    angle_index_nl(i) = numel(theta_nl);
    angle_index_l(i) = numel(theta_l);
end

ratio = (angle_index_nl(end)/angle_index_l(end));
angle_index_nl(end) = angle_index_nl(end)-windowSize*ratio;
angle_index_l(end) = angle_index_l(end)-windowSize;

angle1(angle1<0) = angle1(angle1<0)+360;
angle2(angle2<0) = angle2(angle2<0)+360;

angle1 = angle1/5;
angle2 = angle2/5;

angle1(angle1>36) = angle1(angle1>36) - 72;
angle1 = angle1+36;

angle2(angle2>36) = angle2(angle2>36) - 72;
angle2 = angle2 + 36;

for i = 1:((numel(theta_l)-windowSize)/10)
    index = ((i-1)*10+1):(i*10+(windowSize-10));
    theta_hist_l(i,:) = histc(theta_l(index),edges)/50;
    theta_all_l = [theta_all_l theta_l(index)'];
end

%  ratio = numel(theta_nl)/numel(theta_l);
% elements = ceil(50*ratio);
% for i = 1:((numel(theta_nl)-(elements+floor(10*ratio)))/floor(10*ratio));
%     index = ((i-1)*floor(10*ratio)+1):(i*floor(10*ratio)+elements-floor(elements*ratio/10));
%     theta_hist_nl(i,:) = histc(theta_nl(index),edges)/(elements);    
%     theta_all_nl = [theta_all_nl theta_nl(index)'];
% end 

for i = 1:((numel(theta_nl)-ratio*windowSize)/10)
    index = (((i-1)*10+1):(i*10+(windowSize-10)));
    theta_hist_nl(i,:) = histc(theta_nl(index),edges)/50;
    theta_all_nl = [theta_all_nl theta_nl(index)'];
end

holdtime_changes = find(abs(diff(hold_time))>0);

h1 = figure;
imagesc(theta_hist_l');
axis xy;
hold on;
angle_index_l = [0 angle_index_l];
for i=1:(length(angle_index_l)-1)
    edges = (ceil(angle_index_l(i)/10)+1):ceil(angle_index_l(i+1)/10);
    plot(edges,angle1(i)*ones(numel(edges),1),'w','linewidth',2);
    plot(edges,angle2(i)*ones(numel(edges),1),'w','linewidth',2);
end
set(gca,'ytick',0:12:72);
set(gca,'yticklabel',['-180';'-120';'-60 ';'0   ';'60  ';'120 ';'180 ']);

for i=1:length(holdtime_changes)
    plot(ceil(angle_index_l(holdtime_changes(i))/10)*ones(1,72),1:72,'w','linewidth',1);
end

h2 = figure;
plot(median(theta_all_l),'b');
hold on;
plot(prctile(theta_all_l,25),'r');
plot(prctile(theta_all_l,75),'r');
axis xy;
for i=1:(length(angle_index_l)-1)
    edges = (ceil(angle_index_l(i)/10)+1):ceil(angle_index_l(i+1)/10);
    plot(edges,(angle1(i)-36)*5*ones(numel(edges),1),'k','linewidth',2);
    plot(edges,(angle2(i)-36)*5*ones(numel(edges),1),'k','linewidth',2);
end

for i=1:length(holdtime_changes)
    plot(ceil(angle_index_l(holdtime_changes(i))/10)*ones(1,73),-180:5:180,'k','linewidth',1);
end
axis([1 length(median(theta_all_l)) -180 180]);

h3= figure;
imagesc(theta_hist_nl');
axis xy;
hold on;
angle_index_nl = [0 angle_index_nl];
for i=1:(length(angle_index_nl)-1)
    edges = (ceil(angle_index_nl(i)/10)+1):ceil(angle_index_nl(i+1)/10);
    plot(edges,angle1(i)*ones(numel(edges),1),'w','linewidth',2);
    plot(edges,angle2(i)*ones(numel(edges),1),'w','linewidth',2);
end
set(gca,'ytick',0:12:72);
set(gca,'yticklabel',['-180';'-120';'-60 ';'0   ';'60  ';'120 ';'180 ']);

for i=1:length(holdtime_changes)
    plot(ceil(angle_index_nl(holdtime_changes(i))/10)*ones(1,72),1:72,'w','linewidth',1);
end

h4 = figure;
plot(median(theta_all_nl),'b');
hold on;
plot(prctile(theta_all_nl,25),'r');
plot(prctile(theta_all_nl,75),'r');
axis xy;

for i=1:(length(angle_index_nl)-1)
    edges = (ceil(angle_index_nl(i)/10)+1):ceil(angle_index_nl(i+1)/10);
    plot(edges,(angle1(i)-36)*5*ones(numel(edges),1),'k','linewidth',2);
    plot(edges,(angle2(i)-36)*5*ones(numel(edges),1),'k','linewidth',2);
end

for i=1:length(holdtime_changes)
    plot(ceil(angle_index_nl(holdtime_changes(i))/10)*ones(1,73),-180:5:180,'k','linewidth',1);
end
axis([1 length(median(theta_all_nl)) -180 180]);

h5 = figure;
plot(median(theta_all_nl),'b');
hold on;
time_ser = 1:(length(theta_all_nl)/length(theta_all_l)):length(theta_all_nl);
plot(time_ser,median(theta_all_l),'r');
for i=1:(length(angle_index_nl)-1)
    edges = (ceil(angle_index_nl(i)/10)+1):ceil(angle_index_nl(i+1)/10);
    plot(edges,(angle1(i)-36)*5*ones(numel(edges),1),'k','linewidth',2);
    plot(edges,(angle2(i)-36)*5*ones(numel(edges),1),'k','linewidth',2);
end
axis([1 length(median(theta_all_nl)) -180 180]);

angle_changes = find(abs(diff(angle1))>0);

h6 = figure;
plot(std(theta_all_nl),'b');
hold on;
time_ser = 1:(length(theta_all_nl)/length(theta_all_l)):length(theta_all_nl);
plot(time_ser,std(theta_all_l),'r');

for i=1:length(angle_changes)
    plot(ceil(angle_index_nl(angle_changes(i))/10)*ones(1,100),1:100,'k','linewidth',2);
end

axis([1 length(var(theta_all_nl)) 0 100]);


if save_flag
    
    rootdirsave = fileparts(matlabroot);
    save_dir = strcat(rootdirsave,'/',datestr(now,'ddmmyyyy'),'/',datestr(now,'HHMM'));
    if ~exist(save_dir,'dir')
        mkdir(save_dir);
    end
     
      savefig(h1,strcat(save_dir,'/laser_all.fig'));
      savefig(h2,strcat(save_dir,'/laser_median.fig'));
      savefig(h3,strcat(save_dir,'/nonlaser_all.fig'));
      savefig(h4,strcat(save_dir,'/nonlaser_median.fig'));
      savefig(h5,strcat(save_dir,'/median_overlay.fig'));
      savefig(h6,strcat(save_dir,'/variance_overlay.fig'));
end