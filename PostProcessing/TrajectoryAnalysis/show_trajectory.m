function [fig_handle] = show_trajectory(stats,index)

tstruct = stats.traj_struct(index);

fig_handle = figure;
subplot(3,2,1)
plot(tstruct.traj_x);
ylim([-6.35 6.35])

subplot(3,2,3)
plot(tstruct.traj_y);
ylim([-6.35 6.35])

subplot(3,2,5)
plot(tstruct.magtraj);
ylim([0 6.35])

subplot(1,2,2)
plot(tstruct.traj_x,tstruct.traj_y);
axis equal
axis square
ylim([-6.35 6.35])
xlim([-6.35 6.35])