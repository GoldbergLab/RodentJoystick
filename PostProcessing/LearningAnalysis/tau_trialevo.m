function [out,h] = tau_trialevo(dirlist,varargin)

default = {30,45,1};
numvarargs = length(varargin);
if numvarargs > 3
    error('too many arguments (> 3), only 1 required and 2 optional.');
end
[default{1:numvarargs}] = varargin{:};
[dist_in,dist_out,save_flag] = default{:};
tau = [];
laser_vect = [];
edges = 0:10:1000;
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
            stats = get_stats_with_reach(stats,(out_thresh(i))*(6.35/100));
            [~,tau_t,~,~] = tau_theta(stats,(hold_thresh(i))*(6.35/100),(out_thresh(i))*(6.35/100),0,0,[],0);
            laser_vect_t = [stats.traj_struct.laser];
            
        catch
            tau_t = [];
            laser_vect_t = [];
        end
                
        tau = [tau tau_t];
        laser_vect = [laser_vect laser_vect_t];
        
        thresh_index(i) = numel(tau);
    end
catch
    display(dirlist(i).name);
end

tau_hist_l = zeros(length(tau)-windowSize,numel(edges));
tau_hist_nl = zeros(length(tau)-windowSize,numel(edges));

for i = 1:(numel(tau)-windowSize)
    tau_win = tau(i:i+windowSize);
    laser_win = laser_vect(i:i+windowSize);
    
    tau_l = tau_win(laser_win==1);
    tau_nl = tau_win(laser_win==0);
    
    tau_hist_l(i,:) = histc(tau_l,edges)/numel(tau_l);
    tau_hist_nl(i,:) = histc(tau_nl,edges)/numel(tau_nl);
    
    tau_mean_l(i) = mean(tau_l);
    tau_mean_nl(i) = mean(tau_nl);
    
    tau_std_l(i) = std(tau_l);
    tau_std_nl(i) = std(tau_nl);
    
    ratio_vect(i).l_trials = numel(tau_l);
    ratio_vect(i).nl_trials = numel(tau_nl);
    
    index_list = [1*ones(numel(tau_l),1);2*ones(numel(tau_nl),1)];
    sig_vect(i) = vartestn(vertcat([reshape(tau_l,numel(tau_l),1);reshape(tau_nl,numel(tau_nl),1)]),index_list,'Display','off','TestType','BrownForsythe');
 end
    thresh_index = [0 thresh_index];
    thresh_index(end) = thresh_index(end)-windowSize;

angle1(angle1<0) = angle1(angle1<0)+360;angle2(angle2<0) = angle2(angle2<0)+360;
angle1 = angle1/5;angle2 = angle2/5;
angle1(angle1>36) = angle1(angle1>36) - 72;angle1 = angle1+36;
angle2(angle2>36) = angle2(angle2>36) - 72;angle2 = angle2 + 36;



c_minmax = [0 0.2];

h(1) =  figure;
imagesc(tau_hist_l');
axis xy
set(gca,'ytick',0:10:100);
set(gca,'yticklabel',['0   ';'100 ';'200 ';'300 ';'400 ';'500 ';'600 ';'700 ';'800 ';'900 ';'1000']);
hold on
caxis([c_minmax(1) c_minmax(2)]);
for i=1:(length(thresh_index)-1)
    edges = thresh_index(i):thresh_index(i+1);
    plot(edges,hold_time(i)*ones(numel(edges),1)/10,'w','linewidth',2);
end
title(strcat('Tau at hold threshold (Inactivated)'));
xlabel('Trial Number');
ylabel('Time (ms)');

h(2) = figure;
imagesc(tau_hist_nl');
axis xy
set(gca,'ytick',0:10:100);
set(gca,'yticklabel',['0   ';'100 ';'200 ';'300 ';'400 ';'500 ';'600 ';'700 ';'800 ';'900 ';'1000']);
hold on;
caxis([c_minmax(1) c_minmax(2)]);
for i=1:(length(thresh_index)-1)
    edges = thresh_index(i):thresh_index(i+1);
    plot(edges,hold_time(i)*ones(numel(edges),1)/10,'w','linewidth',2);
end
title(strcat('Tau at hold threshold (Intact)'));
xlabel('Trial Number');
ylabel('Time (ms)');

h(3) = figure;
plot(tau_mean_l,'b'); hold on;
plot(tau_mean_l-tau_std_l,'r');
plot(tau_mean_l+tau_std_l,'r');
axis xy
for i=1:(length(thresh_index)-1)
    edges = thresh_index(i):thresh_index(i+1);
    plot(edges,hold_time(i)*ones(numel(edges),1),'k','linewidth',2);
end
axis([0 numel(tau_mean_l) 0 1000]);
title(strcat('Tau at hold threshold mean+stddev (Inactivated)'));
xlabel('Trial Number');
ylabel('Time (ms)');


h(4) = figure;
plot(tau_mean_nl,'b'); hold on;
plot(tau_mean_nl-tau_std_nl,'r');
plot(tau_mean_nl+tau_std_nl,'r');
axis xy
for i=1:(length(thresh_index)-1)
    edges = thresh_index(i):thresh_index(i+1);
    plot(edges,hold_time(i)*ones(numel(edges),1),'k','linewidth',2);
end
axis([0 numel(tau_mean_nl) 0 1000]);
title(strcat('Tau at hold threshold mean+stddev (Intact)'));
xlabel('Trial Number');
ylabel('Time (ms)');

h(5) = figure;
plot(tau_mean_l,'r'); hold on;
plot(tau_mean_nl,'b');
axis xy
for i=1:(length(thresh_index)-1)
    edges = thresh_index(i):thresh_index(i+1);
    plot(edges,hold_time(i)*ones(numel(edges),1),'k','linewidth',2);
end
axis([0 numel(tau_mean_l) 0 1000]);
title(strcat('Mean Tau at hold threshold (Intact vs Inactivated)'));
xlabel('Trial Number');
ylabel('Time (ms)');

h(6) = figure;
plot(tau_std_l,'r'); hold on;
plot(tau_std_nl,'b');
for i=1:(length(thresh_index)-1)
    edges = thresh_index(i):thresh_index(i+1);
    plot(edges,hold_time(i)*ones(numel(edges),1),'k','linewidth',2);
end
axis([0 numel(tau_std_l) 0 1000]);
title(strcat('Stddev Tau at hold threshold (Intact vs Inactivated)'));
xlabel('Trial Number');
ylabel('Time (ms)');

% h(7) = figure;
% plot(sig_vect,'r'); hold on;
% axis xy
% for i=1:(length(thresh_index)-1)
%     edges = thresh_index(i):thresh_index(i+1);
%     plot(edges,hold_time(i)*ones(numel(edges),1),'k','linewidth',2);
% end
% axis([0 numel(tau_mean_l) 0 1000]);

out.tau = tau;
out.laser_vect = laser_vect;
out.tau_hist_l = tau_hist_l;
out.tau_hist_nl = tau_hist_nl;
out.sig_vect = sig_vect;
out.ratio_vect = ratio_vect;