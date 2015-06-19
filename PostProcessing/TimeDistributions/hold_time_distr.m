function [data, labels, summary] = hold_time_distr(jslist, varargin )
%[data, labels, summary] 
% = hold_time_distr(jslist, [hist_int, TIME_RANGE, combineflag, plotflag, ax])
%hold_time_distr plots the distribution of hold times with intervals
%defined by hist_int for a range [0, TIME_RANGE];
%a histogram interval specified by hist_int on a time range of 0 to
%time_range milliseconds
%OUTPUTS:
%   data :: cell array with a cell for each jstruct in jslist containing
%       histogram data for each cell has the format:
%       [time, holdtime_ht] (holdtime ht has already been binned
%   labels :: struct containing xlabel, ylabel, title, and legend
%   summary :: cell array with a cell for each jstruct in jslist containing
%       statistics describing hold time distribution for each day
%       each cell has the format:
%ARGUMENTS:
%   tstruct :: structure containing all the information about each
%       trajectory. NOT the same as jstruct - after running
%       stats = xy_getstats, tstruct = stats.traj_struct
%   OPTIONAL
%   hist_int :: size of the bins for data generation and histogram plotting
%   TIME_RANGE :: number that tells end time range
%       DEFAULT : 2000
%   combineflag :: tells whether to combine all data from all jstructs into
%       a single plot, or leave 
%   statflag :: flag that tells hold_time_distr whether to display
%       statistics. 'stats' displays stats, 'none' doesn't display
%       DEFAULT : 'none'


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
    extradata = allstuff.extradata;
    dates = allstuff.dates;
    allstats = allstuff.allstats;
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

