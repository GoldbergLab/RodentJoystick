function jstruct_stats = xy_getstats(jstruct,index)
%Count the Number of nosepokes
%Count the Number of JS (onsets and offsets)
%Count the Number of JS_post (onsets and offsets)
%Count the Number of Pellets dispensed
np_count=0;
js_r_count = 0;
js_l_count = 0;
pellet_count = 0;
trialnum=0;
for i=1:length(jstruct)
    np_count = np_count + size(jstruct(i).np_pairs,1);
    js_r_count = js_r_count + size(jstruct(i).js_pairs_r,1);
    js_l_count = js_l_count + size(jstruct(i).js_pairs_l,1);
    pellet_count = pellet_count + numel(jstruct(i).reward_onset);
end
jstruct_stats.np_count = np_count;
jstruct_stats.js_r_count = js_r_count;
jstruct_stats.js_l_count = js_l_count;
jstruct_stats.pellet_count = pellet_count;
    
% Get Distribution of NP_JS
list=[];
for i=1:length(jstruct)
    if (numel(jstruct(i).np_pairs)>0 && numel(jstruct(i).js_pairs_r>0))
        for j=1:size(jstruct(i).np_pairs,1)
            %keep adding each 
            list = [list;(jstruct(i).js_pairs_r(:,1)-jstruct(i).np_pairs(j,1))];
        end
    end
end
jstruct_stats.np_js = list(find((list>-10000)&(list<10000)));

% Get Distribution of NP_JSPost
list=[];
for i=1:length(jstruct)
    if (numel(jstruct(i).np_pairs)>0 && numel(jstruct(i).js_pairs_l>0))
        for j=1:size(jstruct(i).np_pairs,1)
            list = [list;(jstruct(i).js_pairs_l(:,1)-jstruct(i).np_pairs(j,1))];
        end
    end
end

jstruct_stats.np_js_post = list(find((list>-10000)&(list<10000)));

% Get PDF of trajectories
traj_struct = [];
traj_pdf_jsoffset = zeros(100,100);
traj_pdf_thindex = zeros(100,100);
k=0;
 
for struct_index=1:length(jstruct)
    %% initialize   
    traj_x = jstruct(struct_index).traj_x;
    traj_y = jstruct(struct_index).traj_y;
    np_pairs = jstruct(struct_index).np_pairs;
    rw_onset = jstruct(struct_index).reward_onset;
    js_pairs_r = jstruct(struct_index).js_pairs_r;
    js_pairs_l = jstruct(struct_index).js_pairs_l;
    js_reward = jstruct(struct_index).js_reward;  
    %% Process, and develop traj_struct
    start_temp =0;
    onset_ind = 1;
    if numel(js_pairs_r)>0 && numel(np_pairs)>0 && numel(js_pairs_l)>0
       for j=1:size(js_pairs_r,1)
           if(sum(((np_pairs(:,1)-js_pairs_r(j,1))<0)&((np_pairs(:,2)-js_pairs_r(j,1))>0))>0) 
               % If the Joystick is in between an nosepoke onset and a nosepoke offset pair
              if (sum(((js_pairs_l(:,1)-js_pairs_r(j,1))<0)&((js_pairs_l(:,2)-js_pairs_r(j,1))>0))>0) 
                    % And if the Joystick is in between an post-touch onset and offset pair
                    
                    % This is now a valid trial
                    
                    np_js_temp = (np_pairs(:,1)-js_pairs_r(j,1))<0; 
                    %set of nose poke onsets preceding the js onset
                    start_p = max(np_pairs(np_js_temp,1));
                    %Nose poke before the Joystick touch is the most recent
                    %touch 
                    np_end = np_pairs((np_pairs(np_js_temp,1)==start_p),2); 
                    %corresponding nose poke offset
                    
                    %count as new trial only if prev joystick attempt
                    %wasn't on the same nosepoke onset offset
                    if (start_p ~= start_temp)                   
                     trialnum = trialnum+1;
                    end
                    start_temp = start_p;
                    
                    jt_js_temp = (js_pairs_l(:,1)-js_pairs_r(j,1))<0; 
                    %set of post touch onsets preceding the js onset
                    post_start =  max(js_pairs_l(jt_js_temp,1)); 
                    % Post-touch onset
                    post_end = js_pairs_l((js_pairs_l(jt_js_temp,1)==post_start),2); 
                    % Post-touch offset
                    stop_p = min([js_pairs_r(j,2),np_end,post_end]); 
                    %End of trajectory is min of nosepoke ending,joystick touch offset, or post offset.
                    start_i = max((js_pairs_r(j,1)-1000),start_p); 
                    traj_x_t1 = traj_x(start_p:stop_p);
                    traj_y_t1 = traj_y(start_p:stop_p);
                    
                    traj_x_t = traj_x(js_pairs_r(j,1):stop_p);
                    traj_y_t = traj_y(js_pairs_r(j,1):stop_p);
                    
                    if ((traj_x(start_p)^2+traj_y(start_p)^2)^(0.5))<50
                     
                     k=k+1;   
                     mag_traj = ((traj_x_t.^2+traj_y_t.^2).^(0.5));  
                     traj_struct(k).traj_x = traj_x_t;
                     traj_struct(k).traj_y = traj_y_t;
                     traj_struct(k).js_onset = js_pairs_r(j,1);
                     traj_struct(k).start_p = start_p;
                     traj_struct(k).stop_p = stop_p;
                     traj_struct(k).rw = js_reward(j);
                     traj_struct(k).rw_onset = 0;
                     if traj_struct(k).rw == 1
                        traj_struct(k).rw_onset = rw_onset(onset_ind)-js_pairs_r(j,1);
                        onset_ind = onset_ind + 1;
                     end
                     traj_struct(k).magtraj = mag_traj;
                     traj_struct(k).magatnp = ((traj_x(start_p)^2+traj_y(start_p)^2)^(0.5));
                     traj_struct(k).max_value_ind = find(mag_traj==max(mag_traj));
                     traj_struct(k).max_value = max(mag_traj);
                     traj_struct(k).posttouch = stop_p-js_pairs_r(j,1);
                        
                    end
                end    
           end
           
       end
   end

end



jstruct_stats.traj_pdf_jsoffset = traj_pdf_jsoffset./sum(sum(traj_pdf_jsoffset));
jstruct_stats.traj_pdf_thindex = traj_pdf_thindex./sum(sum(traj_pdf_thindex));
jstruct_stats.numtraj = k;
jstruct_stats.traj_struct = traj_struct;
jstruct_stats.trialnum = trialnum;
jstruct_stats.srate = jstruct_stats.pellet_count/trialnum;
% Get Theta Distributions
