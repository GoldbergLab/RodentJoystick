function [theta] = multi_anglecrossthresh(dir_list,varargin)

%% argument handling
default = {30, 0, 0, []};
numvarargs = length(varargin);
if numvarargs > 5
    error('angle_threshcross: too many arguments (> 6), only one required and five optional.');
end
[default{1:numvarargs}] = varargin{:};
[thresh, traj_id, combineflag, ax] = default{:};
colors = 'rgbkmcyrgbkmcyrgbkmcy';
if length(ax)<1; figure; ax = gca(); end;
%%

[statslist, dates] = load_stats(dir_list, combineflag, 'traj_struct');
statslist = get_stats_with_trajid(statslist,traj_id);

colors = 'rgbkmcyrgbkmcyrgbkmcy'; 

for i = 1:length(statslist)
    stats = statslist(i);
    [theta, line] = anglethreshcross(stats.traj_struct,thresh,1,ax,colors(i));
    lines(i) = line;
end

legend(lines, dates);