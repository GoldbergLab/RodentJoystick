function [holdtimes,ht_distr, phandle, rewht_distr] = hold_time_distr(tstruct, hist_int, varargin)
%hold_time_distr plots the distribution of hold times with a histogram
%   interval specified by hist_int on a time range of 0 to TIME_RANGE
%   milliseconds
% ARGUMENTS:
%   tstruct :: structure containing all the information about each
%       trajectory. NOT the same as jstruct - after running
%       stats = xy_getstats, tstruct = stats.traj_struct
%   hist_int :: size of the bins for data generation and histogram plotting
%   plotflag :: flag that tells hold_time_distr whether to generate data or
%       plot - 'plot' - plots the figure, 'data' - just returns data
%       without plotting
default = {'none', 'none', 2000};
numvarargs = length(varargin);
if numvarargs > 3
    error('multi_time_distr: too many arguments (> 4), only two required and two optional.');
end
[default{1:numvarargs}] = varargin{:};
[plotflag, statflag, TIME_RANGE] = default{:};

holdtimes = zeros(length(tstruct), 1);
rewtimes = []; j =1;
for i = 1:length(tstruct)
    holdtimes(i) = length(tstruct(i).magtraj);
    if tstruct(i).rw == 1
        rewtimes(j) = length(tstruct(i).magtraj);
        j=j+1;
    end
end
timerange = 0:hist_int:TIME_RANGE;
[ht_distr] = histc(holdtimes, timerange);
rewht_distr = histc(rewtimes, timerange);

%boring stuff below, just plotting/displaying information
if strcmp(plotflag, 'plot')
    phandle = figure(1);
    hold on;
    xlabel('Hold Time (ms)');
    ylabel('Number of Trajectories'); 
    title('Hold Time Distributions'); hold on;
    stairs(timerange, ht_distr, 'b');
    hold on;
    stairs(timerange, rewht_distr, 'r');
    hold on;
    legend('all', 'rewarded only');
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

