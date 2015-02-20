traj_list =[];
js_time =[];
windowSize=20;
js_rew =0;
jstruct1=jstruct(58:end);
for i=1:length(jstruct1)
    x = jstruct1(i).traj_x;
    y = jstruct1(i).traj_y;
    
     x = filter(ones(1,windowSize)/windowSize,1,x);
     y = filter(ones(1,windowSize)/windowSize,1,y);
     x = x(20:end-20);
     y = y(20:end-20);
    
    np_js_s = jstruct1(i).np_js_start;
    js_r = jstruct1(i).js_pairs_r;
    js_l = jstruct1(i).js_pairs_l;
    js_reward = jstruct1(i).js_reward;
    np_js_prev=0;
    for j=1:size(js_r,1)
       if numel(np_js_s)>0 && np_js_s(j)>0  && (np_js_s(j)~=np_js_prev) %% && (js_reward(j)==1)
           
           xy_mag = (x((js_r(j,1)-200):(js_r(j,1)+500)).^2+y((js_r(j,1)-200):(js_r(j,1)+500)).^2).^(0.5);
           if xy_mag(1)<10 && xy_mag(200)<10
            traj_list = [traj_list;xy_mag];
            thresh_list = find(xy_mag(201:end)>20);
            if numel(thresh_list)>0
                min_time = min(js_r(j,2)-js_r(j,1),thresh_list(1));
            else 
               min_time = js_r(j,2)-js_r(j,1);
            end
            js_time = [js_time min_time];
            js_rew = [js_rew js_reward(j)];
           end
           np_js_prev = np_js_s(j);
           
       end  
    end
end

figure
hold on
for i=1:size(traj_list,1)
    plot(traj_list(i,100:400),'r');    
end
hold off

