function [labels] = multi_trajectory_analysis_laser(dirlist, varargin)
%[labels] 
% = multi_trajectory_analysis_laser(dirlist, [derivative, plot_range, 
%       hold_time_range, smoothparam, axes_lst, traj_id])
%   
%   multi_trajectory_analysis performs the analysis done by the function
%   trajectory_analysis for multiple days/directories defined by dirlist
%   and splits the data based on which trajectories were hit by laser
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
%   smoothparam :: parameter describing smoothing (parameter is the size of
%       filter window - filter is moving average)
%       DEFAULT - 5
%
%   axeslst :: a list of axes handles of where to plot. If specified,
%       length(axes_lst) >= plot_range. If empty, then generates a new
%       figure
%       DEFAULT - []

%   traj_id :: choose to plot trajectories of a certain kind 
%       all_trajectories  0
%       laser only        1
%       no laser          2
%       both, separated   3
%       both, separated, with resampling 4
    
%% ARGUMENT MANIPULATION AND PRELIMINARY MANIPULATION
default = {0, 4,[400 1400], 0, 5, [], 0};
numvarargs = length(varargin);
if numvarargs > 7
    error('too many arguments (> 8), only 1 required and 7 optional.');
end
[default{1:numvarargs}] = varargin{:};
[derivative, PLOT_RANGE, TIME_RANGE, combineflag, smoothparam, axeslst, traj_id] = default{:};

%% axes/figure handling
if length(axeslst)<1;
    figure('Position', [100, 100, 1440, 900]);
    for i = 1:PLOT_RANGE
        axeslst(i) = subplot(2, PLOT_RANGE/2, i);
    end
elseif (length(axeslst) < PLOT_RANGE)
    error('Not enough axes handles provided for desired number of bins');
end
colors = 'rgbkmcyrgbkmcyrgbkmcy';

%% Loading days and actual plotting
[statslist, dates] = load_stats(dirlist, combineflag);

statslist = get_stats_with_trajid(statslist,traj_id, varargin);
contlflag = 1;
%statflag - plot only medians if more than four days to be plotted
statflag = ~(length(statslist) > 4);
for i= 1:length(statslist)
    [outthresh, ht, innerthresh] = extract_contingency_info(dirlist(i).name);
    stats = statslist(i);
    [~, labels, lhandle] = trajectory_analysis(stats, derivative, PLOT_RANGE, ...
        TIME_RANGE, [ht outthresh innerthresh]*contlflag, 1, smoothparam, axeslst, colors(i), statflag);
    groupings(i)=lhandle;
end
axes(axeslst(PLOT_RANGE));
legend(groupings,dates);






