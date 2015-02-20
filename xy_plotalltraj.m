function xy_plotalltraj(jstruct)
 figure
 cla
 axis manual
 total=0;
 hold on
 thresh = 0.2;
%  x = thresh*cosd(0:1:360);
%  y = thresh*sind(0:1:360);
%  plot(x,y,'k','LineWidth',2);

axis([-0.4 0.4 -0.4 0.4])
 
 for struct_index = 1:length(jstruct)
 windowSize = 20;
 thresh = 0.2;
 t_step = 5;
 
 traj_x = jstruct(struct_index).traj_x;
 traj_y = jstruct(struct_index).traj_y;
 np_pairs = jstruct(struct_index).np_pairs;
 rw_onset = jstruct(struct_index).reward_onset;
 js_pairs_r = jstruct(struct_index).js_pairs;
 
 js_reward = jstruct(struct_index).js_reward;
 
 
    traj_x = filter(ones(1,windowSize)/windowSize,1,traj_x);
    traj_y = filter(ones(1,windowSize)/windowSize,1,traj_y);
    traj_x = traj_x(20:end-20);
    traj_y = traj_y(20:end-20);
    
 
 xmin = 1/10000;
 xmax = length(traj_x)/10000;
 ymin = 0;
 ymax = 5;
 
 x_cen=2.53;%handles.working_buff(1,end);
 y_cen=2.52;%handles.working_buff(2,end);

 np_vect = zeros(1,length(traj_x));
 for i=1:size(np_pairs,1)
    np_vect(np_pairs(i,1):np_pairs(i,2))=4;
 end
 
 rw_vect = zeros(1,length(traj_x));
 for i=1:size(rw_onset,2)
    rw_vect(rw_onset(i):(rw_onset(i)+1000))=4;
 end
 
 js_vect = zeros(1,length(traj_x));
 for i=1:size(js_pairs_r,1)
    js_vect(js_pairs_r(i,1):js_pairs_r(i,2))=4;
 end
 

 
 hold on
 
%  x = thresh*cosd(0:1:360);
%  y = thresh*sind(0:1:360);
 
 traj_struct=[];
 
 start_p=[];
 k=0;
 
 if numel(js_pairs_r)>0 && numel(np_pairs)>0
     for j=1:size(js_pairs_r,1)
         %check if js movement happens in between nosepokes
         if(sum(((np_pairs(:,1)-js_pairs_r(j,1))<0)&((np_pairs(:,2)-js_pairs_r(j,1))>0))>0)
             c = (np_pairs(:,1)-js_pairs_r(j,1))<0;
             start_p_temp = start_p;
             start_p = max(np_pairs(c,1));
             stop_p = np_pairs((np_pairs(c,1)==start_p),2);
             if (numel(start_p)>0 && ~isequaln(start_p_temp,start_p))                
                 traj_x_t = traj_x((start_p):(js_pairs_r(j,2)))-x_cen;
                 traj_y_t = traj_y((start_p):(js_pairs_r(j,2)))-y_cen;
                                   
                 if ((traj_x_t(1)^2+traj_y_t(1)^2)^(0.5))<0.05
                     mag_traj = ((traj_x_t.^2+traj_y_t.^2).^(0.5));
                     above_thresh=mag_traj>thresh;
                     a=find(above_thresh);
                     if numel(a)<1
                         a = find(mag_traj==max(mag_traj));
                     end
                       k = k+1;
                       total = total+1;
                       traj_struct(k).traj_x = traj_x_t;
                       traj_struct(k).traj_y = traj_y_t;
                       traj_struct(k).start_p = start_p;
                       traj_struct(k).stop_p = stop_p;
                       traj_struct(k).rw = js_reward(j);
                       traj_struct(k).th_index = a(1);
                       traj_struct(k).max_value = find(mag_traj==max(mag_traj));
                 end
             end
         end         
     end
 end
 
 
 
     t_step = 10*t_step;
 
 
 
 
 onset_index = 1;
 offset_index = 2;
 for pl_index=1:k
  if(numel(traj_struct))>0 
 plot_traj_xy(traj_struct,t_step,onset_index,offset_index,pl_index,[]);
 end
 end
 if mod(total,10)==0
   total;
  
 end
 end
%  end
 total