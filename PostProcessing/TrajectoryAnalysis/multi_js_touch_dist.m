 function [set_distances, set_distances_strings] = multi_js_touch_dist(dirlist,varargin)
%[set_dist, set_dist_str] = multi_js_touch_dist(dirlist,[interv, ...
%   targ_reward, dist_thresh, targ_time, combineflag, plotflag, ax])
%
%   runs analysis script js_touch_dist on all entries in dirlist with the
%   (optional) parameters specified
%
% OUTPUTS
%
%   set_dist :: vector of distances (double array) corresponding to each
%       directory in dirlist, each day represented in dirlist, or the
%       entire list's data (see combineflag)
%
%   set_dist_str :: cell array version of set_dist (same information)
%
% ARGUMENTS
%
%   dirlist :: standard struct representation of a list of directories
%       from rdir
%
% OPTIONAL ARGS
%
%   interv :: histogram plotting interval (ms)
%       DEFAULT - 20
%   
%   targ_reward :: target reward rate (fraction)
%       DEFAULT - 0.25
%
%   dist_thresh :: generates hold time distribution with max continuous
%       length under dist_thresh
%       DEFAULT - 50
%
%   targ_time :: target hold time (ms), doesn't affect hold time
%       distribution, only computation of recommend
%       DEFAULT - 300
%
%   combineflag :: flag describing how to combine directories - leave alone
%       (0), combine all data(1), or group directories by day (2)
%       DEFAULT - 0
%  
%   plotflag :: flag indicating whether to plot distributions (1), or just
%       return recommended distances (0)
%       DEFAULT - 1
%
%   smoothparam :: parameter indicating whether and how much the
%       plots should be smoothed (uses moving average technique)
%       DEFAULT - 1 (no smoothing)
%
%   ax :: an axes handles for plotting. If left empty, generates a
%       new figure automatically
%       DEFAULT - []
%
%   traj_id :: parameter indicating which subset of trajectories to
%       analyze - see get_stats_with_trajid documentation

default = {20, 0.25, 50, 300, 0, 1, 1, [], 0,0};

numvarargs = length(varargin);
if numvarargs > 10
    error('too many arguments (> 11), only 1 required and 10 optional.');
end
[default{1:numvarargs}] = varargin{:};
[interv, targ_reward, dist_thresh, targ_time, combineflag, plotflag, ...
    smoothparam, ax, traj_id,to_stop] = default{:};
if plotflag && isempty(ax);
    figure;
    ax = gca();
end

[statslist, dates] = load_stats(dirlist, combineflag,to_stop,0,{'traj_struct'});
colors = 'rbkmcgyrbkmcgyrbkmcgy';
set_distances = zeros(1, length(statslist));

% Get only the selected trajectories 
statslist = get_stats_with_trajid(statslist,traj_id);
if plotflag
    plotflag=traj_id+1;
end

alltrajflag = 1;
for i= 1:length(statslist)
    [set_dist,hold_vect,med_time] = js_touch_dist(statslist(i), interv, targ_time, ...
        targ_reward,dist_thresh, alltrajflag, plotflag, smoothparam, ax, colors(i));
    set_distances(i) = set_dist;
    med_time(i) = med_time;
end
if plotflag
    axes(ax);
    legend(dates);
end
for i = 1:length(statslist);
    set_distances_strings{i} = [dates{i},': ', num2str(set_distances(i)),' Med time: ',num2str(med_time(i))];
end 

end

