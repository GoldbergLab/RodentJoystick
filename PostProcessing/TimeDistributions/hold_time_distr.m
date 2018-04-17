function [data, summary] = hold_time_distr(dirlist, varargin )
%[data, summary] 
%   = hold_time_distr(dirlist, [hist_int, TIME_RANGE, combineflag, smoothparam, ax, allstuff])
%   
%   hold_time_distr plots the distribution of hold times with intervals
%   defined by hist_int for a range [0, TIME_RANGE];
%
% OUTPUTS
%   
%   data :: cell array with a cell for each jstruct in dirlist containing
%       histogram data for each cell has the format:
%       [time, holdtime_ht] (holdtime ht has already been binned)
%
%   summary :: cell array with a cell for each jstruct in dirlist containing
%       statistics describing hold time distribution for each day
%       each cell has the format:
%       [firstquartile median thirdquartile mean stdev]
%
% ARGUMENTS
%
%   dirlist :: list of directories corresponding to days (struct from rdir)
%
% OPTIONAL ARGS
%
%   ht_def :: hold time variation
%       (0) - rw_or_stop
%       (1) - js_onset to js offset
%       offset
%       DEFAULT: 0
%
%   hist_int :: size of the bins for histogram generation (in ms)
%       DEFAULT : 20
%
%   TIME_RANGE :: number that tells end time range
%       DEFAULT : 2000
%
%   combineflag :: tells whether to combine all data from all jstructs into
%       a single plot (1), or plot each day separately (0)
%       DEFAULT: 0
%
%   normalize :: 1/0 flag indicating whether to normalize to probability
%       distribution (1), or leave as raw counts (0)
%       DEFAULT: 1
%
%   smoothparam :: parameter describing smoothing - changes data using a
%       moving average
%       DEFAULT : 1 (no smoothing)
%
%   ax :: a vector containing axes handles for hold_time_distr to plot on
%       if empty, hold_time_distr will generate a new figure
%       DEFAULT : []


%% ARGUMENT MANIPULATION AND PRELIMINARY MANIPULATION
default = {0, 20, 2000, 0, 1, 1, []};
numvarargs = length(varargin);
if numvarargs > 7
    error('too many arguments (> 8), only 1 required and 6 optional.');
end
[default{1:numvarargs}] = varargin{:};
[ht_def, hist_int, TIME_RANGE, combineflag, normalize, smoothparam, ax] = default{:};

if (length(ax)<1); figure; ax = gca(); end
if length(TIME_RANGE)<2; TIME_RANGE(2) = TIME_RANGE(1); TIME_RANGE(1) = 0; end;

colors = 'rbkmcgyrbkmcgyrbkmcgy';
time_bins = TIME_RANGE(1):hist_int:TIME_RANGE(2);
[statslist, dates] = load_stats(dirlist, combineflag, 'traj_struct');
for i = 1:length(statslist)
    tstruct = statslist(i).traj_struct;
    if ht_def
        holdtimes = arrayfun( @(tcell) length(tcell.traj_x), tstruct);
    else
        holdtimes = arrayfun(@(tcell) tcell.rw_or_stop, tstruct);
    end
    ht_hist = histc(holdtimes, time_bins);
    if normalize; ht_hist = ht_hist./sum(ht_hist); end;
    data{i} = ht_hist;
    htstats = prctile(holdtimes, [25 50 75]);
    htstats(4) = mean(holdtimes); ht
    stats(5) = std(holdtimes);
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

