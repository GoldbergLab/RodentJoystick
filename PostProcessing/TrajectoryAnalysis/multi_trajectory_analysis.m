function [labels] = multi_trajectory_analysis(jslist, varargin)
%[data, labels, summary] 
% = multi_trajectory_analysis(jslist, [plot_range, hold_time_range, plot_contingencies, plotflag, axes_lst])
%rewarded_time_distr plots the distribution of rewarded trajectories' hold
%times using intervals defined by hist_int for a range [0, TIME_RANGE].
% ARGUMENTS: 
%       jslist :: the result from xy_getstats(jstruct) for some jstruct
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
elseif pflag == 1 && (length(axeslst) < PLOT_RANGE)
    error('Not enough axes handles provided for desired number of bins');
end
colors = 'rgbkmcyrgbkmcyrgbkmcy';
dates = cell(length(jslist), 1);
if combineflag==0
%% GET LIST of individual data
    for i= 1:length(jslist)
        load(jslist(i).name);
        stats = xy_getstats(jstruct);
        dates{i} = datestr(jstruct(2).real_time, 'mm/dd/yy');
        [~, labels, lhandle] = trajectory_analysis(stats, PLOT_RANGE,TIME_RANGE, CONTL, 1, axeslst, colors(i), 1);
        groupings(i)=lhandle;
    end
    axes(axeslst(PLOT_RANGE));
    legend(groupings,dates);
else
%% FIND COMBINED DATA    
    combined = [];
    for i= 1:length(jslist)
        load(jslist(i).name);
        combined = [combined, jstruct];
        dates{i} = datestr(jstruct(2).real_time, 'mm/dd/yy');
    end
    stats = xy_getstats(combined);
    [~, labels, lhandle] = trajectory_analysis(stats, PLOT_RANGE,TIME_RANGE, CONTL, 1, axeslst,colors(1), 2);
    groupings(1)=lhandle;
    axes(axeslst(PLOT_RANGE));
    legend(groupings, [dates{1},'-',dates{end}]);
end
end


