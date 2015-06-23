function [data, labels] = np_js_distribution(dirlist, varargin)
%np_js_distribution(dirlist, [interv, combineflag, plotflag, ax]) 
% plots the nose poke vs joystick touch time distribution
% for the data from a given day. If multiple days are given, it
% plots all data on the same axes
% ARGUMENTS:
%   dirlist :: list of directory structs (with name field)
%   interv :: histogram interval (optional, default 20ms)
%   combineflag :: if multiple jstructs are given, combines all data and
%       makes a single plot if 1, plots structs individually if 0
%       (optional, default 0)
%   plotflag :: whether to plot (1) or just return data (0)
%       (optional, default 1)
%   ax :: list of axes handles - plots all data (if multiple jstructs) on
%       the first element in ax. If no axes are given and plotflag is on,
%       creates a new figure (optional, default empty)
% OUTPUTS:
%   data :: cell array, where each cell is an n x 2 matrix representing the
%       dist_times and probability data at each bin
%   labels :: a struct containing the x, y, and title labels for plotting

%% Argument Handling
colors = 'rgbkmcyrgbkmcyrgbkmcy';
default = {20, 0, 1, [], colors(1)};
numvarargs = length(varargin);
if numvarargs > 5
    error(['too many arguments (> 6), only one required ' ... 
            'and five optional.']);
end
[default{1:numvarargs}] = varargin{:};
[interv, combineflag, plotflag, ax, combinecolor] = default{:};
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
else
    data = cell(length(dirlist), 1);
end
dist_time = -1000:interv:1000;

[statslist, dates] = load_stats(dirlist, combineflag);
labels.legend = dates;
for i=1:length(statslist)
    stats = statslist(i);
    np_js = histc(stats.np_js,dist_time);
    np_js = np_js./(sum(np_js));
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
        stairs(dist_time, np_js, colors(i), 'LineWidth', LINEWIDTH);
    end
    xlabel(labels.xlabel); ylabel(labels.ylabel);
    title(labels.title);
    legend(labels.legend);
    hold off;
end


