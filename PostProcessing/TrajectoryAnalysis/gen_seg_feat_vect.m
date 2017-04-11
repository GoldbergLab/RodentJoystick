function [] = gen_seg_feat_vect(stats,figure_title)
%GENERATE_SEG_FEAT_VECT 
% Create and Display features of segments within trajectories such as
% velocity, pathlength, etc with comparison to inactivated trials

%% Only get trajectories greater than 50ms in length and start within inner radius
stats = get_stats_with_len(stats,50);
stats_orig = stats;

%% Only get trajectories which ended in Reward or were ended because of joystick contact lost
stats_temp = get_stats_with_stopindex(stats,1); 
stats = get_stats_with_stopindex(stats,4);
stats.traj_struct = [stats.traj_struct stats_temp.traj_struct];

%% Remove all segments from trajectories that happen before 50 ms

stats = get_segments_after_time(stats,50);

% Separate out trajectories in laser and no laser
stats_l = get_stats_with_trajid(stats,1);
stats_nl = get_stats_with_trajid(stats,2);
%% General Trajectory & Segment Level Analysis (ALL)
figure;
suptitle(figure_title);
% Get Trajectory level Descriptors
% Trajectory Duration
subplot(2,4,1);
ax=gca;
rw_only=0;plotflag=1;interv=50;color='r';
traj_duration(stats_l,0,rw_only,interv,ax,plotflag,color);
color ='b';
traj_duration(stats_nl,0,rw_only,interv,ax,plotflag,color);
xlabel('Time (ms)')
title('Trajectory Duration');
legend('Laser','No Laser');

%Trajectory Pathlength
subplot(2,4,2);
ax=gca;
rw_only=0;plotflag=1;interv=1;color='r';
traj_pathlen(stats_l,0,rw_only,interv,ax,plotflag,color);
color ='b';
traj_pathlen(stats_nl,0,rw_only,interv,ax,plotflag,color);
xlabel('Distance (mm)')
title('Trajectory Pathlen');

%Trajectory Max Velocity
subplot(2,4,3);
ax=gca;
rw_only=0;plotflag=1;interv=5;color='r';
traj_maxvel(stats_l,0,rw_only,interv,ax,plotflag,color);
color ='b';
traj_maxvel(stats_nl,0,rw_only,interv,ax,plotflag,color);
xlabel('Vel (mm/ms)')
title('Trajectory Peak Velocity');

%Trajectory Avg Velocity
subplot(2,4,4);
ax=gca;
rw_only=0;plotflag=1;interv=5;color='r';
traj_avgvel(stats_l,0,rw_only,interv,ax,plotflag,color);
color ='b';
traj_avgvel(stats_nl,0,rw_only,interv,ax,plotflag,color);
xlabel('Vel (mm/ms)')
title('Trajectory Avg Velocity');

% Get Segment Level Analysis
% Segment Pathlen
subplot(2,4,5)
ax=gca;
rw_only=0;plotflag=1;interv=5;color='r';
seg_pathlen(stats_l,0,rw_only,interv,ax,plotflag,color);
color='b';
seg_pathlen(stats_nl,0,rw_only,interv,ax,plotflag,color);
xlabel('Distance (mm)')
title('Segment Pathlen');

%Segment Duration
subplot(2,4,6)
ax=gca;
rw_only=0;plotflag=1;interv=2;color='r';
seg_dur(stats_l,0,rw_only,interv,ax,plotflag,color);
color='b';
seg_dur(stats_nl,0,rw_only,interv,ax,plotflag,color);
xlabel('Time (ms)')
title('Segment Duration');

%Segment Peakvel
subplot(2,4,7)
ax=gca;
rw_only=0;plotflag=1;interv=0.005;color='r';
seg_peakvel(stats_l,0,rw_only,interv,ax,plotflag,color);
color='b';
seg_peakvel(stats_nl,0,rw_only,interv,ax,plotflag,color);
xlabel('Velocity (mm/ms)')
title('Segment Peak Velocity');

%Segment Avgvel
subplot(2,4,8)
ax=gca;
rw_only=0;plotflag=1;interv=0.0005;color='r';
seg_avgvel(stats_l,0,rw_only,interv,ax,plotflag,color);
color='b';
seg_avgvel(stats_nl,0,rw_only,interv,ax,plotflag,color);
xlabel('Velocity (mm/ms)')
title('Segment Avg Velocity');

%% Compare Effect of Inactivation on Segment 1
figure;
suptitle(strcat(figure_title,'Segment 1'));

num_seg = 1;
stats_seg_1 = get_stats_with_segnum(stats,num_seg);
stats_l = get_stats_with_trajid(stats_seg_1,1);
stats_nl = get_stats_with_trajid(stats_seg_1,2);

% Segment Pathlen
subplot(1,4,1)
ax=gca;
rw_only=0;plotflag=1;interv=5;color='r';
seg_pathlen(stats_l,0,rw_only,interv,ax,plotflag,color);
color='b';
seg_pathlen(stats_nl,0,rw_only,interv,ax,plotflag,color);
xlabel('Distance (mm)')
title('Segment Pathlen');

%Segment Duration
subplot(1,4,2)
ax=gca;
rw_only=0;plotflag=1;interv=2;color='r';
seg_dur(stats_l,0,rw_only,interv,ax,plotflag,color);
color='b';
seg_dur(stats_nl,0,rw_only,interv,ax,plotflag,color);
xlabel('Time (ms)')
title('Segment Duration');

