function all_holdtimes_distr(dirlist, varargin)
%data = 
% all_holdtimes_distr(dirlist, [hist_int, TIME_RANGE, combineflag])
%   Plots the following hold time related distributions:
%   hold time distribution
%   rewarded trajectories' hold times distribution
%   reward rate by interval distribution
%   joystick onset to reward onset distribution

%ARGUMENT MANIPULATION
default = {20, 2000, 0};
numvarargs = length(varargin);
if numvarargs > 3
    error('too many arguments (> 5), only 1 required and 3 optional.');
end
[default{1:numvarargs}] = varargin{:};
[hist_int, TIME_RANGE, combineflag] = default{:};

figure('Position', [100, 100, 900, 900]);
ax1 = subplot(2,2, 1);
ax2 = subplot(2,2, 2);
ax3 = subplot(2,2, 3);
ax4 = subplot (2, 2, 4);
[data, dates, statistics] = get_rewardandht_times(dirlist, hist_int, TIME_RANGE, combineflag);
allstuff.data = data; allstuff.dates=dates; allstuff.stats=statistics;

%to make sure that it's actually plotting using the data and not attempting
%to recompute, pass arguments that would fail the plot otherwise
[~,~, summary] = hold_time_distr([], -1, -1, -1, -1, ax1, allstuff);
rewarded_time_distr([], -1, -1, -1, ax2, allstuff);
rewardrate_distr([], -1, -1, -1, ax3, allstuff);
joystick_to_reward_distr([], -1, -1, -1, ax4, allstuff);

medianholdtimes = zeros(length(summary), 1);
first = zeros(length(summary), 1);
third = zeros(length(summary), 1);
for i = 1:length(summary)
    medianholdtimes(i) = summary{i}(2);
    first(i) = summary{i}(1);
    third(i) = summary{i}(3);

end
figure;
hold on;
plot(1:1:length(summary), medianholdtimes, 'r', 'LineWidth', 1);
plot(1:1:length(summary), first, ':r', 'LineWidth', 1);
plot(1:1:length(summary), third, ':r', 'LineWidth', 1);
xlabel('Day'); ylabel('Median Hold Time'); title('Hold Time vs Day');
hold off;
end

