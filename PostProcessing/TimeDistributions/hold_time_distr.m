function [data, labels, summary] = hold_time_distr(jslist, varargin )
%[data, labels, summary] 
% = hold_time_distr(jslist, [hist_int, TIME_RANGE, combineflag, plotflag, ax])
%hold_time_distr plots the distribution of hold times with intervals
%defined by hist_int for a range [0, TIME_RANGE];
%OUTPUTS:
%   data :: cell array with a cell for each jstruct in jslist containing
%       histogram data for each cell has the format:
%       [time, holdtime_ht] (holdtime ht has already been binned)
%   labels :: struct containing xlabel, ylabel, title, and legend
%   summary :: cell array with a cell for each jstruct in jslist containing
%       statistics describing hold time distribution for each day
%       each cell has the format:
%       [firstquartile median thirdquartile mean stdev]
%ARGUMENTS:
%   jslist :: list of jstructs including filenames
%   OPTIONAL
%   hist_int :: size of the bins for histogram generation (in ms)
%       DEFAULT : 20
%   TIME_RANGE :: number that tells end time range
%       DEFAULT : 2000
%   combineflag :: tells whether to combine all data from all jstructs into
%       a single plot (1), or plot each day separately (0)
%       DEFAULT: 0
%   ax :: a vector containing axes handles for hold_time_distr to plot on
%       if empty, hold_time_distr will generate a new figure
%       DEFAULT : []
%   alldata :: since data generation using get_rewardandht_times is costly,
%       if other plots using this data are generated, you can just pass
%       this data directly to avoid attempting to generate data multiple
%       E.g. one such call might look like: 
%       [data, dates, statistics] = get_rewardandht_times(jslist)
%       hold_time_distr([], 20, 2000, 0, ax, data)
%       Note that in this case, none of the other arguments except for ax
%       will have any effect since it will simply plot the results from
%       data


%% ARGUMENT MANIPULATION AND PRELIMINARY MANIPULATION
default = {20, 2000, 0, [], []};
numvarargs = length(varargin);
if numvarargs > 5
    error('too many arguments (> 6), only 1 required and 5 optional.');
end
[default{1:numvarargs}] = varargin{:};
[hist_int, TIME_RANGE, combineflag, ax, allstuff] = default{:};
if (length(ax)<1); figure; ax = gca(); end
colors = 'rgbkmcyrgbkmcyrgbkmcy';
labels.xlabel = 'Hold Time (ms)';
labels.ylabel = 'Probability';
labels.title = 'Hold Times Distribution';
if ~isempty(allstuff)
    extradata = allstuff.data;
    dates = allstuff.dates;
    allstats = allstuff.stats;
else
    [extradata, dates, allstats] = get_rewardandht_times(jslist, hist_int, TIME_RANGE, combineflag);
end
labels.legend = dates;
data = cell(length(extradata), 1); summary = cell(length(extradata), 1);
for i = 1:length(extradata)
    datatmp = extradata{i};
%REFERENCE: datatmp = [time, ht_hist, rw_or_stop_hist, rew_hist, rewrate_hist, js2rew_hist];
    time = datatmp(:, 1);
    ht_hist = datatmp(:, 2);
    data{i} = [time, ht_hist];
    summary{i} = allstats{i}.ht;
end

%% PLOT ALL DATA
axes(ax(1));
hold on;
LINEWIDTH = 1; if length(extradata)==1; LINEWIDTH = 2; end;
for i = 1:length(data)
    datatmp = data{i};
    stairs(datatmp(:, 1), datatmp(:, 2), colors(i), 'LineWidth', LINEWIDTH);
end
xlabel(labels.xlabel); ylabel(labels.ylabel);
title(labels.title);
legend(labels.legend);
hold off;
end

