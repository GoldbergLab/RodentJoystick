
% [np_plot, rew_plot, day, times] 
%   = generate_time_distr(jstruct, [interval, plotflag, ax, color])
%   takes in the jstruct as an argument and either generates 
%   (1) plots of the nose poke and reward distributions over time
% or(2) data of the nose poke, reward, and times for further
%         manipulation or plotting
% ARGUMENTS:
%   jstruct :: the jstruct with data
%       PRE: must have datetime, reward_onset, and np_pairs fields
%   interval :: the interval used for generating data/histogram bins (minutes)
%       PRE: must be greater than 0 (should also be an integer for
%           meaningful results)
%   normalize :: flag indicating whether to normalize plots to a
%   distribution or not.
%   plotflag:: the flag indicating what generate_time_distr should do
%       1 - creates a plot on figure (fignum) with title day 
%       0 - returns data of nose_poke, reward, and times for
%           further manipulation/plotting
%   ax:: handle to an axes for plotting - must be a valid handle if
%       nonempty
%   color :: string representation of color to plot with
% OUTPUTS: [np_plot, rew_plot, day, times]
%   times:: array of time of data collection, in hours
%       can be relative (0 is start time of data collection) or absolute
%       (0 is 12am) depending on use of 'delay' argument
%   day :: day of data collection/jstruct - using Matlab reference time (an
%       integer on the order of 10^5)
%   np_plot :: vector of nose poke distributions for a histogram plot
%   rew_plot:: vector of reward distributions for a histogram plot

      
function [np_plot, rew_plot, day, times, labels] = generate_time_distr(jstruct, varargin)
default = {15, 0, 1, 0, [], 'r'};
numvarargs = length(varargin);
if numvarargs > 6
    error(['too many arguments (> 7), only one required ' ... 
            'and six optional.']);
end
[default{1:numvarargs}] = varargin{:};
[interval, normalize, plotflag, rewonly, ax, color] = default{:};
if plotflag == 1 && length(ax) <1; figure; ax(1) = gca(); end

interval = interval*60;
[times, np_plot, rew_plot, day] = gen_final_data(jstruct, interval);
labels.day = day;
labels.title = 'Activity Distribution';
labels.xlabel = 'Time (hours)';
labels.ylabel = 'Count';
labels.legend{1} = strcat(datestr(floor(day), 'mm/dd/yy'),' - Nosepoke'); 
labels.legend{2} = strcat(datestr(floor(day), 'mm/dd/yy'),' - Reward');
if plotflag == 1
    line = plot_data(ax, times, np_plot, rew_plot, labels, color, normalize, rewonly);
end
labels.line = line;
end

% gen_final_data (jstruct, int) gives the following vectors
% OUTPUT: 
%   times:: vector of times from start to end of day (in hours)
%   np_plot :: vector of distributions used to generate histogram plot
%   rew_plot:: vector of reward distributions used to generate histogram plot
% ARGUMENTS: 
%   sens_on - accumalated list of times from sensor - nose poke or reward
%   histint - size of bins on desired histogram (a time in seconds)
function [times, np_data, rew_data, day] = gen_final_data(jstruct, int)
    %essentially accumulated raw data below
    [nptime, day] = gen_nptime(jstruct);
    rewtime = gen_rewtime(jstruct);
    %here we process and put the data into bins
    times = (0:int:86400);
    [np_data] = histc(nptime, times);
    [rew_data] = histc(rewtime, times);
    times = times./3600;
end

% gen_hist_data (senson, histint) gives the following vectors
% OUTPUT: 
%   times:: vector of times from start to end of day (in seconds)
%   on :: times sensor comes on put into bins for histogram plotting
% ARGUMENTS: 
%   sens_on - accumalated list of times from sensor - nose poke or reward
%   histint - size of bins on desired histogram (a time in seconds)

% [seconds, day] = seconds_since_start(real_time)
% takes the matlab datenum double time format and gives:
% OUTPUT:
%       seconds: num seconds elapsed since start of day
%       day: day number using Matlab reference time - (an integer)
function [seconds, day] = seconds_since_start(real_time)
    day = floor(real_time);
    dtime = real_time - day;
    seconds = dtime*86400;
end

% [nptime, day] = gen_nptime(jstruct) generates:
% OUTPUT: 
%   nptime :: list of nose poke times that occurred during the entire day,
%       in seconds
%   day :: day number, using MATLAB reference time (an integer) of the data
function [nptime, day] = gen_nptime(jstruct)
    nptime = [];
    for i = 1:length(jstruct)
        temp = jstruct(i).np_pairs;
        if length(temp) >= 1
            temp = temp(:, 1);
            [seconds, day] = seconds_since_start(jstruct(i).real_time);
            temp = temp./1000+seconds;
            nptime = [nptime; temp];
        end
    end
    nptime = nptime;
end

% [rewtime, day] = gen_rewtime(jstruct) generates:
% OUTPUT: 
%   rewtime :: list of reward times that occurred during the entire day,
%       in seconds
%   day :: day number, using MATLAB reference time (an integer) of the data
function [rewtime, day] = gen_rewtime(jstruct)
    rewtime = [];
    for i = 1:length(jstruct)
       rewt = jstruct(i).reward_onset./1000;
       rewt = rewt';
       if length(rewt) >= 1
           [seconds, day] = seconds_since_start(jstruct(i).real_time);
           rewtime = [rewtime; (rewt + seconds)];
       end
    end
    rewtime = rewtime;
end

% plot_sensor_on(times, ontimes, label, fig, day) plots the sensor data
% time distribution on the figure fig
% OUTPUTS:
%   plot :: handle to the figure generated
% INPUTS:
%   times :: time range of data (entire day, in hours)
%   np_data :: time data in histogram bins for nosepoke
%   rew_data :: time data in histogram bins for reward
%   Note: all testing done with times as seconds, but other units of time
%       probably would work
%   label :: string labeling the y-axis
%   day :: an integer representing the MATLAB day
% and ontimes, the time when the sensor comes on
function line = plot_data(ax, times, np_plot, rew_plot, labels, color, normalize, rewonly)
    axes(ax);
    hold on;
    xlabel(labels.xlabel);
    title(labels.title);
    if normalize == 1
        try
            rew_plot = rew_plot/np_plot;
        catch
            rew_plot = zeros(length(np_plot), 1);
        end
        np_plot = np_plot/sum(np_plot);
    end
    if ~rewonly
        line = stairs(times, np_plot, color);
        disp(size(line));
        stairs(times, rew_plot, color, 'LineStyle', ':');
    else
        line = stairs(times, rew_plot, color);
        disp(size(line));
    end
    %legend(labels.legend{1}, labels.legend{2});
    legend('boxoff');
    axis([0, 24, 0, inf]);
    x = [0, 4, 8, 12, 16, 20, 24];
    set(gca,'XTick',x);
    hold off;
end

