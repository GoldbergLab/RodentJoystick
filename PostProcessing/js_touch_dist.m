targ_time=200;
targ_reward = 0.25;
k=1;
traj_struct=stats.traj_struct;
for i=1:length(traj_struct)
 if traj_struct(i).posttouch>targ_time
    dist_distri(k) = max(traj_struct(i).magtraj(1:targ_time));
    k=k+1;
 end
end
time_success = length(dist_distri)/length(traj_struct);
c = histc(dist_distri,0:1:100);
success_prob = cumsum(c)/sum(c);
targ_dist = find(success_prob>(targ_reward/time_success));


%figure(1); hist_int = 5; hold on;
%c = histc(dist_distri,0:hist_int:100);
%xlabel('Joystick Distance');
%ylabel('Count');
%stairs(0:hist_int:100, c);
set_dist = targ_dist(1);
disp(strcat('set_threshold:   ', num2str(set_dist)));