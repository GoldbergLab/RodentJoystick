function t_stats = traj_stat(np,js,working_dir)
 filelist=dir(strcat(working_dir,'/*.mat'));
 
for i=1:size(np,1)
 load(strcat(working_dir,'/',filelist(i).name));
         
 for j=1:size(np,2)
     if np(i,j,1)>0
      c = (js(i,:)>np(i,j,1) & js(i,:)<np(i,j,2));
      if sum(c)>0
       traj_x =  working_buff(1,np(i,j,1):np(i,j,2))-working_buff(1,end);
       traj_y =  working_buff(2,np(i,j,1):np(i,j,2))-working_buff(2,end);
       traj_mag = traj_x.^2 + traj_y.^2;
       t_stats(i,j) = max(traj_mag.^(0.5));
      end
     end
 end
end
t_stats = sparse(t_stats);