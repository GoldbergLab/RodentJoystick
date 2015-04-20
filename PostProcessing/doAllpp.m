function doAllpp(working_dir, varargin) 
default = {'off'};
numvarargs = length(varargin);
if numvarargs > 1
    error('too many arguments (> 2), only one required and one optional.');
end
[default{1:numvarargs}] = varargin{:};
[CACHE_FLAG] = default{:};


disp(working_dir);
if (numel(working_dir)==0)
working_dir = uigetdir(pwd);
end
fileformatspec = '%f %f %s %s %s %s %s';
numfield = 7;
ppscript(working_dir,fileformatspec,numfield);
jstruct=xy_makestruct(working_dir);
stats=xy_getstats(jstruct);
save(strcat(working_dir,'/jstruct.mat'),'jstruct');
save(strcat(working_dir,'/stats.mat'),'stats');

%run all post processing scripts, cache data in folder for GUI use
if strcmp(CACHE_FLAG, 'on')
    ppdata_dir = strcat(working_dir,'/cached_ppdata');
    mkdir(ppdata_dir);
    failed = {};
    try
    [~, ~, ~, ~, generate_time_distr_cache] = generate_time_distr(jstruct, 20, 1, 'data');
    save(strcat(ppdata_dir,'/generate_time_distr_cache.mat'),'generate_time_distr_cache');
    catch
        failed{end+1} = 'generate_time_distr';
    end
    try
    [~, ~, ~, ~, ~, hold_time_distr_cache] = hold_time_distr(stats.traj_struct, 50, 'plot', 'none', 2500);
    save(strcat(ppdata_dir,'/hold_time_distr_cache.mat'),'hold_time_distr_cache');
    catch
        failed{end+1} = 'hold_time_distr';
    end
    try
    [~, ~, trajectory_analysis_cache] = trajectory_analysis(stats, 4,[400 1400], [0 0 0], 'plot', 'N/A', 'median', 'yes');
    save(strcat(ppdata_dir,'/trajectory_analysis_cache.mat'),'trajectory_analysis_cache');
    trajectory_analysis;
    catch
        failed{end+1} = 'trajectory_analysis';
    end
    disp('The following Post Processing Scripts failed: ');
    close all;
    for i=1:length(failed)
        display(failed{i});
    end
end