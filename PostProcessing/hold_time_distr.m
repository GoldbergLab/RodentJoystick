function [holdtimes,rewtimes,js2rew, phandle, rew_handle] = hold_time_distr(tstruct, hist_int, varargin)
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

%Actually get data now, just looping over tstruct
holdtimes = zeros(length(tstruct), 1);
rewtimes = []; j =1;
js2rew = [];
for i = 1:length(tstruct)
    holdtimes(i) = length(tstruct(i).magtraj);
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
js_to_rew_distr = histc(js2rew, timerange);

%boring stuff below, just plotting/displaying information
if strcmp(plotflag, 'plot')
    phandle = figure(1); hold on;
    xlabel('Hold Time (ms)'); ylabel('Number of Trajectories'); 
    title('Hold Time Distributions'); hold on;
    stairs(timerange, ht_distr, 'b'); hold on;
    stairs(timerange, rewht_distr, 'r'); hold on;
    legend('all', 'rewarded hold times');
    
    rew_handle = figure(2); hold on;
    title('Joystick Onset Time to Reward Time Distributions');
    xlabel('JS Onset to Reward (ms)'); ylabel('Number of Trajectories'); 
    stairs(timerange, js_to_rew_distr, 'g'); hold on;
    
end
if strcmp(statflag, 'stats')
    disp('mean reward hold time:')
    disp(mean(rewtimes));
    disp('median reward hold time:')
    disp(median(rewtimes));
    disp('stdev reward hold time:')
    disp(std(rewtimes));
end


end

