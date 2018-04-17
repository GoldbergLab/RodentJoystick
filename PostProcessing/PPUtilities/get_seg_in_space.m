function [seg_out] = get_seg_in_space(stats,rad_in,rad_out,seg_order)
%GET_SEG_IN_SPACE Summary of this function goes here
%   Detailed explanation goes here

num_traj = numel(stats.traj_struct);
seg_out = [];

for i=1:num_traj
  if numel(stats.traj_struct(i).seginfo)
    start_vect = [stats.traj_struct(i).seginfo.start];
    stop_vect = [stats.traj_struct(i).seginfo.stop];
    mag_index = find((stats.traj_struct(i).magtraj>rad_in)&(stats.traj_struct(i).magtraj<rad_out));
    
    if numel(mag_index)
        seg_index_l=[];
      for j = 1:numel(mag_index)
        seg_index  = find((mag_index(j)>start_vect)&(mag_index(j)<stop_vect));
        seg_index_l = [seg_index_l seg_index];
      end
      
      seg_index_uq = unique(seg_index_l);
      seg_out = [seg_out stats.traj_struct(i).seginfo(seg_index_uq(seg_order))];    
    end
  end  
end


end