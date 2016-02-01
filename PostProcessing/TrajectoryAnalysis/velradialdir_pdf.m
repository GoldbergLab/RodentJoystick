function [theta_vel] = velradialdir_pdf(stats,maxtime)

tstruct = stats.traj_struct;
theta_vel = zeros(1,maxtime);
for stlen=1:numel(tstruct)
    
    vel_x = tstruct(stlen).vel_x;
    vel_y = tstruct(stlen).vel_y;
    
    acc_x = [0 diff(vel_x)];
    acc_y = [0 diff(vel_y)];
    
    acc = [acc_x',acc_y'];
    pos = [tstruct(stlen).traj_x',tstruct(stlen).traj_y'];
    if numel(vel_x)>0
        
     dot_n = diag(acc*pos');
     dot_d = (diag(acc*acc').*diag(pos*pos')).^(0.5);
     
     val = dot_n./dot_d;
     theta_vel(stlen,1:length(val)) = acos(val)'  ;
    end
    
end
theta_vel(theta_vel==0) = nan;
theta_vel = theta_vel*(180/pi);

edges = 0:20:180;
for ii=1:maxtime
    vel_time(:,ii)=histc(theta_vel(:,ii),edges);
    vel_time(:,ii) = vel_time(:,ii)./sum(vel_time(:,ii));
end

figure;
pcolor((vel_time));
shading flat

figure
stairs(nanmedian(theta_vel));