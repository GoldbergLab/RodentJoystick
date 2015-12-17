%No longer used - can be archived
function addstatsinfolder(working_dir, varargin)
try
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
try
    load([working_dir, '\stats.mat']);
catch
    load([working_dir, '\jstruct.mat']);
    stats = xy_getstats(jstruct);
    save(strcat(working_dir, '\stats.mat'), 'stats');
end
[velaccel, velaccelraw] = compute_vel_accel_distr(stats);
save(strcat(working_dir,'\velaccel.mat'), 'velaccel');
save(strcat(working_dir,'\velaccelraw.mat'), 'velaccelraw');

catch e
disp(e);
end