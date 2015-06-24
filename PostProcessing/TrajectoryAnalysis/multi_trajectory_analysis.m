function [labels] = multi_trajectory_analysis(dirlist, varargin)
%[data, labels, summary] 
% = multi_trajectory_analysis(dirlist, [plot_range, hold_time_range, plot_contingencies, combineflag, axes_lst])
%rewarded_time_distr plots the distribution of rewarded trajectories' hold
%times using intervals defined by hist_int for a range [0, TIME_RANGE].
% ARGUMENTS: 
%       dirlist :: list of days (as directories in struct representation
%       from rdir)
%       OPTIONAL ARGS:
%       plot_range :: number representing number of plots. DEFAULT: 4
%       hold_time_range :: the time range [A B] (ms) for which trajectories
%           are included, i.e. any trajectory with a hold time in the range
%           [A, B] is analyzed
%           DEFAULT: [400 1400]
%       plot_contingencies :: [HT T1 T2] this vector tells which lines to
%           indicate contingencies as a reference - 
%           HT is the hold time, T1 and T2 are the respective deviations 
%               EX: [300 30 60]
%           value of [0 0] or [0 0 0] doesn't plot any lines   
%           DEFAULT: [0 0 0] - no plotting 
%       axes_lst :: a list of axes handles of where to plot. If specified,
%           length(axes_lst) >= plot_range


%% ARGUMENT MANIPULATION AND PRELIMINARY MANIPULATION
default = {4,[400 1400], [0 0 0], 0, []};
numvarargs = length(varargin);
if numvarargs > 5
    error('too many arguments (> 6), only 1 required and 5 optional.');
end
[default{1:numvarargs}] = varargin{:};
[PLOT_RANGE, TIME_RANGE, CONTL, combineflag, axeslst] = default{:};
if length(axeslst)<1;
    figure('Position', [100, 100, 1440, 900]);
    for i = 1:PLOT_RANGE
        axeslst(i) = subplot(2, PLOT_RANGE/2, i);
    end
elseif (length(axeslst) < PLOT_RANGE)
    error('Not enough axes handles provided for desired number of bins');
end
colors = 'rgbkmcyrgbkmcyrgbkmcy';

[statslist, dates] = load_stats(dirlist, combineflag);
for i= 1:length(statslist)
    stats = statslist(i);
    [~, labels, lhandle] = trajectory_analysis(stats, PLOT_RANGE,TIME_RANGE, CONTL, 1, axeslst, colors(i), 1);
    groupings(i)=lhandle;
end
axes(axeslst(PLOT_RANGE));
legend(groupings,dates);




