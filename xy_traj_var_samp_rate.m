function xy_traj_var_samp_rate(jstruct, rec_num, trial_num, subsamp_ratio)

 t_step = 1;
 
 struct_index = rec_num;
 
 traj_x = jstruct(struct_index).traj_x;
 traj_y = jstruct(struct_index).traj_y;
 np_pairs = jstruct(struct_index).np_pairs;
 rw_onset = jstruct(struct_index).reward_onset;
 js_pairs_r = jstruct(struct_index).js_pairs_r;
 js_pairs_l = jstruct(struct_index).js_pairs_l;
 
 js_reward = jstruct(struct_index).js_reward;
 np_vect = zeros(1,length(traj_x));
 for i=1:size(np_pairs,1)
    np_vect(np_pairs(i,1):np_pairs(i,2))=4;
 end
 
 rw_vect = zeros(1,length(traj_x));
 for i=1:size(rw_onset,2)
    rw_vect(rw_onset(i):(rw_onset(i)+1000))=4;
 end
 
 js_vect_r = zeros(1,length(traj_x));
 for i=1:size(js_pairs_r,1)
    js_vect_r(js_pairs_r(i,1):js_pairs_r(i,2))=4;
 end
    
 js_vect_l = zeros(1,length(traj_x));
 for i=1:size(js_pairs_l,1)
    js_vect_l(js_pairs_l(i,1):js_pairs_l(i,2))=4;
 end
 
 traj_struct=[];
 
 start_p=[];
 k=0;
 
 if numel(js_pairs_r)>0 && numel(np_pairs)>0
    for j=1:size(js_pairs_r,1)
        if(sum(((np_pairs(:,1)-js_pairs_r(j,1))<0)&((np_pairs(:,2)-js_pairs_r(j,1))>0))>0)
            c = (np_pairs(:,1)-js_pairs_r(j,1))<0;
            start_p_temp = start_p;
            start_p = max(np_pairs(c,1));
            start_i = max(start_p,js_pairs_r(j,1)-1000);
            np_end = np_pairs((np_pairs(c,1)==start_p),2);
            stop_p = min(js_pairs_r(j,2),np_end);
            if (numel(start_p)>0) && ~isequaln(start_p_temp,start_p)                
                traj_x_t = traj_x(start_i:stop_p);
                traj_y_t = traj_y(start_i:stop_p);
                js_post = js_vect_l((js_pairs_r(j,1)):(stop_p))>2;             
                if ((traj_x(start_p)^2+traj_y(start_p)^2)^(0.5))<10
                    mag_traj = ((traj_x_t.^2+traj_y_t.^2).^(0.5));
                    k=k+1;       
                    traj_struct(k).traj_x = traj_x_t;
                    traj_struct(k).traj_y = traj_y_t;
                    traj_struct(k).js_post = js_post;
                    traj_struct(k).start_p = start_p;
                    traj_struct(k).stop_p = stop_p;
                    traj_struct(k).rw = js_reward(j);
                    traj_struct(k).th_index = 1;
                    traj_struct(k).mag = ((traj_x(start_p)^2+traj_y(start_p)^2)^(0.5));
                    traj_struct(k).max_value = find(mag_traj==max(mag_traj));
                end
            end
        end         
    end
 
    onset_index = 1;
    offset_index = 2;
    pl_index = trial_num;
    if(numel(traj_struct))>0
       plot_traj_var_samp_rate(traj_struct,t_step,onset_index,offset_index,pl_index,subsamp_ratio);
    end
 
 end

end

