function [data] = get_velaccel_xy(stats)

tstruct = stats.traj_struct;

parfor ii = 1:numel(tstruct)
    
    vel_mag = tstruct(ii).vel_mag;
    traj_x = tstruct(ii).traj_x;
    traj_y = tstruct(ii).traj_y;
    
    traj_ind_x = floor(traj_x*50/6.35);
    traj_ind_y = floor(traj_y*50/6.35);
   
    vel_data{ii} = [vel_mag',traj_ind_x',traj_ind_y'];
    
end

vel_pdfout = zeros(101,101);
vel_pdfcount = zeros(101,101);

for ii = 1:numel(vel_data)
    vel_vect = vel_data{ii};
    vel_vect(:,2) = (vel_vect(:,2) + 51);
    vel_vect(:,3) = (vel_vect(:,3) + 51);
    
    inrange = (ismember(vel_vect(:,2),1:101)&ismember(vel_vect(:,3),1:101));
    vel_vect = vel_vect(inrange,:);
    
    for jj=1:size(vel_vect,1)        
         vel_pdfout(vel_vect(jj,2),vel_vect(jj,3)) = vel_pdfout(vel_vect(jj,2),vel_vect(jj,3))+vel_vect(jj,1);
         vel_pdfcount(vel_vect(jj,2),vel_vect(jj,3)) = vel_pdfcount(vel_vect(jj,2),vel_vect(jj,3))+1;
    end
end    
 

data.vel_data = vel_data';
data.vel_hist = vel_pdfout';
data.vel_count = vel_pdfcount';