function [out,h] = pos_trialevo(dirlist,varargin)

default = {45,1};
numvarargs = length(varargin);
if numvarargs > 2
    error('too many arguments (> 3), only 1 required and 2 optional.');
end
[default{1:numvarargs}] = varargin{:};
[dist,save_flag] = default{:};
pos_mag_t = [];
laser_vect = [];
edges = -180:5:180;
windowSize = 200;
step_sz = 50;
maxtime = 400;
try
    for i = 1:length(dirlist)
        tic
        [pathstr,name,ext] = fileparts(dirlist(i).name);
        [pathstr_rule,name,ext] = fileparts(dirlist(i).name);
        contingency_angle = strsplit(pathstr_rule,'_');
        
        out_thresh(i) = str2num(contingency_angle{2});
        hold_time(i) = str2num(contingency_angle{3});
        hold_thresh(i) = str2num(contingency_angle{4});
        angle1(i) = str2num(contingency_angle{5});
        angle2(i) = str2num(contingency_angle{6});
        
        try
            if exist(strcat(dirlist(i).name,'/stats_ts.mat'))
                stats = load_stats(dirlist(i),1,1);
            else
                stats = load_stats(dirlist(i),1,0);
            end
            stats = get_stats_with_len(stats,50);
            stats = get_stats_startatzero(stats);
            [pos_mag,pos_pdf] = posthreshcross_pdf(stats,maxtime);
            laser_vect_t = [stats.traj_struct.laser];
        catch
        end

        pos_mag_t = [pos_mag_t;pos_mag];
        laser_vect = [laser_vect laser_vect_t];
        
        angle_index(i) = size(pos_mag_t,1);
        toc
    end
catch
    display(dirlist(i).name);
end

angle_index = [1 angle_index];

pos_median_l = zeros(floor(size(pos_mag_t,1)/step_sz-windowSize),maxtime);
pos_median_nl = zeros(floor(size(pos_mag_t,1)/step_sz-windowSize),maxtime);

for i = 1:((size(pos_mag_t,1)-windowSize)/step_sz)
    index_list = (step_sz*(i-1)+1):(step_sz*(i-1)+windowSize);
    pos_win = pos_mag_t(index_list,:);
    laser_win = laser_vect(index_list);
    
    pos_l = pos_win(laser_win==1,:);
    pos_nl = pos_win(laser_win==0,:);
    
    pos_median_l(i,:) = nanmedian(pos_l,1);
    pos_median_nl(i,:) = nanmedian(pos_nl,1);
end    

angle_changes = find(abs(diff(angle1))>0 | abs(diff(angle2))>0);

out.pos_mag = pos_mag_t;
out.pos_median_l = pos_median_l;
out.pos_median_nl = pos_median_nl;

out.out_thresh=out_thresh;
out.hold_time=hold_time;
out.hold_thresh=hold_thresh;
out.angle1=angle1;
out.angle2=angle2;
out.cont_change_index = angle_index(2:end);

h=[];

h(1) = figure;
imagesc(pos_median_l);
axis xy;
hold on
for i=1:numel(angle_changes)
    y_index = floor(angle_index(angle_changes(i))/step_sz)*ones(1,maxtime);
    x_index = 1:maxtime;
    plot(x_index,y_index,'w','LineWidth',2);
end
for i=1:numel(hold_time)
    y_index = floor(angle_index(i)/step_sz):floor(angle_index(i+1)/step_sz);
    x_index = hold_time(i)*ones(numel(y_index),1);
    plot(x_index,y_index,'w','LineWidth',2);
end
caxis([0 4])

h(2) = figure;
imagesc(pos_median_nl);
axis xy;
hold on
for i=1:numel(angle_changes)
    y_index = floor(angle_index(angle_changes(i))/step_sz)*ones(1,maxtime);
    x_index = 1:maxtime;
    plot(x_index,y_index,'w','LineWidth',2);
end
for i=1:numel(hold_time)
    y_index = floor(angle_index(i)/step_sz):floor(angle_index(i+1)/step_sz);
    x_index = hold_time(i)*ones(numel(y_index),1);
    plot(x_index,y_index,'w','LineWidth',2);
end
caxis([0 4])

% if save_flag
% 
%     rootdirsave = fileparts(matlabroot);
%     save_dir = strcat(rootdirsave,'/',datestr(now,'ddmmyyyy'),'/',datestr(now,'HHMM'));
%     if ~exist(save_dir,'dir')
%         mkdir(save_dir);
%     end
% 
%       savefig(h(1),strcat(save_dir,'/laser_all.fig'));
%       savefig(h(2),strcat(save_dir,'/laser_mean.fig'));
%       savefig(h(3),strcat(save_dir,'/nonlaser_all.fig'));
%       savefig(h(4),strcat(save_dir,'/nonlaser_mean.fig'));
%       savefig(h(5),strcat(save_dir,'/mean_overlay.fig'));
%       savefig(h(6),strcat(save_dir,'/stdev_overlay.fig'));
% end
% 
% 
