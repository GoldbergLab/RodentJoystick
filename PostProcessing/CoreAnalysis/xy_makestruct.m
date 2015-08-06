%[jstruct] = xy_makestruct(working_dir) 
%
%   xy_makestruct(working_dir) takes all the .mat files in working_dir and
%   processes all of them to create a single jstruct that stores a summary of
%   all the data from a single day:
%   the resulting jstruct is a vector where each entry is a structure with
%   numerous fields.
%
% OUTPUT:
%
%   Each jstruct(i) for all i has the following fields
%
%   filename :: name of the combined .mat file in the following format: 
%       [frameno (10)]_Box_[0-9]_[Date (9)] - number in parentheses
%       indicates number of characters
%
%   real_time :: the time (in MATLAB standard double representation of
%       time) of the beginning of the element in the jstruct.
%       (so subsequent absolute time is with real_time + onset/1000) where
%       onset is from data below
%
%   NOTE: all following fields use milliseconds as a time scale with
%   time 0 being the start of the entire block of data.
%
%   traj_x :: vector containing the x-trajectory information
%
%   traj_y :: vector containing the y-trajectory information
%
%   np_pairs :: an m x 2 array containing the pairs of (onset, offset)
%       times of the nose poke sensor. m>0
%
%   js_pairs_r :: an m x 2 array containing the pairs of (onset, offset)
%       times of the joystick touch sensor. m>=0
%
%   js_pairs_l :: an m x 2 array containing the pairs of (onset, offset)
%       times of the post touch sensor. m>=0
%
%   reward_onset :: a vector containingonset times of reward
%
%   js_reward :: vector of 1/0 indicating which deflections were
%       rewarded
%
%   np_js_start :: start of trajectory
function [jstruct] = xy_makestruct(working_dir)

working_dir_1 = strcat(working_dir,'/','comb');
filelist = dir(strcat(working_dir_1,'/*.mat'));
load(strcat(working_dir_1,'/',filelist(1).name));

fileinfo = dir(strcat(working_dir, '\', filelist(1).name(1:end-4),'.dat'));
[time_stamp] = fileinfo.datenum;
% start_frame = str2num(filelist(1).name(1:end-4));
start_frame_first = start_frame;

k = 1;
for i=1:length(filelist)         
    load(strcat(working_dir_1,'/',filelist(i).name));
    working_buff=working_buff';
    % nose pokes 
    np = sensor_on_off_times(working_buff(5,:));   
    % first touch_sense
    js_r = sensor_on_off_times(working_buff(3,:));   
    % second touch sense
    js_l = sensor_on_off_times(working_buff(4,:));
    %Laser on and off
    if size(working_buff,1)>6
        laser_on = sensor_on_off_times(working_buff(7,:));
    end
    if size(working_buff,1)>7
        [lick, maxlick] = sensor_on_off_times(working_buff(8,:));
        if maxlick > 500
            disp('lick on > 500 ms');
        end
    end
    
    %mark reward times
    reward_del = working_buff(6,:);
    reward_logical = (reward_del>0.5);
    reward_on = find(diff(reward_logical)==1);
    js_reward = zeros(1,size(js_r,1));
   
  % Mark rewarded joystick deflections
    for j=1:length(reward_on)
        if numel(js_r>0)
            a = find(((reward_on(j)-js_r(:,2))<0)&((reward_on(j)-js_r(:,1))>0));
            if numel(a)>0
                js_reward(a) = 1;
            else
                diff_a = (reward_on(j)-js_r(:,2));
                diff_a = diff_a(diff_a>0);
                a = (diff_a==min(diff_a));
                js_reward(a) = 1;
            end
        end
    end
    jstruct(i).filename = filelist(i).name;
    jstruct(i).traj_x = working_buff(1,:);
    jstruct(i).traj_y = working_buff(2,:);
    jstruct(i).np_pairs = np;
    jstruct(i).js_pairs_r = js_r;
    jstruct(i).js_pairs_l = js_l;
    jstruct(i).reward_onset = reward_on;
    jstruct(i).js_reward = js_reward;
    jstruct(i).real_time = time_stamp+(start_frame-start_frame_first)*(1/(24*60*60));
    try
        jstruct(i).laser_on = laser_on;
        jstruct(i).lick_on = lick;
    catch
    end

    % Mark nose pokes prior to start of each joystick deflection
    start_p = zeros(size(jstruct(i).js_pairs_r,1),1);
    if numel(jstruct(i).js_pairs_r)>0 && numel(jstruct(i).np_pairs)>0
        for j=1:size(jstruct(i).js_pairs_r,1)
            if(sum(((np(:,1)-js_r(j,1))<0)&((np(:,2)-js_r(j,1))>0))>0)            
                temp = (np(:,1)-js_r(j,1))<0;
                start_p(j) = max(np(temp));            
            end 
        end
    end
   
   jstruct(i).np_js_start = start_p;
end
end

% [pairs] = sensor_on_off_times(rawsens) generates a list of sensor 
% onset/offset pairs for example, pairs(1, 1) and pairs(1,2) will return 
% the times that a nosepoke came on and went off for the first nosepoke
% in the file
function [pairs, maxlen] = sensor_on_off_times(rawsens)
    pairs = []; maxlen = 0;
    sens_logic = ([0,rawsens,0]>0.5);
    k=1;
    if sum(sens_logic)>1
        sense_transition = diff(sens_logic); %this will show the transitions 
        b=sense_transition;
        flag=1;       
        for j=1:length(b)        
            if b(j)==1 && flag==1
                pairs(k,1) = j+1;
                pairs(k,2) = 0;
                flag=0;
            elseif b(j)==-1 && flag==0        
                pairs(k,2) = j-1;
                flag=1;
                time = pairs(k,2) - pairs(k,1);
                if time>maxlen; maxlen = time; end;
                k=k+1;
            end  
        end
    end
end