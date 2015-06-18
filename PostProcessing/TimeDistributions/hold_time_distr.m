function [holdtimes,rewtimes,js2rew, rw_or_stop, labels] = hold_time_distr(tstruct, hist_int, varargin)
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
default = {'plot', 'none', 2000, 'no'};
numvarargs = length(varargin);
if numvarargs > 4
    error('hold_time_distr: too many arguments (> 5), only two required and four optional.');
end
[default{1:numvarargs}] = varargin{:};
[plotflag, statflag, TIME_RANGE, cache_flag] = default{:};
phandle = [];

%Actually get data now, just looping over tstruct
holdtimes = zeros(length(tstruct), 1);
rw_or_stop = zeros(length(tstruct), 1);
rewtimes = []; j =1;
js2rew = [];
for i = 1:length(tstruct)
    holdtimes(i) = length(tstruct(i).magtraj(1:tstruct(i).rw_or_stop)); %Teja 
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
    titlestr=['Hold Time Distributions: ', num2str(length(holdtimes)), ' trajectories'];
    labels.holdtimedistr.title=titlestr;
    labels.holdtimedistr.xlabel = 'Hold Time (ms)';
    labels.holdtimedistr.ylabel = 'Trajectory Distributions';
    labels.holdtimedistr.holdtimedistr = ht_distr./(sum(ht_distr));
    labels.holdtimedistr.rewarddistr = rewht_distr./(sum(rewht_distr));
    labels.holdtimedistr.times = timerange;
    labels.holdtimedistr.legend={'all'; 'reward distribution'};

    titlestr=['Rewarded Trajectory Rate: ', num2str(length(rewtimes)), ' trajectories'];
    labels.rewardrate.title=titlestr; 
    labels.rewardrate.times =  timerange;
    labels.rewardrate.reward_rates =  rewht_distr./ht_distr;
    labels.rewardrate.axis = [0 inf 0 1];
    labels.rewardrate.xlabel = 'Hold Time (ms)';
    labels.rewardrate.ylabel = 'Reward Rate Percentage for Hold Time';
    
    titlestr = 'Joystick Onset Time to Reward Time Distributions';
    labels.onsettoreward.title = titlestr;
    labels.onsettoreward.xlabel = 'JS Onset to Reward (ms)';
    labels.onsettoreward.ylabel = 'Number of Trajectories';
    labels.onsettoreward.distribution =  js_to_rew_distr;
    labels.onsettoreward.times = timerange;
    if strcmp(cache_flag, 'no')
    NUM_PLOTS=3; 
    figure; hold on;
    subplot(NUM_PLOTS,1,1);hold on;
    xlabel(labels.holdtimedistr.xlabel); ylabel(labels.holdtimedistr.ylabel);
    stairs(timerange, labels.holdtimedistr.holdtimedistr, 'b'); hold on;
    stairs(timerange, labels.holdtimedistr.rewarddistr, 'r'); hold on;
    title(labels.holdtimedistr.title); hold on;
    legend(labels.holdtimedistr.legend{1}, labels.holdtimedistr.legend{2});
    
    subplot(NUM_PLOTS,1,2); hold on;
    title(labels.rewardrate.title); hold on; 
    axis(labels.rewardrate.axis); 
    xlabel(labels.rewardrate.xlabel); ylabel(labels.rewardrate.ylabel); 
    stairs(labels.rewardrate.times, labels.rewardrate.reward_rates, 'r'); hold on;

    subplot(NUM_PLOTS,1,3); hold on;
    title(labels.onsettoreward.title);
    xlabel(labels.onsettoreward.xlabel); ylabel(labels.onsettoreward.ylabel);
    stairs(labels.onsettoreward.times, labels.onsettoreward.distribution, 'g'); hold on;
    end
end
labels.meanrewardtime = mean(rewtimes);
labels.medianrewardtime = median(rewtimes);
labels.stdevrewardtime = std(rewtimes);
if strcmp(statflag, 'stats')
    disp('mean reward hold time:')
    disp(labels.meanrewardtime);
    disp('median reward hold time:')
    disp(labels.medianrewardtime);
    disp('stdev reward hold time:')
    disp(labels.stdevrewardtime);
end


end

