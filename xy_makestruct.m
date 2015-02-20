function [jstruct] = xy_makestruct(working_dir)

working_dir_1 = strcat(working_dir,'/','comb');
filelist = dir(strcat(working_dir_1,'/*.mat'));
load(strcat(working_dir_1,'\',filelist(1).name));

fileinfo = dir(strcat(working_dir, '\', filelist(1).name(1:end-4),'.dat'));
time_stamp = fileinfo.datenum;
start_frame_first = start_frame;

for i=1:length(filelist)         
    load(strcat(working_dir_1,'/',filelist(i).name));
    working_buff=working_buff';
    
    %% nose pokes 
    c=[];
    nose_poke = working_buff(5,:);
    np_logical = (nose_poke>0.5);
    l=1;
    if sum(np_logical)>1
        np_transition = diff(np_logical); %this will show the transitions 
        b=np_transition;
        flag=1;       
        for j=1:length(b)        
            if b(j)==1 && flag==1
                c(l,1) = j+1;
                c(l,2) = 0;
                flag=0;
            elseif b(j)==-1 && flag==0        
                c(l,2) = j-1;
                flag=1;
                l=l+1;
            end  
        end
    end
   
    %% first touch_sense
    touch_sense = working_buff(3,:);
    touch_logical = (touch_sense>0.5);
    m=1;
    d=[];
    if sum(touch_logical)>1
        tch_transition = diff(touch_logical); %this will show the transitions 
        b=tch_transition;
        flag=1;
        for j=1:length(b)        
            if b(j)==1 && flag==1
                d(m,1) = j+1;
                d(m,2) = 0;
                flag=0;
            elseif b(j)==-1 && flag==0        
                d(m,2) = j-1;
                flag=1;
                m=m+1;
            end  
        end
    end
    
    %% second_touch sense
    touch_sense_2 = working_buff(4,:);
    touch_logical = (touch_sense_2>0.5);
    m=1;
    e=[];
    if sum(touch_logical)>1
        tch_transition = diff(touch_logical); %this will show the transitions 
        b=tch_transition;
        flag=1;
        for j=1:length(b)        
            if b(j)==1 && flag==1
                e(m,1) = j+1;
                e(m,2) = 0;
                flag=0;
            elseif b(j)==-1 && flag==0        
                e(m,2) = j-1;
                flag=1;
                m=m+1;
            end  
        end
    end
   
   
   
    reward_del = working_buff(6,:);
    reward_logical = (reward_del>0.5);
    reward_on = find(diff(reward_logical)==1);
    js_reward = zeros(1,size(d,1));
   
  %% Mark rewarded joystick deflections
   
    for j=1:length(reward_on)
        if numel(d>0)
            a = find(((reward_on(j)-d(:,2))<0)&((reward_on(j)-d(:,1))>0));
            if numel(a)>0
                js_reward(a) = 1;
            else
                diff_a = (reward_on(j)-d(:,2));
                diff_a = diff_a(diff_a>0);
                a = (diff_a==min(diff_a));
                js_reward(a) = 1;
            end
        end
    end
%    for j=1:size(d,1)
%     a = find(((reward_on-d(j,2))<300)&((reward_on-d(j,1))>0));
%     if numel(a)>0
%         js_reward(j)=a(1);
%     else
%         js_reward(j)=0;
%     end
%    end
%       
    jstruct(i).filename = filelist(i).name;
    jstruct(i).path = dir;
    jstruct(i).traj_x = working_buff(1,:);
    jstruct(i).traj_y = working_buff(2,:);
    jstruct(i).np_pairs = c;
    jstruct(i).js_pairs_r = d;
    jstruct(i).js_pairs_l = e;
    jstruct(i).reward_onset = reward_on;
    jstruct(i).js_reward = js_reward;
    jstruct(i).real_time = time_stamp+(start_frame-start_frame_first)*(1/(24*60*60));

      % Mark nose pokes prior to start of each joystick deflection
    start_p = zeros(size(jstruct(i).js_pairs_r,1),1);
    if numel(jstruct(i).js_pairs_r)>0 && numel(jstruct(i).np_pairs)>0
        for j=1:size(jstruct(i).js_pairs_r,1)
            if(sum(((c(:,1)-d(j,1))<0)&((c(:,2)-d(j,1))>0))>0)            
                temp = (c(:,1)-d(j,1))<0;
                start_p(j) = max(c(temp));            
            end 
        end
    end
   
   jstruct(i).np_js_start = start_p;
end