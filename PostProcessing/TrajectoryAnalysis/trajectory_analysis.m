function [bin_summary, labels, lhandle] = trajectory_analysis(stats, varargin)
%[bin_summary, labels, graphgroups] = 
%   trajectory_analysis(stats, [derivflag, PLOT_RANGE,TIME_RANGE, CONTL, 
%       pflag, axeslst, color, multiflag])
%
%   plots trajectory profiles from stats using the (optional)
%   arguments for a hold time range, contigency lines, whether to actually 
%   plot data, string representation of the date, what group of statistics
%   to plot, and also a list of axes on which to plot the data
%   It returns the bin statistics, labels for the axes to be used in the gui,
%   and the figure handle, if no axes list was given.
%   EXAMPLE:  
%       trajectory_analysis(stats, 0)
%       trajectory_analysis(stats, 0, 4,[1000 1600], [400 40 40])
%
% OUTPUTS:
%
%   bin_summary :: a struct with the following fields:
%       lt, geq - bin contains all trajectories with hold times in
%           the length geq - lt (greater or equal to, and strictly less than)
%       md - double vector with median at each time point
%       upperbnd - double vector of 75th percentile at each time point
%       lowerbnd - double vector of 25th percentile at each time point
%       mean - double vector of mean at each time point
%       stdev - double vector of standard deviation at each time point
%       numbers - double vector containing percentage of trajectories
%           from bin used at each point. (time 0 will always be 100).
%
%   lhandle :: the line handle corresponding to the plot generated when
%           'plot' flag is used, otherwise empty
%
% ARGUMENTS:
%
%   stats :: the result from xy_getstats(jstruct) for some jstruct
%
% OPTIONAL ARGS:
%       
%   derivative ::  a flag indicating what data trajectory_analysis should
%       look at it
%       0 - Deviation (Trajectory Magnitude)
%       -- Currently Unsupported --
%       1 - Radial Velocity
%       2 - Radial Acceleration
%       3 - Velocity Magnitude
%       4 - Acceleration Magnitude
%
%       DEFAULT: 0
%       
%   plot_range :: number representing number of plots. 
%       DEFAULT: 4
%
%   hold_time_range :: the time range [A B] (ms) for which trajectories
%       are included, i.e. any trajectory with a hold time in the range
%       [A, B] is analyzed
%       DEFAULT: [400 1400]
%
%   plot_contingencies :: [HT T1 T2] this vector tells which lines to
%       indicate contingencies as a reference - 
%       HT is the hold time, T1 and T2 are the respective deviations 
%       EX: [300 30 60]
%       value of [0 0] or [0 0 0] doesn't plot any lines   
%       DEFAULT: [0 0 0] - no plotting 
%
%   pflag :: 1 if plots are desired, otherwise just returns bin statistics
%       DEFAULT: 1
%
%   smoothparam :: smoothing parameter (moving average window in ms)
%       DEFAULT: 1 (no smoothing)
%
%   axes_lst :: a list of axes handles of where to plot. If specified,
%       length(axes_lst) >= plot_range
%       DEFAULT: []
%
%   color :: color to plot all data with
%       DEFAULT: 'r'
%
%   multi :: 2 if both quartiles and percents should also be plotted
%       1 if just both quartiles in addition to median
%       0 plots just median (useful when multiple days prevents a clear
%       graph)
%       DEFAULT: 2

%% Argument Manipulation
default = {0, 4,[400 1400], [0 0 0], 1, 1, [], 'r', 2};
numvarargs = length(varargin);
if numvarargs > 9
    error('too many arguments (> 10), only one required and 9 optional.');
end
[default{1:numvarargs}] = varargin{:};
[derivflag, PLOT_RANGE,TIME_RANGE, CONTL, pflag, smoothparam, axeslst, color, multiflag] = default{:};

%% GENERATE AXES LIST
%if trajectory_analysis is given no axes handles, but expected to plot,
%generate its own figure & subplots
if pflag == 1 && length(axeslst)<1;
    figure('Position', [100, 100, 1440, 900]);
    for i = 1:PLOT_RANGE
        axeslst(i) = subplot(2, PLOT_RANGE/2, i);
    end
elseif pflag == 1 && (length(axeslst) < PLOT_RANGE)
    error('Not enough axes handles provided for desired number of bins');
end

%% BIN TRAJECTORIES
%divide the desired time range into number of bins based on number of plots
%desired
bin_length = (TIME_RANGE(2) - TIME_RANGE(1))/PLOT_RANGE;
bins=TIME_RANGE(1):bin_length:TIME_RANGE(2);
tstruct=stats.traj_struct; 
totaltraj = length(tstruct);
%perform processing
sortedtraj = sort_traj_into_bins(tstruct, bins);
labels.xlabel = 'Time(ms)';
labels.ylabel = 'Joystick Magnitude (mm)';


