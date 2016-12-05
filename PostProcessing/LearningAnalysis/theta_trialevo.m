function [out,h] = theta_trialevo(dirlist,varargin)

default = {1};
numvarargs = length(varargin);
if numvarargs > 1
    error('too many arguments (> 3), only 1 required and 2 optional.');
end
[default{1:numvarargs}] = varargin{:};
[save_flag] = default{:};
theta = [];
laser_vect = [];
edges = -180:5:180;
windowSize = 200;

try
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
        angle3(i) = str2num(contingency_angle{7});
        angle4(i) = str2num(contingency_angle{8});
        
        
        try
            stats = load_stats(dirlist(i),0,1);
            stats = get_stats_with_len(stats,50);
            stats = get_stats_startatzero(stats,hold_thresh(i));
            stats = get_stats_with_reach(stats,out_thresh(i)*(6.35/100));
            [theta_t,~,~,~] = tau_theta(stats,hold_thresh(i)*(6.35/100),out_thresh(i)*(6.35/100),0,0,[],0);
            laser_vect_t = [stats.traj_struct.laser];
        catch
            theta_t = [];
            laser_vect_t = [];
        end

        theta = [theta theta_t];
        laser_vect = [laser_vect laser_vect_t];
        
        angle_index(i) = numel(theta);
    end
catch
    display(dirlist(i).name);
end

theta_hist_l = zeros(length(theta)-windowSize,73);
theta_hist_nl = zeros(length(theta)-windowSize,73);

for i = 1:(numel(theta)-windowSize)
    theta_win = theta(i:i+windowSize);
    laser_win = laser_vect(i:i+windowSize);
    
    theta_l = theta_win(laser_win==1);
    theta_nl = theta_win(laser_win==0);
    
    theta_hist_l(i,:) = histc(theta_l,-180:5:180)/numel(theta_l);
    theta_hist_nl(i,:) = histc(theta_nl,-180:5:180)/numel(theta_nl);
    
    theta_mean_l(i) = mean(theta_l);
    theta_mean_nl(i) = mean(theta_nl);
    
    theta_std_l(i) = std(theta_l);
    theta_std_nl(i) = std(theta_nl);
    
    ratio_vect(i).l_trials = numel(theta_l);
    ratio_vect(i).nl_trials = numel(theta_nl);
    
    index_list = [1*ones(numel(theta_l),1);2*ones(numel(theta_nl),1)];
    sig_vect(i) = vartestn(vertcat([reshape(theta_l,numel(theta_l),1);reshape(theta_nl,numel(theta_nl),1)]),index_list,'Display','off','TestType','BrownForsythe');
 end
    angle_index = [0 angle_index];
angle_index(end) = angle_index(end)-windowSize;

angle1(angle1<0) = angle1(angle1<0)+360;angle2(angle2<0) = angle2(angle2<0)+360;
angle3(angle3<0) = angle3(angle3<0)+360;angle4(angle4<0) = angle4(angle4<0)+360;

angle1 = angle1/5;angle2 = angle2/5;
angle3 = angle3/5;angle4 = angle4/5;

angle1(angle1>36) = angle1(angle1>36) - 72;angle1 = angle1+36;
angle2(angle2>36) = angle2(angle2>36) - 72;angle2 = angle2+36;
angle3(angle3>36) = angle3(angle3>36) - 72;angle3 = angle3+36;
angle4(angle4>36) = angle4(angle4>36) - 72;angle4 = angle4+36;


c_minmax = [0 0.2];

