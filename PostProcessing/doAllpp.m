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
[velaccel, velaccelraw] = get_vel_accel_distr(stats);

save(strcat(working_dir,'/jstruct.mat'),'jstruct');
save(strcat(working_dir,'/stats.mat'),'stats');
save(strcat(working_dir,'/velaccel.mat'), 'velaccel');
save(strcat(working_dir,'/velaccelraw.mat'), 'velaccelraw');

