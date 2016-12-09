function [] = create_ppt_report(dirlist)
warning('off','all');

stats = load_stats(dirlist,0,0);
stats_ts = load_stats(dirlist,0,1);
pptname = strcat(dirlist(1).name,'\analysis.pptx');

stats_ts = get_stats_with_len(stats_ts,50);
stats_ts = get_stats_startatzero(stats_ts);

stats = get_stats_with_len(stats,50);
stats = get_stats_startatzero(stats);

[pathstr,name,ext] = fileparts(dirlist(1).name);
[pathstr_rule,name,ext] = fileparts(pathstr);
contingency = strsplit(name,'_');



out_thresh = str2num(contingency{2});
hold_time = str2num(contingency{3});
hold_thresh = str2num(contingency{4});
angle1 = str2num(contingency{5});
angle2 = str2num(contingency{6});
angle3 = str2num(contingency{7});
angle4 = str2num(contingency{8});

clear fig_handle;
try
    fig_handle = [];
    [~,~,fig_handle(1)] = np_js_distribution(dirlist,40,1,1,1,1,1,[]);
    [~,~,fig_handle(2)] = np_post_distribution(dirlist,40,1,1,1,1,[]);
    
    fig_dir = strcat(dirlist(1).name,'/Analysis_fig/np_dists/');
    if ~exist(fig_dir,'dir')
        mkdir(fig_dir);
    end
    for i=1:2
        savefig(fig_handle(i),strcat(fig_dir,num2str(i)));
    end
    
    exportfigpptx(pptname,fig_handle,[1 2]);
    close(fig_handle);
catch e
    display(strcat('Failed np_js distribution: ',e.message));
    close(fig_handle);
end


clear fig_handle;
try
    fig_handle = [];
    [~,~,fig_handle(1)] = activity_heat_map(stats, 1, [2 99], [],[1 100], 1, 0, 1);
    [~,~,fig_handle(2)] = activity_heat_map(stats, 1, [2 99], [],[1 100], 2, 0, 1);
    [~,~,fig_handle(3)] = activity_heat_map(stats, 1, [2 99], [],[1 100], 3, 0, 1);
    
    fig_dir = strcat(dirlist(1).name,'/Analysis_fig/activity_heatmaps/');
    if ~exist(fig_dir,'dir')
        mkdir(fig_dir);
    end
    for i=1:3
        savefig(fig_handle(i),strcat(fig_dir,num2str(i)));
    end
    
    exportfigpptx(pptname,fig_handle,[1 3]);
    close(fig_handle);
catch e
    display(strcat('Failed activity plot distribution: ',e.message));
    close(fig_handle);
end


clear fig_handle;
try
    fig_handle = [];
    [~,~,fig_handle(1)] = activity_heat_map(stats_ts, 1, [2 99], [],[1 100], 1, 0, 1);
    [~,~,fig_handle(2)] = activity_heat_map(stats_ts, 1, [2 99], [],[1 100], 2, 0, 1);
    [~,~,fig_handle(3)] = activity_heat_map(stats_ts, 1, [2 99], [],[1 100], 3, 0, 1);
    
    fig_dir = strcat(dirlist(1).name,'/Analysis_fig/activity_heatmaps_ts/');
    if ~exist(fig_dir,'dir')
        mkdir(fig_dir);
    end
    for i=1:3
        savefig(fig_handle(i),strcat(fig_dir,num2str(i)));
    end
    
    exportfigpptx(pptname,fig_handle,[1 3]);
    close(fig_handle);
catch e
    display(strcat('Failed activity plot distribution "to stop": ',e.message));
    close(fig_handle);
end

clear fig_handle;
try
    fig_handle = [];
    [~,fig_handle(1)] = multi_anglethreshcross(dirlist,hold_thresh,out_thresh,0,0,10,[],1,0,2);
    
    fig_dir = strcat(dirlist(1).name,'/Analysis_fig/anglethreshcross/');
    if ~exist(fig_dir,'dir')
        mkdir(fig_dir);
    end
    for i=1:1
        savefig(fig_handle(i),strcat(fig_dir,num2str(i)));
    end
    
    exportfigpptx(pptname,fig_handle,[1 1]);
    close(fig_handle);
catch e
    display(strcat('Failed angle threshold crossing distribution: ',e.message));
end


clear fig_handle;
try
    fig_handle = [];
    [~,fig_handle(1)] = multi_tau_theta(dirlist,hold_thresh*(6.35/100),out_thresh*(6.35/100),0,0,[],1,0,2);
    [~,fig_handle(2)] = multi_tau_theta(dirlist,hold_thresh*(6.35/100),out_thresh*(6.35/100),0,0,[],1,0,3);
    
    fig_dir = strcat(dirlist(1).name,'/Analysis_fig/tau_theta/');
    if ~exist(fig_dir,'dir')
        mkdir(fig_dir);
    end
    for i=1:2
        savefig(fig_handle(i),strcat(fig_dir,num2str(i)));
    end
    
    exportfigpptx(pptname,fig_handle,[1 2]);
    close(fig_handle);
catch e
    display('Failed Tau-theta');
end

clear fig_handle;
try
    fig_handle = [];
    [~,fig_handle] = theta_trialevo(dirlist);
    
    fig_dir = strcat(dirlist(1).name,'/Analysis_fig/theta_trial_evo_day/');
    if ~exist(fig_dir,'dir')
        mkdir(fig_dir);
    end
    for i=1:6
        savefig(fig_handle(i),strcat(fig_dir,num2str(i)));
    end
    
    exportfigpptx(pptname,fig_handle,[2 3]);
    close(fig_handle);
