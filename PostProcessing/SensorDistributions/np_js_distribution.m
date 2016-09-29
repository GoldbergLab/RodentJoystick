function [data, labels,fig_handle] = np_js_distribution(dirlist, varargin)
% [data, labels ] = np_js_distribution(dirlist, [interv, normalize, 
%   combineflag, smoothparam, plotflag, ax])
% 
%   plots the nose poke vs joystick touch time distribution
%   for the data from a given day. If multiple days are given, it
%   plots all data on the same axes
%   Uses np_js_distribution
%
% ARGUMENTS:
%
%   dirlist :: list of directory structs (with name field)
%
% OPTIONAL ARGS:
%
%   interv :: histogram interval (ms)
%       DEFAULT: 20
%
%   normalize :: a 1/0 flag instructing whether to normalize the
%       distribution to a probability distribution, or keep raw counts.
%       DEFAULT : 1
%
%   combineflag :: if multiple directories are given, whether to 
%       combine all data (1) or plot directories individually (0), or to
%       group to days.
%       DEFAULT : 0
%
%   smoothparam :: parameter for smoothing distribution -does not affect
%       data, just visualization
%       DEFAULT : 1 (no smoothing)
%
%   plotflag :: whether to plot (1) or just return data (0)
%       DEFAULT : 1
%       
%   ax :: list of axes handles - plots all data (if multiple jstructs) on
%       the first element in ax. If no axes are given and plotflag is on,
%       creates a new figure
%       DEFAULT : []
%
% OUTPUTS:
%
%   data :: cell array, where each cell is an n x 2 matrix representing the
%       dist_times and probability data at each bin
%
%   labels :: a struct containing the x, y, and title labels for plotting

%% Argument Handling
colors = 'rbkmcgyrbkmcgyrbkmcgy';
default = {20, 1, 1, 0, 1, 1, []};
numvarargs = length(varargin);
if numvarargs > 7
    error(['too many arguments (> 8), only one required ' ... 
            'and 7 optional.']);
end
[default{1:numvarargs}] = varargin{:};
[interv, first_only, normalize, combineflag, smoothparam, plotflag, ax] = default{:};
clear varargin; clear default; clear numvarargs;
%% Initialize Labels and some data
labels.xlabel = 'Time (ms)';
labels.ylabel = 'Probability';
labels.title = 'Nosepoke Joystick Touch Distribution';

if length(ax) <1
        fig_handle = figure;
        ax(1) = gca();
end

if combineflag == 1
    data = cell(1, 1);
elseif combineflag == 0
    data = cell(length(dirlist), 1);
end
dist_time = -1000:interv:1000;

if first_only
    [statslist, dates] = load_stats(dirlist, combineflag,0, 'np_js_nc');
else
    [statslist, dates] = load_stats(dirlist, combineflag,0, 'np_js');
end

labels.legend = dates;
for i=1:length(statslist)
    if first_only
        stats.np_js = statslist(i).np_js_nc;
    else
        stats.np_js = statslist(i).np_js;
    end
    
    np_js = histc(stats.np_js,dist_time);
    if normalize 
        np_js = np_js./(sum(np_js));
    end
    data{i} = [dist_time', np_js];
end

%% Plot data
if plotflag == 1
    axes(ax(1));
    hold on;
    if length(data)==1; LINEWIDTH = 2; else LINEWIDTH = 1; end;
    for i = 1:length(data)
        tmpdata = data{i};
        dist_time = tmpdata(:, 1);
        np_js = tmpdata(:, 2);
        stairs(dist_time, smooth(np_js, smoothparam), colors(i), 'LineWidth', LINEWIDTH);
    end
    xlabel(labels.xlabel); ylabel(labels.ylabel);
    title(labels.title);
    legend(labels.legend);
    hold off;
end


