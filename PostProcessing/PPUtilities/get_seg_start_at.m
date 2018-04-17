function [vel_out] = get_seg_start_at(stats,rad_in,rad_out,seg_order,angle_in,angle_out,ccw)
%GET_SEG_IN_SPACE Summary of this function goes here
%   Detailed explanation goes here

num_traj = numel(stats.traj_struct);
vel_out = [];

for i=1:num_traj   
    
    [~,locs_valley] = findpeaks(-1*stats.traj_struct(i).vel_mag);
    [~,locs_peak] = findpeaks(stats.traj_struct(i).vel_mag);
    traj_x = stats.traj_struct(i).traj_x;traj_y = stats.traj_struct(i).traj_y;
    vel_x = stats.traj_struct(i).vel_x;vel_y = stats.traj_struct(i).vel_y;    
        
try
    loc_ind= find(stats.traj_struct(i).magtraj(locs_valley)>2&(locs_valley>100));
    loc_ind = locs_valley(loc_ind);
    
    loc_peak_ind = find(locs_peak>loc_ind(1));
    loc_peak_ind = locs_peak(loc_peak_ind);
    
    magtraj = stats.traj_struct(i).magtraj;
    x_pos=traj_x(loc_ind(1));y_pos=traj_y(loc_ind(1));
    x_pos2=vel_x(loc_peak_ind(1));y_pos2=vel_y(loc_peak_ind(1));
    
    element_pos_angle = atan2(y_pos,x_pos);
    element_pos_angle = wrapTo360(rad2deg(element_pos_angle));
    
    
    element_peak_angle = atan2(y_pos2,x_pos2);
    element_peak_angle = wrapTo360(rad2deg(element_peak_angle));
    
    if magtraj(loc_ind(1))>rad_in && magtraj(loc_ind(1))<rad_out
        if ccw            
            if element_pos_angle>angle_in && element_pos_angle<angle_out
               vel_out = [vel_out element_peak_angle];
            end    
        else
            if element_pos_angle<angle_in || element_pos_angle>angle_out
                vel_out = [vel_out element_peak_angle];
            end
        end
    end
catch
    continue;
end
end
% 
% for i=1:num_traj
%   if numel(stats.traj_struct(i).seginfo)
%     start_vect = [stats.traj_struct(i).seginfo.start];
%     magtraj = stats.traj_struct(i).magtraj;
%     seg_index = find((magtraj(start_vect)>rad_in)&(magtraj(start_vect)<rad_out));
%     
%     if numel(seg_index)
%         element = stats.traj_struct(i).seginfo(seg_index(seg_order));
%         element_angle = atan2(element.traj_y(1),element.traj_x(1));
%         element_angle = wrapTo360(rad2deg(element_angle));
%         
%         if ccw
%             if element_angle>angle_in && element_angle<angle_out
%                 seg_out = [seg_out stats.traj_struct(i).seginfo(seg_index(seg_order))];
%             end        
%         else
%             if element_angle<angle_in || element_angle>angle_out
%                 seg_out = [seg_out stats.traj_struct(i).seginfo(seg_index(seg_order))];
%             end                    
%         end
%         
%     end
%     
%   end
% end
% 
% end