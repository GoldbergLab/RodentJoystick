function [vel_mag_l] = velmag_pdf(stats,maxtime)

tstruct = stats.traj_struct;
vel_mag_l = zeros(numel(tstruct),maxtime);

for stlen=1:numel(tstruct)
  
    vel_mag = tstruct(stlen).vel_mag;
    max_index = min(maxtime,numel(vel_mag));    
    vel_mag_l(stlen,1:max_index) = vel_mag(1:max_index);
    
end

vel_mag_l(vel_mag_l==0) = nan;

edges = 0:0.0025:0.2;
for ii=1:maxtime
    vel_time(:,ii)=histc(vel_mag_l(:,ii),edges);
    vel_time(:,ii) = vel_time(:,ii)./sum(vel_time(:,ii));
end

figure;
pcolor(log(vel_time));
shading flat

