function [holdtimes,rewtimes,js2rew, rw_or_stop, phandle, cache] = hold_time_distr(tstruct, hist_int, varargin)
%hold_time_distr plots the distribution of hold times with a histogram
%   interval specified by hist_int on a time range of 0 to TIME_RANGE
%   milliseconds
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
%   hist_int :: size of the bins for data generation and histogram plotting
%   OPTIONAL
%   plotflag :: flag that tells hold_time_distr whether to generate data or
%       plot - 'plot' - plots the figure, 'data' - just returns data
%       without plotting
%       DEFAULT : 'plot' 
%   statflag :: flag that tells hold_time_distr whether to display
%       statistics. 'stats' displays stats, 'none' doesn't display
%       DEFAULT : 'none'
%   TIME_RANGE :: number that tells end time range
%       DEFAULT : 2000

%ARGUMENT MANIPULATION
default = {'plot', 'none', 2000};
numvarargs = length(varargin);
if numvarargs > 3
    error('multi_time_distr: too many arguments (> 5), only two required and three optional.');
end
[default{1:numvarargs}] = varargin{:};
[plotflag, statflag, TIME_RANGE] = default{:};
phandle = [];

%Actually get data now, just looping over tstruct
holdtimes = zeros(length(tstruct), 1);
rw_or_stop = zeros(length(tstruct), 1);
rewtimes = []; j =1;
js2rew = [];
for i = 1:length(tstruct)
    holdtimes(i) = length(tstruct(i).magtraj);
    rw_or_stop(i) = tstruct(i).rw_or_stop - tstruct(i).js_onset;
    if tstruct(i).rw == 1
        rewtimes(j) = length(tstruct(i).magtraj);
        js2rew(j) = tstruct(i).rw_onset;
        j = j+1;
    end
end
%divide into bins
timerange = 0:hist_int:TIME_RANGE;
ht_distr = histc(holdtimes, timerange);
rewht_distr = histc(rewtimes, timerange);
rewht_distr = rewht_distr';
js_to_rew_distr = histc(js2rew, timerange);

%boring stuff below, just plotting/displaying information
if strcmp(plotflag, 'plot')
    NUM_PLOTS=3; phandle = figure; hold on;
    
    subplot(NUM_PLOTS,1,1);hold on;
    xlabel('Hold Time (ms)'); ylabel('Trajectory Distributions');
    titlestr=['Hold Time Distributions: ', num2str(length(holdtimes)), ' trajectories'];
    title(titlestr); hold on;
    cache.holdtimedistr.title=titlestr;
    cache.holdtimedistr.xlabel = 'Hold Time (ms)';
    cache.holdtimedistr.ylabel = 'Trajectory Distributions';
    cache.holdtimedistr.holdtimedistr = ht_distr./(sum(ht_distr));
    cache.holdtimedistr.rewarddistr = rewht_distr./(sum(rewht_distr));
    stairs(timerange, cache.holdtimedistr.holdtimedistr, 'b'); hold on;
    stairs(timerange, cache.holdtimedistr.rewarddistr, 'r'); hold on;
    cache.holdtimedistr.times = timerange;
    cache.holdtimedistr.legend={'all'; 'reward distribution'};
    legend('all', 'reward distribution');
    
    subplot(NUM_PLOTS,1,2); hold on;
    xlabel('Hold Time (ms)'); ylabel('Reward Rate Percentage for Hold Time'); 
    titlestr=['Rewarded Trajectory Rate: ', num2str(length(rewtimes)), ' trajectories'];
    title(titlestr); 
    hold on;
    cache.rewardrate.times =  timerange;
    cache.rewardrate.reward_rates =  rewht_distr./ht_distr;
    stairs(timerange, cache.rewardrate.reward_rates, 'r'); hold on;
    axis([0 inf 0 1]);
    cache.rewardrate.axis = [0 inf 0 1];
    cache.rewardrate.title=titlestr;
    cache.rewardrate.xlabel = 'Hold Time (ms)';
    cache.rewardrate.ylabel = 'Reward Rate Percentage for Hold Time';
    
    subplot(NUM_PLOTS,1,3); hold on;
    titlestr = 'Joystick Onset Time to Reward Time Distributions';
    title(titlestr);
    cache.onsettoreward.title = titlestr;
    xlabel('JS Onset to Reward (ms)'); ylabel('Number of Trajectories');
    cache.onsettoreward.xlabel = 'JS Onset to Reward (ms)';
    cache.onsettoreward.ylabel = 'Number of Trajectories';
    cache.onsettoreward.ylabel = 'Number of Trajectories';
    cache.onsettoreward.distribution =  js_to_rew_distr;
    cache.onsettoreward.times = timerange;
    stairs(timerange, js_to_rew_distr, 'g'); hold on;
end
cache.meanrewardtime = mean(rewtimes);
cache.medianrewardtime = median(rewtimes);
cache.stdevrewardtime = std(rewtimes);
if strcmp(statflag, 'stats')
    disp('mean reward hold time:')
    disp(cache.meanrewardtime);
    disp('median reward hold time:')
    disp(cache.medianrewardtime);
    disp('stdev reward hold time:')
    disp(cache.stdevrewardtime);
end


end

