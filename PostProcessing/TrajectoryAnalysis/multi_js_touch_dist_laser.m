 function [set_distances, set_distances_strings] = multi_js_touch_dist_laser(dirlist,varargin)
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
%   lasercompareflag :: parameter indicating which subset of trajectories to
%       compare
%       1 - laser v. all catch
%       2 - laser v. resampled catch

default = {20, 0.25, 50, 300, 1, 1, [], 0};

numvarargs = length(varargin);
if numvarargs > 10
    error('too many arguments (> 11), only 1 required and 10 optional.');
end
[default{1:numvarargs}] = varargin{:};
[interv, targ_reward, dist_thresh, targ_time, plotflag, ...
    smoothparam, ax, lasercompareflag,to_stop] = default{:};
if plotflag && isempty(ax);
    figure;
    ax = gca();
end

[statslist, dates] = load_stats(dirlist,1,to_stop, 'traj_struct');
colors = 'rbkmcgyrbkmcgyrbkmcgy';
set_distances = zeros(1, length(statslist));

% Get only the selected trajectories 
statshit = get_stats_with_trajid(statslist,1);
statscatch = get_stats_with_trajid(statslist,lasercompareflag+1);
dates{2} = strcat(dates{1},'-nl');
dates{1} = strcat(dates{1},'-l');

statslist(1) = statshit;
statslist(2) = statscatch;

alltrajflag = 1;
for i= 1:length(statslist)
    [set_dist,hold_dist_vect,med_time,hold_len] = js_touch_dist(statslist(i), interv, targ_time, ...
        targ_reward,dist_thresh, alltrajflag, plotflag, smoothparam, ax, colors(i));
    set_distances(i) = set_dist;
    med_time_vect(i) = med_time;
    hold_dist_struct{i} = hold_len;
end
if plotflag
    axes(ax);
    if (lasercompareflag-1)
        legend('Laser', 'Catch (Resampled)');
    else
        legend('Laser', 'Catch (All)');
    end
end
[h,p] = kstest2(hold_dist_struct{1},hold_dist_struct{2});
for i = 1:length(statslist);
    set_distances_strings{i} = [dates{i},': ', num2str(set_distances(i)),' Med time: ',num2str(med_time_vect(i))];
end 
set_distances_strings{end+1} = ['P value :',num2str(p)];
end

