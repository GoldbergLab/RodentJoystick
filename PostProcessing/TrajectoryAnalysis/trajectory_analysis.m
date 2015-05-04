%[sortedtraj, fh, cache] = 
%   trajectory_analysis(stats) OR trajectory_analysis(stats, plot_range, ... )
%   OPTIONAL ARG ORDER:
%       plot_range,hold_time_range,pflag, plot_contingencies, datestr,sflag
%   plots the trajectory distributions from stats using the (optional)
%   arguments for a hold time range, whether or not to plot, whether to
%   plot the lines indicating the contigencies (constants just below the
%   function header), and the string representation of the date
%   It also returns fh, the figure handle, if plotted - otherwise fh is not
%   assigned
%   EXAMPLE:  
%       trajectory_analysis(stats,4)
%       trajectory_analysis(stats,4,[1000 1600], [400 40 40])
%   OUTPUTS:
%       sortedtraj :: a struct with the following fields:
%
%       fh :: the figure handle corresponding to the plot generate when
%           'plot' flag is used, otherwise unassigned
%       cache :: used for post processing gui
%   ARGUMENTS: 
%       stats :: the result from xy_getstats(jstruct) for some jstruct
%       OPTIONAL ARGS:
%       plot_range :: number representing number of plots. DEFAULT: 10
%       hold_time_range :: the time range [A B] (ms) for which plots are
%           generated. Plots start at time A and end at B
%           DEFAULT: [400 1400]
%       plot_contingencies :: [HT T1 T2] this vector tells which lines to
%           plot - HT is the hold time, T1 and T2 are the respective
%           deviations (i.e. 30 60)
%           value of [0 0] or [0 0 0] doesn't plot any lines
%           DEFAULT: [300 30 60] - no plotting 
%       pflag :: 'plot' if plot is desired, otherwise just returns
%           binned trajectories in sortedtraj
%           DEFAULT: 'plot'
%       datestr :: string representation of the date, used for title
%           DEFAULT: 'N/A'
%       sflag :: optional argument that tells what group of statistics to
%           plot. 'median' - plots median and first/third quartiles,
%           'mean'- plots mean and mean+/- stdev, 'both' - plots both
%           groups
%           DEFAULT: 'median'
function [sortedtraj, fh, cache] = trajectory_analysis(stats, varargin)
%how many plots to do - this depends on other stuff, look through
%below as well. Look through subplotting routine to make sure nothing
%critical is changed

default = {10,[400 1400], [300 30 60], 'plot', 'N/A', 'median', 'no'};
numvarargs = length(varargin);
if numvarargs > 7
    error('trajectory_analysis: too many arguments (> 8), only one required and seven optional.');
end
[default{1:numvarargs}] = varargin{:};
[PLOT_RANGE,TIME_RANGE, CONTL, pflag, datestr, sflag, cacheflag] = default{:};
%divide the desired time range into number of bins based on number of plots
%desired
bin_length = (TIME_RANGE(2) - TIME_RANGE(1))/PLOT_RANGE;
bins=TIME_RANGE(1):bin_length:TIME_RANGE(2);
tstruct=stats.traj_struct; 
totaltraj = length(tstruct);
%[~,~,~, rw_or_stop] = hold_time_distr(tstruct, bin_length, 'data');
%sortedtraj = sort_traj_into_bins(tstruct, bins, rw_or_stop);
hts = hold_time_distr(tstruct, bin_length, 'data');
sortedtraj = sort_traj_into_bins(tstruct, bins, hts);

%sometimes we only want the data from sorted traj, hence the option not to
%plot
if strcmp('plot', pflag)
    fh = figure('Position', [100, 100, 1440, 900]);
    for i = 1:PLOT_RANGE
        bin = sortedtraj(i);
        [mean, median, stdev, numbers, upperbnd, lowerbnd] = bin_stats(bin);
        cache(i).upperbnd = upperbnd; cache(i).lowerbnd = lowerbnd;
        cache(i).median = median; cache(i).mean = mean; cache(i).stdev=stdev;
        cache(i).time = 1:1:length(numbers);
        inittraj = numbers(1); cache(i).numbers = 100*numbers./inittraj;
        tstr = strcat(num2str(bin.geq), '-', num2str(bin.lt), ' ms:');
        percent = num2str(100*inittraj/totaltraj, 4); format bank;
        cache(i).title = [tstr, num2str(inittraj), ' trajectories, ', percent,' %'];
        cache(i).axis = [0, bin.lt, 0, 100];
        cache(i).xlabel = 'Time(ms)'; cache(i).ylabel = 'Joystick Mag/Traj Percentage';
        cache(i).contigency = CONTL;
        cache(i).legend_flag = sflag;
        %entire block below can be copied to plot from cache in gui
        if strcmp(cacheflag, 'no')
        subplot(2, PLOT_RANGE/2, i);
        title(cache(i).title, 'FontSize', 8); hold on;
        axis(cache(i).axis); ylabel(cache(i).ylabel); xlabel(cache(i).xlabel);
        CONTL = cache(i).contingency;
        if sum(CONTL)>0
            CONTLINE_COLORS = [0.4, 0.4, 0.4];
            line([0 2000], [CONTL(2) CONTL(2)], 'Color', CONTLINE_COLORS);
            if length(CONTL)>2
                line([0 2000], [CONTL(3) CONTL(3)], 'Color', CONTLINE_COLORS);
            end
            line([CONTL(1) CONTL(1)], [0 100], 'Color', CONTLINE_COLORS);
        end
        time = cache(i).time; ubd = cache(i).upperbnd; lbd = cache(i).lowerbnd;
        md = cache(i).median; me = cache(i).mean; stdv = cache(i).stdev;
        if strcmp(sflag, 'median')
            plot(time, ubd, 'r', time, md, 'g', time, lbd, 'r'); hold on;
        elseif strcmp(sflag, 'mean')
            plot(time, me+stdv, 'y', time, me, 'b', time, me-stdv, 'y'); hold on;
        else
            plot(time, ubd, 'r', time, md, 'g', time, lbd, 'r'); hold on;
            plot(time, me+stdv, 'y', time, me, 'b', time, me-stdv, 'y'); hold on;
        end
        plot(time, cache(i).numbers, ':c');
        end
        end
    end
    if strcmp(cacheflag, 'no')
        if strcmp(sflag, 'median')
            legend('3rd quartile','median', '1st quartile');
        elseif strcmp(sflag, 'mean')
            legend('mean+stdev','mean', 'mean-stdev');
        else
            legend('3rd quartile','median', '1st quartile', 'mean+stdev','mean', 'mean-stdev');
        end
        P = subplottitle(fh, datestr, 'yoff', -0.6);
    end
