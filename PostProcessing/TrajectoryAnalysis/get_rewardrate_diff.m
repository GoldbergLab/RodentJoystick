function [fraction,laser_success,nonlaser_success]=get_rewardrate_diff(tstruct)

 stats.traj_struct = tstruct;
 stats = get_stats_with_len(stats,50);
 
 stats_nl = get_stats_with_trajid(stats,2);
 stats_l = get_stats_with_trajid(stats,1);

 stats_nl_r = get_stats_rw(stats_nl,1);
 stats_l_r = get_stats_rw(stats_l,1);
 
 numel_laser_trials = numel(stats_l.traj_struct);
 numel_control_trials = numel(stats_nl.traj_struct);
 
 rw_control_trials = numel(stats_nl_r.traj_struct);
 rw_laser_trials = numel(stats_l_r.traj_struct);
 
%  rw_laser=0;
%  rw_nonlaser=0;
%  trial_laser =0;
%  trial_nonlaser=0;
% 
% for ii=1:length(tstruct)
%  
%  if tstruct(ii).laser == 1
%      trial_laser = trial_laser+1;
%      if tstruct(ii).rw == 1
%      rw_laser = rw_laser+1;
%      end
%  else
%      trial_nonlaser = trial_nonlaser+1;
%      if tstruct(ii).rw == 1
%      rw_nonlaser = rw_nonlaser+1;
%      end
%  end
%  
% end

laser_success = rw_laser_trials/numel_laser_trials;
nonlaser_success = rw_control_trials/numel_control_trials;
fraction = laser_success/nonlaser_success;
