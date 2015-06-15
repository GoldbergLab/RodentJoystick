function [data, labels] = np_post_distribution(jslist, varargin)
%np_post_distribution(jslist [interv, ax, combineflag, plotflag]) 
% plots the nose poke vs post touch time distribution
% for the data from a given jstruct. If multiple jstructs are given, it
% plots all data on the same axes
% ARGUMENTS:
%   jslist :: list of jstructs - may contain a single jstruct
%   interv :: histogram interval (optional, default 20ms)
%   ax :: list of axes handles - plots all data (if multiple jstructs) on
%       the first element in ax. If no axes are given and plotflag is on,
%       creates a new figure (optional, default empty)
%   combineflag :: if multiple jstructs are given, combines all data and
%       makes a single plot if 1, plots structs individually if 0
%       (optional, default 0)
%   plotflag :: whether to plot (1) or just return data (0)
%       (optional, default 1)
% OUTPUTS:
%   data :: cell array, where each cell is an n x 2 matrix representing the
%       dist_times and probability data at each bin
%   labels :: a struct containing the x, y, and title labels for plotting

%% Argument Handling
default = {20, 0, 1, []};
numvarargs = length(varargin);
if numvarargs > 4
    error(['too many arguments (> 5), only one required ' ... 
            'and four optional.']);
end
[default{1:numvarargs}] = varargin{:};
[interv, combineflag, plotflag, ax] = default{:};
%% Initialize Labels and some data
colors = 'rgbkmcyrgbkmcyrgbkmcy';
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
    data = cell(length(jslist), 1);
end
dist_time = -1000:interv:1000;

%% Plot jstructs individually
if combineflag==0
    for i= 1:length(jslist)
        load(jslist(i).name);
        labels.legend{i} = datestr(jstruct(2).real_time, 'mm/dd/yyyy');

        %processing
        stats = xy_getstats(jstruct);
        np_post_plot = histc(stats.np_js_post,dist_time);
        np_post_plot = np_post_plot./(sum(np_post_plot));
        data{i} = [dist_time', np_post_plot];
        if plotflag==1
            stairs(ax(1), dist_time,np_post_plot, colors(i), 'LineWidth',2, 'LineStyle',':');
            hold on;
        end
    end
    if plotflag == 1
        xlabel(labels.xlabel); ylabel(labels.ylabel); title(labels.title);
        legend(labels.legend);
        hold on;
    end
    hold off;

else
%% Plot jstructs combined data
    combined = [];
    for i= 1:length(jslist)
        load(jslist(i).name);
        combined = [combined, jstruct];
        labels.legend{i} = datestr(jstruct(2).real_time, 'mm/dd/yyyy');
    end
    stats = xy_getstats(combined);
    np_post_plot = histc(stats.np_js_post,dist_time);
    np_post_plot = np_post_plot./(sum(np_post_plot));
    data{1} = [dist_time', np_post_plot];
    if plotflag == 1
        stairs(ax(1), dist_time,np_post_plot, colors(1), 'LineWidth', 2);
        xlabel(labels.xlabel); ylabel(labels.ylabel); title(labels.title);
        legend([labels.legend{1}, '-', labels.legend{end}])
    end
end


