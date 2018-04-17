function [tau_nl,tau_nl_rt,tau_l,tau_l_rt,fig_handle] = tau_timeevo(dirlist,varargin) 

default = {30,1};
numvarargs = length(varargin);
if numvarargs > 2
    error('too many arguments (> 3), only 1 required and 2 optional.');
end
[default{1:numvarargs}] = varargin{:};
[dist,save_flag] = default{:};
tau_l = [];
tau_nl = [];
tau_l_rt = [];
tau_nl_rt = [];
edges = 50:50:1000;
windowSize = 200;
for i = 1:length(dirlist)
%   i
    [pathstr,name,ext] = fileparts(dirlist(i).name);
    [pathstr_rule,name,ext] = fileparts(pathstr);        
    contingency_angle = strsplit(name,'_');
        
    out_thresh(i) = str2num(contingency_angle{2});
    hold_time(i) = str2num(contingency_angle{3});
    hold_thresh(i) = str2num(contingency_angle{4});
    angle1(i) = str2num(contingency_angle{5});
    angle2(i) = str2num(contingency_angle{6});
    angle3(i) = str2num(contingency_angle{7});
    angle4(i) = str2num(contingency_angle{8});

    try        
      stats = load_stats(dirlist(i),0,1,0,'traj_struct','real_time');
      stats = get_stats_with_len(stats,50);  
      [~,tau_l_t,tau_l_rtime,~] = tau_theta(stats,(hold_thresh(i))*(6.35/100),(out_thresh(i))*(6.35/100),1,0,[],0);      
      [~,tau_nl_t,tau_nl_rtime,~] = tau_theta(stats,(hold_thresh(i))*(6.35/100),(out_thresh(i))*(6.35/100),2,0,[],0);      
    catch
        tau_l_t=[];tau_l_rtime=[];
        tau_nl_t=[];tau_nl_rtime=[];
    end
 

    tau_l = [tau_l tau_l_t];
    tau_l_rt = [tau_l_rt tau_l_rtime];
    tau_nl = [tau_nl tau_nl_t];
    tau_nl_rt = [tau_nl_rt tau_nl_rtime];
    
    tau_index_nl(i) = numel(tau_nl);
    tau_index_l(i) = numel(tau_l);
end

offset_l = floor(min(tau_l_rt));
offset_nl = floor(min(tau_nl_rt));

tau_l_rt = tau_l_rt - offset_l;
tau_nl_rt = tau_nl_rt - offset_nl;

if isempty(tau_l_rt)
    end_point = ceil(max(tau_nl_rt));    
else
    end_point = ceil(max(max(tau_l_rt),max(tau_nl_rt)));
end

fig_handle = figure;

hold on

for i = 1:end_point  
    h(i+2) = area([(i-0.5),i],[1000,1000]);
    set(h(i+2),'FaceColor',[0 0.75 0.75]);
end

h2 = plot(tau_nl_rt,tau_nl,'ko','MarkerSize',4);
%set(h2,'MarkerFaceColor','k');

h1 = plot(tau_l_rt,tau_l,'ro','MarkerSize',4);
%set(h1,'MarkerFaceColor','r');

axis([0 end_point 0 1000]);



