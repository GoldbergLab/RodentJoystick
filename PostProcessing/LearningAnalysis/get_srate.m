function [s_struct] = get_srate(tstruct)


laser_trials = 0;
laser_trials_s = 0;
catch_trials = 0;
catch_trials_s = 0;


for tlen=1:length(tstruct)
   if tstruct(tlen).laser
       laser_trials = laser_trials+1;
       if tstruct(tlen).rw
           laser_trials_s = laser_trials_s+1;
       end
   else
       catch_trials = catch_trials +1;
       if tstruct(tlen).rw
           catch_trials_s = catch_trials_s+1;
       end
   end
end

total_s = (laser_trials_s+catch_trials_s)/(laser_trials+catch_trials);

try
laser_s = laser_trials_s/laser_trials;
catch
    laser_s=0;
end
try
catch_s = catch_trials_s/catch_trials;
catch
    catch_s=0;
end

try
    ratio_l_nl = laser_s/catch_s;
catch
    ratio_l_nl = 0;
end

s_struct.total = total_s; 
s_struct.laser_succ = laser_s;
s_struct.catch_succ = catch_s;
s_struct.ratio = ratio_l_nl;

end