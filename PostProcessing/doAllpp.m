function doAllpp(working_dir, varargin) 
default = {'off'};
numvarargs = length(varargin);
if numvarargs > 1
    error('too many arguments (> 2), only one required and one optional.');
end
[default{1:numvarargs}] = varargin{:};


disp(working_dir);
if (numel(working_dir)==0)
working_dir = uigetdir(pwd);
end
fileformatspec = '%f %f %s %s %s %s %s';
numfield = 7;
ppscript(working_dir,fileformatspec,numfield);
jstruct=xy_makestruct(working_dir);
stats=xy_getstats(jstruct);
disp('Finished making jstruct and computing stats.');
[velaccel, velaccelraw] = compute_vel_accel_distr(stats);

save(strcat(working_dir,'/jstruct.mat'),'jstruct');
save(strcat(working_dir,'/stats.mat'),'stats');
save(strcat(working_dir,'/velaccel.mat'), 'velaccel');
save(strcat(working_dir,'/velaccelraw.mat'), 'velaccelraw');

load('stats.mat'); [velaccel, velaccelraw] = compute_vel_accel_distr(stats); save(strcat(pwd,'/velaccel.mat'), 'velaccel'); save(strcat(pwd,'/velaccelraw.mat'), 'velaccelraw'); clear stats; clear velaccel; clear velaccelraw;