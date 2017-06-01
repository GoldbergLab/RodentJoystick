function [angle_out] = update_contingency(dirlist,varargin)

numvarargs = length(varargin);
if numvarargs > 3
    error('too many arguments (> 4), only 1 required and 3 optional.');
end

default = {0.15,0,0};

[default{1:numvarargs}] = varargin{:};
[rew_rate,split,def_dir] = default{:};
no_prev_cont = 0;
%% Get Path information for the Box
working_dir = dirlist(1).name;
dir_elements = strsplit(working_dir,'\');

cont_string = strsplit(dir_elements{numel(dir_elements)-2},'_');
box_id = strcat(cont_string(1),'_',cont_string(2));
date_data = datenum(dir_elements{7},'mmddyy');

write_contingency_dir = dir_elements(1);
for i=2:(numel(dir_elements)-4)
    write_contingency_dir = strcat(write_contingency_dir,'\',dir_elements(i));
end
write_contingency_dir = strcat(write_contingency_dir,'\','contingency_update','\',box_id);
write_contingency_path = strcat(write_contingency_dir,'\',datestr(date_data+1,'mmddyy'),'.txt');

if exist(write_contingency_dir{1}, 'dir') == 0
    mkdir(write_contingency_dir{1});
end



%% Get prev contingency
try
    read_contingency_dir = strcat(write_contingency_dir,'\',datestr(date_data,'mmddyy'),'.txt');
    fileID = fopen(read_contingency_dir{1});
    prev_cont = textscan(fileID,'%d %d %d %d %d %d %d %d');
    fclose(fileID);
    prev_cont = [prev_cont{:}];
catch
    no_prev_cont = 1;
end
%% Check if any contingency updating is required
if def_dir == 2
    if ~no_prev_cont
        angle_out = prev_cont;
    else
        angle_out = [0 360 1 0 360 1];
    end
else
    %% Calculate new Contingency
    stats_ts = load_stats(dirlist(1),0,1,0);
    stats_l = get_stats_with_trajid(stats_ts,1);
    stats_nl = get_stats_with_trajid(stats_ts,2);
    
    if split > 0
        if split==1
            l_dir = 0;
            nl_dir = 1;
        elseif split==2
            l_dir = 1;
            nl_dir = 0;
        end
    else
        l_dir = def_dir;
        nl_dir = def_dir;
    end
    
    [angle_l,rw_fail_l] = get_contingency_change(stats_l,rew_rate,l_dir,0);
    [angle_nl,rw_fail_nl] = get_contingency_change(stats_nl,rew_rate,nl_dir,0); 
    
    if rw_fail_l
        if ~no_prev_cont
            angle_l = prev_cont(4:6);
        else
            angle_l(4:6) = [0 360 1];
        end
    elseif rw_fail_nl
        if ~no_prev_cont
            angle_nl = prev_cont(1:3);
        else
            angle_nl = [0 360 1];
        end
    end
            
    angle_l(angle_l(1:2)<60&angle_l(1:2)>0) = angle_l(angle_l(1:2)<60&angle_l(1:2)>0) + 360;
    angle_nl(angle_nl(1:2)<60&angle_nl(1:2)>0) = angle_nl(angle_nl(1:2)<60&angle_nl(1:2)>0) + 360;
    if ~no_prev_cont
        prev_cont((prev_cont([1 2 4 5])<60)&(prev_cont([1 2 4 5])>0)) = prev_cont((prev_cont([1 2 4 5])<60)&(prev_cont([1 2 4 5])>0)) +360; 
    end
    %% Determine which way the animal is being pushed,
    if split == 0
        %Then make sure the animal isn't being pushed in the opposite direction
        if ~no_prev_cont
            temp1 = sortrows([angle_nl(1:3);prev_cont(1:3)],-1);
            if def_dir == 1
                angle_nl(1:3) = temp1(1,:);
            elseif def_dir == 0
                angle_nl(1:3) = temp1(2,:);
            end
        end
        angle_out = [angle_nl angle_nl split def_dir];
        
    elseif split == 1
        if ~no_prev_cont
            temp1 = sortrows([angle_nl(1:3);prev_cont(1:3)],-1);
            temp2 = sortrows([angle_l(1:3);prev_cont(4:6)],1);
            angle_nl = temp1(1,:);
            angle_l = temp2(1,:);
        end
        angle_out = [angle_nl angle_l split def_dir];
    elseif split == 2
        if ~no_prev_cont
            temp1 = sortrows([angle_nl(1:3);prev_cont(1:3)],-1);
            temp2 = sortrows([angle_l(1:3);prev_cont(4:6)],1);
            angle_nl(1:3) = temp1(2,:);
            angle_l(1:3) = temp2(2,:);
        end
        angle_out = [angle_nl angle_l split def_dir];
    end
    
    angle_out(angle_out>360) = angle_out(angle_out>360) - 360;
end
%% Write New Contingency
fileID = fopen(write_contingency_path{1},'w');
fprintf(fileID,'%d ',angle_out);
fclose(fileID);