function [theta_vel] = veldir_pdf(stats,maxtime)

tstruct = stats.traj_struct;
theta_vel = zeros(1,maxtime);
for stlen=1:numel(tstruct)
    
    vel_x = tstruct(stlen).vel_x;
    vel_y = tstruct(stlen).vel_y;
    if numel(vel_x)>0
    [theta_vel(stlen,1:numel(vel_x)),rho] = cart2pol(vel_x,vel_y);
    end
    
end
theta_vel(theta_vel==0) = nan;
theta_vel = theta_vel*(180/pi);

edges = -180:10:180;
for ii=1:maxtime
    vel_time(:,ii)=histc(theta_vel(:,ii),edges);
    vel_time(:,ii) = vel_time(:,ii)./sum(vel_time(:,ii));
end

figure;
pcolor(vel_time);
shading flat