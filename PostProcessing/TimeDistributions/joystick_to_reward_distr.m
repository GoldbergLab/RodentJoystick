function [data, labels, summary] = joystick_to_reward_distr(jslist, varargin )
%[data, labels, summary] 
% = joystick_to_reward_distr(jslist, [hist_int, TIME_RANGE, combineflag, plotflag, ax])
%joystick_to_reward_distr plots the distribution of joystick to reward onset times with
%a histogram interval specified by hist_int on a time range of 0 to
%time_range milliseconds
%OUTPUTS:
%   holdtimes :: list of hold times, in order of trajectories in
%       corresponding tstruct
%   rewtimes :: list of hold times for which mouse was rewarded
%   js2rew :: list of times between joystick onset and reward (for rewarded
%       trajectories only)
%ARGUMENTS:
%   tstruct :: structure containing all the information about each
%       trajectory. NOT the same as jstruct - after running
%       stats = xy_getstats, tstruct = stats.traj_struct
%   OPTIONAL
%   hist_int :: size of the bins for data generation and histogram plotting
%   plotflag :: flag that tells hold_time_distr whether to generate data or
%       plot - 'plot' - plots the figure, 'data' - just returns data
%       without plotting
%       DEFAULT : 'plot' 
%   statflag :: flag that tells hold_time_distr whether to display
%       statistics. 'stats' displays stats, 'none' doesn't display
%       DEFAULT : 'none'
%   TIME_RANGE :: number that tells end time range
%       DEFAULT : 2000

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
labels.xlabel = 'JS to Reward Onset Time (ms)';
labels.ylabel = 'Probability';
labels.title = 'Joystick Onset to Reward Time Distribution';

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
    summary{i} = allstats{i}.js2rew;
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