h(1) =  figure;
imagesc(theta_hist_l');
axis xy
hold on
caxis([c_minmax(1) c_minmax(2)]);
set(gca,'ytick',0:12:72);
set(gca,'yticklabel',['-180';'-120';'-60 ';'0   ';'60  ';'120 ';'180 ']);

for i=1:(length(angle_index)-1)
    edges = angle_index(i):angle_index(i+1);
    plot(edges,(angle3(i))*ones(numel(edges),1),'w','linewidth',2);
    plot(edges,(angle4(i))*ones(numel(edges),1),'w','linewidth',2);
end
title('Angle at outer threshold Crossing (Laser)');
xlabel('Trial Number');
ylabel('Angle (degrees)');

h(2) = figure;
imagesc(theta_hist_nl');
axis xy
hold on;
caxis([c_minmax(1) c_minmax(2)]);
set(gca,'ytick',0:12:72);
set(gca,'yticklabel',['-180';'-120';'-60 ';'0   ';'60  ';'120 ';'180 ']);

for i=1:(length(angle_index)-1)
    edges = angle_index(i):angle_index(i+1);
    plot(edges,(angle1(i))*ones(numel(edges),1),'w','linewidth',2);
    plot(edges,(angle2(i))*ones(numel(edges),1),'w','linewidth',2);
end
title('Angle at outer threshold Crossing (No-Laser)');
xlabel('Trial Number');
ylabel('Angle (degrees)');

h(3) = figure;
plot(theta_mean_l,'b'); hold on;
plot(theta_mean_l-theta_std_l,'r');
plot(theta_mean_l+theta_std_l,'r');
axis xy
for i=1:(length(angle_index)-1)
    edges = angle_index(i):angle_index(i+1);
    plot(edges,(angle3(i)-36)*5*ones(numel(edges),1),'k','linewidth',2);
    plot(edges,(angle4(i)-36)*5*ones(numel(edges),1),'k','linewidth',2);
end
axis([0 numel(theta_mean_l) -180 180]);
title('Mean & Stdev Angle at outer threshold Crossing (Laser)');
xlabel('Trial Number');
ylabel('Angle (degrees)');

h(4) = figure;
plot(theta_mean_nl,'b'); hold on;
plot(theta_mean_nl-theta_std_nl,'r');
plot(theta_mean_nl+theta_std_nl,'r');
axis xy
for i=1:(length(angle_index)-1)
    edges = angle_index(i):angle_index(i+1);
    plot(edges,(angle1(i)-36)*5*ones(numel(edges),1),'k','linewidth',2);
    plot(edges,(angle2(i)-36)*5*ones(numel(edges),1),'k','linewidth',2);
end
axis([0 numel(theta_mean_nl) -180 180]);
title('Mean & Stdev Angle at outer threshold Crossing (No-Laser)');
xlabel('Trial Number');
ylabel('Angle (degrees)');

h(5) = figure;
plot(theta_mean_l,'r'); hold on;
plot(theta_mean_nl,'b');
axis xy
for i=1:(length(angle_index)-1)
    edges = angle_index(i):angle_index(i+1);
    plot(edges,(angle1(i)-36)*5*ones(numel(edges),1),'k','linewidth',2);
    plot(edges,(angle2(i)-36)*5*ones(numel(edges),1),'k','linewidth',2);
    plot(edges,(angle3(i)-36)*5*ones(numel(edges),1),'k','linewidth',2);
    plot(edges,(angle4(i)-36)*5*ones(numel(edges),1),'k','linewidth',2);
end
axis([0 numel(theta_mean_l) -180 180]);
title('Mean at outer threshold Crossing (Laser vs No-Laser)');
xlabel('Trial Number');
ylabel('Angle (degrees)');

h(6) = figure;
plot(theta_std_l,'r'); hold on;
plot(theta_std_nl,'b');
axis([0 numel(theta_std_l) 0 360]);
title('Stdev at outer threshold Crossing (Laser vs No-Laser)');
xlabel('Trial Number');
ylabel('Angle (degrees)');

% h(7) = figure;
% plot(sig_vect,'r'); hold on;
% axis xy
% for i=1:(length(angle_index)-1)
%     edges = angle_index(i):angle_index(i+1);
%     plot(edges,(angle1(i)-36)*5*ones(numel(edges),1),'k','linewidth',2);
%     plot(edges,(angle2(i)-36)*5*ones(numel(edges),1),'k','linewidth',2);
% end
% axis([0 numel(theta_mean_l) -180 180]);

out.theta = theta;
out.laser_vect = laser_vect;
out.theta_hist_l = theta_hist_l;
out.theta_hist_nl = theta_hist_nl;
out.sig_vect = sig_vect;
out.ratio_vect = ratio_vect;

if save_flag

    rootdirsave = fileparts(matlabroot);
    save_dir = strcat(rootdirsave,'/',datestr(now,'ddmmyyyy'),'/',datestr(now,'HHMM'));
    if ~exist(save_dir,'dir')
        mkdir(save_dir);
    end

      savefig(h(1),strcat(save_dir,'/laser_all.fig'));
      savefig(h(2),strcat(save_dir,'/laser_mean.fig'));
      savefig(h(3),strcat(save_dir,'/nonlaser_all.fig'));
      savefig(h(4),strcat(save_dir,'/nonlaser_mean.fig'));
      savefig(h(5),strcat(save_dir,'/mean_overlay.fig'));
      savefig(h(6),strcat(save_dir,'/stdev_overlay.fig'));
end


