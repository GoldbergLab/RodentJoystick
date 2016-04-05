function [vel_mag_l] = velmag_pdf(stats,maxtime)

tstruct = stats.traj_struct;
vel_mag_l = zeros(1,maxtime);
for stlen=1:numel(tstruct)
    vel_mag = tstruct(stlen).vel_mag;
    if numel(vel_mag)>0
        vel_mag_l(stlen,1:numel(vel_mag)) = vel_mag;
    end
    
end
vel_mag_l(vel_mag_l==0) = nan;

edges = 0:0.0025:0.05;
for ii=1:maxtime
    vel_time(:,ii)=histc(vel_mag_l(:,ii),edges);
    vel_time(:,ii) = vel_time(:,ii)./sum(vel_time(:,ii));
end

figure;
pcolor(log(vel_time));
shading flat

