function [fraction,laser_success,nonlaser_success]=get_rewardrate_diff(tstruct)

 rw_laser=0;
 rw_nonlaser=0;
 trial_laser =0;
 trial_nonlaser=0;

for ii=1:length(tstruct)
 
 if tstruct(ii).laser == 1
     trial_laser = trial_laser+1;
     if tstruct(ii).rw == 1
     rw_laser = rw_laser+1;
     end
 else
     trial_nonlaser = trial_nonlaser+1;
     if tstruct(ii).rw == 1
     rw_nonlaser = rw_nonlaser+1;
     end
 end
 
end

laser_success = rw_laser/trial_laser;
nonlaser_success = rw_nonlaser/trial_nonlaser;
fraction = laser_success/nonlaser_success;