%% ITERATE OVER BINS, STATS AND PLOTTING
bin_summary = struct;
%plotting, and actual statistics
for i = 1:PLOT_RANGE
    bin = sortedtraj(i);
    [mean, median, stdev, numbers, upperbnd, lowerbnd] = bin_stats(bin, derivflag);
    %store computed data
    bin_summary(i).mean = mean; bin_summary(i).md = median;
    bin_summary(i).stdev = stdev;  bin_summary(i).upperbnd = upperbnd;
    bin_summary(i).lowerbnd = lowerbnd; 
    bin_summary(i).lt = bin.lt; bin_summary(i).geq = bin.geq;
    time = 1:1:length(numbers); 
    inittraj = numbers(1); numbers = 100*numbers./inittraj;
    bin_summary(i).numbers = numbers;
    bin_summary(i).trajcount = inittraj;
    bin_summary(i).alltrajcount = totaltraj;
    
    tstr = strcat(num2str(round(bin.geq)), '-', num2str(round(bin.lt)), ' ms:');
    percent = num2str(100*inittraj/totaltraj, 4); format bank;
    titlestr = [tstr, num2str(inittraj), ' trajectories, ', percent,' %'];
    labels.title{i} = titlestr;
    
    if pflag == 1
        axes(axeslst(i));
        ubd = upperbnd; lbd = lowerbnd; md = median;
        %ubd = mean+stdev; lbd = mean-stdev; md = mean;
        lhandle = plot(time, smooth(md, smoothparam), color, 'LineWidth', 1); hold on;
        if multiflag
            plot(time, smooth(ubd, smoothparam), color, 'LineStyle', ':');
            plot(time, smooth(lbd, smoothparam), color, 'LineStyle', ':');
        end
        if multiflag>1
            plot(time, numbers, color, 'LineStyle', '--');
        end
        title(axeslst(i), labels.title{i}, 'FontSize', 8); hold on;
        xlabel(axeslst(i), labels.xlabel); ylabel(axeslst(i), labels.ylabel);
        if sum(CONTL)>0
            CONTLINE_COLORS = [0.4, 0.4, 0.4];
            line([0 bin.lt], [CONTL(2) CONTL(2)], 'Color', CONTLINE_COLORS);
            if length(CONTL)>2
                line([0 bin.lt], [CONTL(3) CONTL(3)], 'Color', CONTLINE_COLORS);
            end
            line([CONTL(1) CONTL(1)], [0 100], 'Color', CONTLINE_COLORS);
        end
        if derivflag || ~derivflag
            axis(axeslst(i), [0, bin.lt, 0, 6.35]);
        end
    end
end
end

% mean, median, std are all numbers representing the statistic fpr a given
% time. upperbnd, lowerbnd are the 75th and 25th percentiles, respectively
%bin_summary is a large matrix representing each trajectory (number of rows
%corresponds to maximum trajectory length, and number of columns is number
%of trajectories)
function [avg, med, stdev, numbers, ... 
    upperbnd, lowerbnd, bin_summary] = bin_stats(bin, derivflag)
tstruct = bin.traj_struct;
datacell = arrayfun(@(tcell) extract_data(tcell, derivflag), tstruct, 'UniformOutput', 0);
max_length = max(cellfun(@length, datacell));
bin_summary = cellfun(@(tcell) [tcell, (-1)*ones(1, max_length-length(tcell))]', datacell, 'UniformOutput', 0);
bin_summary = cell2mat(bin_summary);

avg = zeros(max_length, 1); stdev = zeros(max_length, 1); numbers = zeros(max_length, 1);
med = zeros(max_length, 1);
upperbnd = zeros(max_length, 1); lowerbnd = zeros(max_length, 1);

for i = 1:max_length
    data = bin_summary(i, :);
    data = data(data>0);
    avg(i) = mean(data);
    stdev(i) = std(data);
    results = prctile(data, [75, 50, 25]);
    upperbnd(i) = results(1);
    med(i) = results(2);
    lowerbnd(i) = results(3);
    numbers(i) = length(data);
end
end 

function pos =  extract_data(tcell, derivflag)
    if derivflag == 0
        pos = tcell.magtraj; 
    elseif derivflag == 1
        pos = tcell.vel_mag(2:end); 
    elseif derivflag == 2
        pos = tcell.magtraj(time); 
    end
end