%[labels] = 
%   multi_sector_analysis(dir_list, [reward_rate, thresh, plotflag, ax])
%   computes the required target sector (angles) required for 'reward_rate'
%   a percentage of trials to be rewarded, looking only at portions of
%   trajectories with magnitude greater than the threshold thresh
%   EXAMPLE:  
%       targsec = find_sector(dirlist,25)
%       targsec = find_sector(dirlist,25, 95)
%       targsec = find_sector(dirlist, 25, 95, 'log', [0 99]) 
%   OUTPUTS:
%       targsec :: a sector with targsec(1) defining the start angle, and
%           targsec(2) defining the end angle, moving counterclockwise.
%           I.e., targsec = [350 10] defines a 20 degree arc
%       distr :: 360 entry vector that is cumulative probability distribution
%           of reaching that location (different than angle distribution,
%           which contains the probability of hitting an angle);
%       angle_distr :: 360 entry vector with distribution of angles
%   ARGUMENTS: 
%       dirlist :: list of days as directories (as struct list
%           representation)
%       OPTIONAL ARGS:
%       reward_rate :: percentage giving desired reward rate for
%           computation of target sector
%           DEFAULT: 25
%       thresh :: only trajectory points with a magnitude above thresh will
%           be used in computing angle distributions and then target sector
%           DEFAULT: 75
%       combineflag :: 0 plots each day individually, 1 combines all days
%       ax :: an axes handle for perform_sector_analysis to plot data on.
%           if empty (as by default) and plotflag is on, then generates a
%           new figure automatically
%       

function multi_sector_analysis(dir_list, varargin)
%% argument handling
default = {25, 75, 0, []};
numvarargs = length(varargin);
if numvarargs > 5
    error('find_sector: too many arguments (> 6), only one required and five optional.');
end
[default{1:numvarargs}] = varargin{:};
[targ_rate, thresh, combineflag, ax] = default{:};
colors = 'rbkmcgyrbkmcgyrbkmcgy';
if length(ax)<1; figure; ax = gca(); end;

[statslist, dates] = load_stats(dir_list, combineflag, 'traj_struct');

statslist = get_stats_with_trajid(statslist,3);

if length(statslist)<2
    plotflag = 1;
else 
    plotflag = 2;
end
if targ_rate < 1 || targ_rate > 99.5
    plotflag = 3;
end

for i = 1:length(statslist)
    stats = statslist(i);
    [~, ~, ~, ~, line] = perform_sector_analysis(stats, targ_rate, thresh, plotflag, ax, colors(i));
    lines(i) = line;
end
axes(ax);
legend(lines, dates);

