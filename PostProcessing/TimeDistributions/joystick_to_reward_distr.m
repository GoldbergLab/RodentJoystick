function [data, labels, summary] = joystick_to_reward_distr(dirlist, varargin )
%[data, labels, summary] 
% = joystick_to_reward_distr(dirlist, [hist_int, TIME_RANGE, combineflag, ax, alldata])
%
% joystick_to_reward_distr plots the distribution of joystick onset to reward onset
% times with intervals defined by hist_int for a range [0, TIME_RANGE];
%
% OUTPUTS:
%
%   data :: cell array with a cell for each jstruct in dirlist containing
%       histogram data for each cell has the format:
%       [time, js2rew_ht] (js2rew_ht has already been binned)
%
%   labels :: struct containing xlabel, ylabel, title, and legend
%
%   summary :: cell array with a cell for each jstruct in dirlist containing
%       statistics describing js onset to reward time distribution for each day
%       each cell has the format:
%       [firstquartile median thirdquartile mean stdev]
%
% ARGUMENTS:
%   
%   dirlist :: list of directory structs (with name field)
%
% OPTIONAL ARGS:
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
%   ax :: a vector containing axes handles for hold_time_distr to plot on
%       if empty, hold_time_distr will generate a new figure
%       DEFAULT : []

%% ARGUMENT MANIPULATION AND PRELIMINARY MANIPULATION
default = {20, 2000, 0, []};
numvarargs = length(varargin);
if numvarargs > 5
    error('too many arguments (> 6), only 1 required and 5 optional.');
end
[default{1:numvarargs}] = varargin{:};
[hist_int, TIME_RANGE, combineflag, ax] = default{:};
if (length(ax)<1); figure; ax = gca(); end
if length(TIME_RANGE)<2; TIME_RANGE(2) = TIME_RANGE(1); TIME_RANGE(1) = 0; end;
colors = 'rbkmcgyrbkmcgyrbkmcgy';
time_bins = TIME_RANGE(1):hist_int:TIME_RANGE(2);

[statslist, dates, allstats] = load_stats(dirlist, combineflag, 'traj_struct');

data = cell(length(statslist), 1); 
summary = cell(length(statslist), 1);
for i = 1:length(statslist)
    tstruct = statslist(i).traj_struct;
    js2rew = arrayfun(@(tcell) tcell.rw_onset, tstruct);
    js2rew = js2rew(js2rew > 0);
    js2rew_hist = histc(js2rew, time_bins);
    data{i} = js2rew_hist;
    htstats = prctile(js2rew, [25 50 75]);
    htstats(4) = mean(js2rew); htstats(5) = std(js2rew);
    summary{i} = htstats;
end

%% PLOT ALL DATA
axes(ax(1));
hold on;
LINEWIDTH = 1; if length(statslist)==1; LINEWIDTH = 2; end;
for i = 1:length(data)
    datatmp = data{i};
    stairs(time_bins,datatmp, colors(i), 'LineWidth', LINEWIDTH);
end
xlabel('JS to Reward Onset Time (ms)'); ylabel('Probability');
title('Joystick Onset to Reward Time Distribution');
legend(dates);
hold off;

end

