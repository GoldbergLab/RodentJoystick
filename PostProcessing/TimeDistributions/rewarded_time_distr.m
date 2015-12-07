function [data, summary] = rewarded_time_distr(dirlist, varargin )
%[data, labels, summary] 
%   = rewarded_time_distr(dirlist, [hist_int, TIME_RANGE, combineflag, ax, alldata])
%   rewarded_time_distr plots the distribution of rewarded trajectories' hold
%   times using intervals defined by hist_int for a range [0, TIME_RANGE].
%
% OUTPUTS:
%   data :: cell array with a cell for each jstruct in dirlist containing
%       histogram data for each cell has the format:
%       [time, rew_ht] (rew_ht has already been binned)
%
%   summary :: cell array with a cell for each jstruct in dirlist containing
%       statistics describing rewarded hold time distribution for each day
%       each cell has the format:
%       [firstquartile median thirdquartile mean stdev]
% ARGS:
%
%   dirlist :: list of directory structs (with name field)
%
% OPTIONAL ARGS:
%
%   hist_int :: size of the bins for histogram generation (in ms)
%       DEFAULT : 20
%
%   normalize :: 1/0 flag indicating whether to normalize to probability
%       distribution (1) or leave as raw counts (0)
%       DEFAULT : 1
%
%   TIME_RANGE :: number that tells end time range
%       DEFAULT : 2000
%
%   combineflag :: tells whether to combine all data from all jstructs into
%       a single plot (1), or plot each day separately (0)
%       DEFAULT: 0
%
%   ax :: a vector containing axes handles for hold_time_distr to plot on
%       if empty, hold_time_distr will generate a new figure
%       DEFAULT : []


%% ARGUMENT MANIPULATION AND PRELIMINARY MANIPULATION
default = {20, 2000, 0, 1, 3, []};
numvarargs = length(varargin);
if numvarargs > 6
    error('too many arguments (> 7), only 1 required and 6 optional.');
end
[default{1:numvarargs}] = varargin{:};
[hist_int, TIME_RANGE, combineflag,  normalize, smoothparam, ax] = default{:};

if (length(ax)<1); figure; ax = gca(); end
if length(TIME_RANGE)<2; TIME_RANGE(2) = TIME_RANGE(1); TIME_RANGE(1) = 0; end;
colors = 'rbkmcgyrbkmcgyrbkmcgy';
time_bins = TIME_RANGE(1):hist_int:TIME_RANGE(2);

[statslist, dates] = load_stats(dirlist, combineflag, 'traj_struct');
for i = 1:length(statslist)
    tstruct = statslist(i).traj_struct;
    holdtimes = arrayfun(@(tcell) tcell.rw_or_stop, tstruct);
    rew = arrayfun(@(tcell) tcell.rw, tstruct);
    rewardedht = holdtimes(rew>0);
    
    ht_hist = histc(rewardedht, time_bins);
    if normalize; ht_hist = ht_hist./sum(ht_hist); end;
    data{i} = ht_hist;
    htstats = prctile(rewardedht, [25 50 75]);
    htstats(4) = mean(rewardedht); htstats(5) = std(rewardedht);
    summary{i} = htstats;
end

%% PLOT ALL DATA
axes(ax(1));
hold on;
LINEWIDTH = 1; if length(data)==1; LINEWIDTH = 2; end;
for i = 1:length(data)
    stairs(time_bins, smooth(data{i}, smoothparam), colors(i), 'LineWidth', LINEWIDTH);
end
xlabel('Hold Time (ms)');
if normalize
    ylabel('Probability');
else
    ylabel('Counts');
end
title('Hold Times Distribution');
legend(dates);
hold off;
end