%Segment Peakvel
subplot(1,4,3)
ax=gca;
rw_only=0;plotflag=1;interv=0.0005;color='r';
seg_peakvel(stats_l,0,rw_only,interv,ax,plotflag,color);
color='b';
seg_peakvel(stats_nl,0,rw_only,interv,ax,plotflag,color);
xlabel('Velocity (mm/ms)')
title('Segment Peak Velocity');

%Segment Avgvel
subplot(1,4,4)
ax=gca;
rw_only=0;plotflag=1;interv=0.0005;color='r';
seg_avgvel(stats_l,0,rw_only,interv,ax,plotflag,color);
color='b';
seg_avgvel(stats_nl,0,rw_only,interv,ax,plotflag,color);
xlabel('Velocity (mm/ms)')
title('Segment Avg Velocity');

%% Reach Segment Features 

figure;
suptitle(strcat(figure_title,'Reach Segment'));

thresh = 63*6.35/100;
stats_out = get_reach_seg(stats,thresh);

stats_l = get_stats_with_trajid(stats_out,1);
stats_nl = get_stats_with_trajid(stats_out,2);

% Segment Pathlen
subplot(1,5,1)
ax=gca;
rw_only=0;plotflag=1;interv=5;color='r';
seg_pathlen(stats_l,0,rw_only,interv,ax,plotflag,color);
color='b';
seg_pathlen(stats_nl,0,rw_only,interv,ax,plotflag,color);
xlabel('Distance (mm)')
title('Segment Pathlen');

%Segment Duration
subplot(1,5,2)
ax=gca;
rw_only=0;plotflag=1;interv=2;color='r';
seg_dur(stats_l,0,rw_only,interv,ax,plotflag,color);
color='b';
seg_dur(stats_nl,0,rw_only,interv,ax,plotflag,color);
xlabel('Time (ms)')
title('Segment Duration');

%Segment Peakvel
subplot(1,5,3)
ax=gca;
rw_only=0;plotflag=1;interv=0.0005;color='r';
seg_peakvel(stats_l,0,rw_only,interv,ax,plotflag,color);
color='b';
seg_peakvel(stats_nl,0,rw_only,interv,ax,plotflag,color);
xlabel('Velocity (mm/ms)')
title('Segment Peak Velocity');

%Segment Avgvel
subplot(1,5,4)
ax=gca;
rw_only=0;plotflag=1;interv=0.0005;color='r';
seg_avgvel(stats_l,0,rw_only,interv,ax,plotflag,color);
color='b';
seg_avgvel(stats_nl,0,rw_only,interv,ax,plotflag,color);
xlabel('Velocity (mm/ms)')
title('Segment Avg Velocity');

%Segment onset
subplot(1,5,5)
ax = gca;
rw_only=0;plotflag=1;interv=20;color='r';
seg_onset(stats_l,0,rw_only,interv,ax,plotflag,color);
color='b';
seg_onset(stats_nl,0,rw_only,interv,ax,plotflag,color);
xlabel('Time in Trajectory (ms)')
title('Reach Segment Onset');

%% Reach Segments for Rewarded Trials

figure;
suptitle(strcat(figure_title,'Last Segment vs Rest in Rw Trials'));

stats = get_stats_rw(stats_orig,1);
stats = get_stats_with_trajid(stats,2);
stats_out_1 = get_last_seg(stats);
num_fromend=1;
stats_out_2 = get_early_seg(stats,num_fromend);

stats_l = get_stats_with_trajid(stats_out_1,0);
stats_nl = get_stats_with_trajid(stats_out_2,0);

% Segment Pathlen
subplot(1,4,1)
ax=gca;
rw_only=0;plotflag=1;interv=5;color='r';
seg_pathlen(stats_l,0,rw_only,interv,ax,plotflag,color);
color='b';
seg_pathlen(stats_nl,0,rw_only,interv,ax,plotflag,color);
xlabel('Distance (mm)')
title('Segment Pathlen');

%Segment Duration
subplot(1,4,2)
ax=gca;
rw_only=0;plotflag=1;interv=10;color='r';
seg_dur(stats_l,0,rw_only,interv,ax,plotflag,color);
color='b';
seg_dur(stats_nl,0,rw_only,interv,ax,plotflag,color);
xlabel('Time (ms)')
title('Segment Duration');

%Segment Peakvel
subplot(1,4,3)
ax=gca;
rw_only=0;plotflag=1;interv=0.005;color='r';
seg_peakvel(stats_l,0,rw_only,interv,ax,plotflag,color);
color='b';
seg_peakvel(stats_nl,0,rw_only,interv,ax,plotflag,color);
xlabel('Velocity (mm/ms)')
title('Segment Peak Velocity');

%Segment Avgvel
subplot(1,4,4)
ax=gca;
rw_only=0;plotflag=1;interv=0.0005;color='r';
seg_avgvel(stats_l,0,rw_only,interv,ax,plotflag,color);
color='b';
seg_avgvel(stats_nl,0,rw_only,interv,ax,plotflag,color);
xlabel('Velocity (mm/ms)')
title('Segment Avg Velocity');

%% Segment Distribution Evolution in a trajectory
% figure;
% suptitle(strcat(figure_title,'Last Segment vs Rest in Rw Trials'));
% 
% stats = get_stats_rw(stats_orig,1);
% stats = get_stats_with_trajid(stats,2);
% 
% subplot(2,2,1);
% seg_traj_evo