catch e
    display(strcat('Failed theta_trialevo day :',e.message));
end

clear fig_handle;
try
    fig_handle = [];
    [~,~,~,~,fig_handle] = theta_timeevo(dirlist);
    
    fig_dir = strcat(dirlist(1).name,'/Analysis_fig/theta_time_evo_day/');
    if ~exist(fig_dir,'dir')
        mkdir(fig_dir);
    end
    for i=1:1
        savefig(fig_handle(i),strcat(fig_dir,num2str(i)));
    end
    
    exportfigpptx(pptname,fig_handle,[1 1]);
    close(fig_handle);
catch e
    display(strcat('Failed theta_timeevo day :',e.message));
end


clear fig_handle;
try
    fig_handle = [];
    [~,fig_handle] = tau_trialevo(dirlist);
    
    fig_dir = strcat(dirlist(1).name,'/Analysis_fig/tau_trial_evo_day/');
    if ~exist(fig_dir,'dir')
        mkdir(fig_dir);
    end
    for i=1:6
        savefig(fig_handle(i),strcat(fig_dir,num2str(i)));
    end
    
    exportfigpptx(pptname,fig_handle,[2 3]);
    close(fig_handle);
catch e
    display(strcat('Failed tau_trialevo day :',e.message));
end


clear fig_handle;
try
    fig_handle = [];
    [~,~,~,~,fig_handle(1)] = tau_timeevo(dirlist);
    
    fig_dir = strcat(dirlist(1).name,'/Analysis_fig/tau_time_evo_day/');
    if ~exist(fig_dir,'dir')
        mkdir(fig_dir);
    end
    for i=1:1
        savefig(fig_handle(i),strcat(fig_dir,num2str(i)));
    end
    
    exportfigpptx(pptname,fig_handle,[1 1]);
    close(fig_handle);
catch e
        display(strcat('Failed tau_timeevo day :',e.message));
end

clear fig_handle;
try
    fig_handle = [];
    [dirlist_all,name,ext] = fileparts(dirlist(1).name);
    [dirlist_all,name,ext] = fileparts(dirlist_all);
    dirlist_all = rdir(strcat(dirlist_all,'\*\'),'isdir');
    
    [~,fig_handle] = theta_trialevo(dirlist_all(1:end),0);
    
    fig_dir = strcat(dirlist(1).name,'/Analysis_fig/theta_trial_evo_full/');
    if ~exist(fig_dir,'dir')
        mkdir(fig_dir);
    end
    for i=1:6
        savefig(fig_handle(i),strcat(fig_dir,num2str(i)));
    end
    
    exportfigpptx(pptname,fig_handle,[2 3]);
    close(fig_handle);
catch e
    display(strcat('Failed theta_trialevo full:',e.message));
end


clear fig_handle;
try
    fig_handle = [];
    [dirlist_all,name,ext] = fileparts(dirlist(1).name);
    [dirlist_all,name,ext] = fileparts(dirlist_all);
    dirlist_all = rdir(strcat(dirlist_all,'\*\'),'isdir');
    
    [~,~,~,~,fig_handle] = theta_timeevo(dirlist_all(1:end),0);
        
    fig_dir = strcat(dirlist(1).name,'/Analysis_fig/theta_time_evo_full/');
    if ~exist(fig_dir,'dir')
        mkdir(fig_dir);
    end
    for i=1:1
        savefig(fig_handle(i),strcat(fig_dir,num2str(i)));
    end
    
    exportfigpptx(pptname,fig_handle,[1 1]);
    close(fig_handle);
catch e
        display(strcat('Failed theta_timeevo full :',e.message));
end

clear fig_handle;
try
    fig_handle = [];
    [dirlist_all,name,ext] = fileparts(dirlist(1).name);
    [dirlist_all,name,ext] = fileparts(dirlist_all);
    dirlist_all = rdir(strcat(dirlist_all,'\*\'),'isdir');
    
    [~,fig_handle] = tau_trialevo(dirlist_all(1:end));
        
    fig_dir = strcat(dirlist(1).name,'/Analysis_fig/tau_trial_evo_full/');
    if ~exist(fig_dir,'dir')
        mkdir(fig_dir);
    end
    for i=1:6
        savefig(fig_handle(i),strcat(fig_dir,num2str(i)));
    end
    
    exportfigpptx(pptname,fig_handle,[2 3]);
    close(fig_handle);
catch e
    display(strcat('Failed tau_trialevo full :',e.message));
end

clear fig_handle;
try
    fig_handle = [];
    [dirlist_all,name,ext] = fileparts(dirlist(1).name);
    [dirlist_all,name,ext] = fileparts(dirlist_all);
    dirlist_all = rdir(strcat(dirlist_all,'\*\'),'isdir');
    
    [~,~,~,~,fig_handle(1)] = tau_timeevo(dirlist_all(1:end));
    
    
    fig_dir = strcat(dirlist(1).name,'/Analysis_fig/tau_time_evo_full/');
    if ~exist(fig_dir,'dir')
        mkdir(fig_dir);
    end
    for i=1:1
        savefig(fig_handle(i),strcat(fig_dir,num2str(i)));
    end
    
    exportfigpptx(pptname,fig_handle,[1 1]);
    close(fig_handle);
catch e
    display(strcat('Failed tau_timeevo full :',e.message));
end
close all
clear fig_handle;

warnings('on','all');
