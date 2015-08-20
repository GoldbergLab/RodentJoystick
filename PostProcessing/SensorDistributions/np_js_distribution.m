function [data, labels] = np_js_distribution(dirlist, varargin)
% [data, labels ] = np_js_distribution(dirlist, [interv, normalize, 
%   combineflag, smoothparam, plotflag, ax])
% 
%   plots the nose poke vs joystick touch time distribution
%   for the data from a given day. If multiple days are given, it
%   plots all data on the same axes
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
%       combine all data (1) or plot days individually (0)
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
colors = 'rgbkmcyrgbkmcyrgbkmcy';
default = {20, 1, 0, 1, 1, []};
numvarargs = length(varargin);
if numvarargs > 6
    error(['too many arguments (> 7), only one required ' ... 
            'and 6 optional.']);
end
[default{1:numvarargs}] = varargin{:};
[interv, normalize, combineflag, smoothparam, plotflag, ax] = default{:};
clear varargin; clear default; clear numvarargs;
%% Initialize Labels and some data
labels.xlabel = 'Time (ms)';
labels.ylabel = 'Probability';
labels.title = 'Nosepoke Joystick Touch Distribution';
if plotflag == 1 && length(ax) <1
        figure;
        ax(1) = gca();
end
if combineflag == 1
    data = cell(1, 1);
elseif combineflag == 0
    data = cell(length(dirlist), 1);
end
dist_time = -1000:interv:1000;

[statslist, dates] = load_stats(dirlist, combineflag, 'np_js');
labels.legend = dates;
for i=1:length(statslist)
    stats = statslist(i);
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


