function [data, labels] = np_post_distribution(dirlist, varargin)
%np_post_distribution(dirlist, [interv, combineflag, plotflag, ax, combinecolor]) 
%   
%   plots the nose poke vs post touch time distribution
%   for the data from a given day. If multiple days are given, it
%   plots all data on the same axes.
%
% ARGUMENTS:
%
%   dirlist :: list of directory structs (with name field)
%
% OPTIONAL ARGS
%
%   interv :: histogram interval (optional, default 20ms)
%
%   combineflag :: if multiple jstructs are given, combines all data and
%       makes a single plot if 1, plots structs individually if 0
%       (optional, default 0)
%
%   plotflag :: whether to plot (1) or just return data (0)
%       (optional, default 1)
%
%   ax :: list of axes handles - plots all data (if multiple jstructs) on
%       the first element in ax. If no axes are given and plotflag is on,
%       creates a new figure (optional, default empty)
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
%% Initialize Labels and some data
labels.xlabel = 'Time (ms)';
labels.ylabel = 'Probability';
labels.title = 'Nosepoke Post Distribution';
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
    np_js_post = histc(stats.np_js_post,dist_time);
    if normalize
        np_js_post = np_js_post ./(sum(np_js_post));
    end
    data{i} = [dist_time', smooth(np_js_post, smoothparam)];
end

%% Plot data
if plotflag == 1
    axes(ax(1));
    hold on;
    if length(data)==1; LINEWIDTH = 2; else LINEWIDTH = 1; end;
    for i = 1:length(data)
        tmpdata = data{i};
        dist_time = tmpdata(:, 1);
        np_js_post = tmpdata(:, 2);
        stairs(dist_time, np_js_post, colors(i), 'LineWidth', LINEWIDTH);
    end
    xlabel(labels.xlabel); ylabel(labels.ylabel);
    title(labels.title);
    legend(labels.legend);
    hold off;
end