end
end

%bin_summary is a struct with length bin.lt 
%   bin_summary has the following fields (for each time i)(different from the outputs!!!): 
%       position := a vector of magnitudes corresponding to the various trajectories at time i.
%       avg := single value corresponding to the average position at that
%           time
%       med := single value of median position at that time
%       stdev := a single value that corresponds to the standard deviation
%           at the time i
%       numtraj := number of trajectories that lasted at least as long as
%       time i.
% mean, median, std are all numbers representing the statistic in a given
% time. upperbnd, lowerbnd are the 75th and 25th percentiles, respectively
function [avg, med, stdev, numbers, upperbnd, lowerbnd, bin_summary] = bin_stats(bin)
    for time = 1:(bin.lt-1) 
        time_pos_ind = 0;
        for i = 1:(length(bin.trajectory))
            try 
                pos = bin.trajectory(i).magtraj(time); 
                %attempt to access the position of trajectory i at time
            catch
                pos = -1000; % error signal if trajectory doesn't go that far
            end
            if pos > -1
                time_pos_ind = time_pos_ind+1;
                bin_summary(time).position(time_pos_ind) = pos;
            end
        end
        try
            positionvec = bin_summary(time).position;
            bin_summary(time).numtraj = time_pos_ind;
            bin_summary(time).avg = mean(positionvec);
            bin_summary(time).med = median(positionvec);
            bin_summary(time).stdev = std(positionvec);
            bin_summary(time).upperbnd = prctile(positionvec,75);
            bin_summary(time).lowerbnd = prctile(positionvec,25);
            
            numbers(time)= bin_summary(time).numtraj;
            avg(time) = bin_summary(time).avg;
            med(time) = bin_summary(time).med;
            stdev(time) = bin_summary(time).stdev;
            upperbnd(time) = bin_summary(time).upperbnd;
            lowerbnd(time) = bin_summary(time).lowerbnd;
        catch
            avg(time) = 0; med(time) = 0; stdev(time) = 0; numbers(time) = 0; upperbnd(time)=0;lowerbnd(time)=0; 
        end
    end
end

% will be a vector of structs containing fields for the range
% each struct has a field for a vector of structs containing
% trajectories
function sortedtraj = sort_traj_into_bins(tstruct, bins, holdtimes)

for i = 2:length(bins)
   sortedtraj(i-1) = struct('geq', bins(i-1),'lt',bins(i));
end
bin_traj_indices = ones(length(bins)-1, 1); 
%each bin has a vector of trajectory structures (simplified from tstruct)
% store the indices so we know at what index to add each new trajectory
for i = 1:length(holdtimes)
    bin_ind = bin_index(bins, holdtimes(i));
    if bin_ind ~= -1
        traj_ind = bin_traj_indices(bin_ind);
        bin_traj_indices(bin_ind) = bin_traj_indices(bin_ind) + 1;
        sortedtraj(bin_ind).trajectory(traj_ind)= struct('magtraj', tstruct(i).magtraj(1:tstruct(i).rw_or_stop), 'time', holdtimes(i));
    end
end
end

% Bin indexing starts with 1 at the first nonzero element. Ie, If the bins
% are distributed as bins = [0 10 20 30 40],
%       bin_index(bins, 5) = 1, bin_index(bins 0) = 1
%       bin_index(bins, 9) = 1, bin_index(bins 10) = 2
function bin_ind = bin_index(bins, time)
    bin_ind = -1;
    for i = 2:length(bins)
        if time < bins(i) && time >= bins(i-1)
            bin_ind = i-1; break;
        end
    end
end