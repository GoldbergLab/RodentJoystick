function [labels] = multi_trajectory_analysis(dirlist, varargin)
%[labels] 
% = multi_trajectory_analysis(dirlist, [derivative, plot_range, 
%       hold_time_range, combineflag, smoothparam, axes_lst, traj_id])
%   
%   multi_trajectory_analysis performs the analysis done by the function
%   trajectory_analysis for multiple days/directories defined by dirlist
%
% ARGUMENTS: 
%
%   dirlist :: list of days (as directories in struct representation
%       from rdir)
%
% OPTIONAL ARGS:
%   
%   derivative :: a flag indicating what data trajectory_analysis should
%       look at it
%       0 - Deviation (Trajectory Magnitude)
%       -- Currently Unsupported --
%       1 - Radial Velocity
%       2 - Radial Acceleration
%       3 - Velocity Magnitude
%       4 - Acceleration Magnitude
%       DEFAULT - 0
%
%   plot_range :: number representing number of plots. 
%       DEFAULT - 4
%
%   hold_time_range :: the time range [A B] (ms) for which trajectories
%       are included, i.e. any trajectory with a hold time in the range
%       [A, B] is analyzed
%       DEFAULT: [400 1400]
%
%   combineflag :: flag indicating whether to combine all data and generate
%       a single plot, or leave as separate days
%       DEFAULT - 0
%
%   smoothparam :: parameter describing smoothing (parameter is the size of
%       filter window - filter is moving average)
%       DEFAULT - 5
%
%   traj_id :: choose to plot trajectories of a certain kind 
%       all_trajectories  0
%       laser only        1
%       no laser          2
%       no laser (resampled)  3
%
%   axeslst :: a list of axes handles of where to plot. If specified,
%       length(axes_lst) >= plot_range. If empty, then generates a new
%       figure
%       DEFAULT - []

    
%   lasercomparflag :: overlay laser hit trials with resampled/all others
%       laser vs all non laser          2
%       laser vs resampled non laser    3


%% ARGUMENT MANIPULATION AND PRELIMINARY MANIPULATION
default = {0, 4,[400 1400], 0, 5, 0, []};
numvarargs = length(varargin);
if numvarargs > 8
    error('too many arguments (> 8), only 1 required and 7 optional.');
end
[default{1:numvarargs}] = varargin{:};

[derivative, PLOT_RANGE, TIME_RANGE, combineflag, smoothparam, traj_id, axeslst, lasercompareflag] = default{:};


%% axes/figure handling
if length(axeslst)<1;
    figure('Position', [100, 100, 1440, 900]);
    for i = 1:PLOT_RANGE
        axeslst(i) = subplot(2, PLOT_RANGE/2, i);
    end
elseif (length(axeslst) < PLOT_RANGE)
    error('Not enough axes handles provided for desired number of bins');
end

colors = 'rbkmcyrgbkmcyrgbkmcy';

%% Loading days and actual plotting
[statslist_all, dates] = load_stats(dirlist, combineflag, 1, 0);

statslist_all = get_stats_with_len(statslist_all,50);
statslist_all = get_stats_startatzero(statslist_all);
%statslist_all = get_stats_with_reach(statslist_all,4);
if lasercompareflag==3 && combineflag==1
    statslist(1) = get_stats_with_trajid(statslist_all,1);
    statslist(2) = get_stats_with_trajid(statslist_all,3);
    dates{2} = [dates{1} '-nonlaser'];
elseif lasercompareflag==2 && combineflag==1
    statslist(1) = get_stats_with_trajid(statslist_all,1);
    statslist(2) = get_stats_with_trajid(statslist_all,2);
    dates{2} = [dates{1} '-nonlaser'];
else
    statslist = get_stats_with_trajid(statslist_all,traj_id);
end

contlflag = 1;
%statflag - plot only medians if more than four days to be plotted

statflag = ~(length(statslist) > 4);
for i= 1:length(statslist)
    [outthresh, ht, innerthresh] = extract_contingency_info(dirlist(ceil(i/2)).name);
    stats = statslist(i);
    [~, labels, lhandle] = trajectory_analysis(stats, derivative, PLOT_RANGE, ...
        TIME_RANGE, [ht outthresh innerthresh]*contlflag, 1, smoothparam, axeslst, colors(i), statflag);
    groupings(i)=lhandle;
end
axes(axeslst(PLOT_RANGE));
legend(groupings,dates);




