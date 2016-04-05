function [pos_mag_l,pos_time] = posmag_pdf(stats,maxtime)

tstruct = stats.traj_struct;
pos_mag_l = zeros(1,maxtime);
pos_mag_l = zeros(numel(tstruct),maxtime);

for stlen=1:numel(tstruct)
    vel_mag = tstruct(stlen).magtraj;
    if numel(vel_mag)>0
        end_t = min(numel(vel_mag),maxtime);
        pos_mag_l(stlen,1:end_t) = vel_mag(1:end_t);
    end
    
end
pos_mag_l(pos_mag_l==0) = nan;

edges = 0:0.025:6.35;
for ii=1:maxtime
    pos_time(:,ii)=histc(pos_mag_l(:,ii),edges);
    pos_time(:,ii) = pos_time(:,ii)./sum(pos_time(:,ii));
end

figure;
%pos_time = log(pos_time);
pcolor(pos_time);
shading flat
% vel_time(isinf(vel_time))=0;
% val_1 = prctile(reshape(vel_time,1,numel(vel_time)),95);
% val_2 = prctile(reshape(vel_time,1,numel(vel_time)),15);
% caxis([val_2 val_1]);