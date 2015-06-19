function [data, labels] = holdtime_firstcontact_distribution(jslist, varargin)
%holdtime_firstcontact_distribution(jslist, [dist_thresh, interv, combineflag, plotflag, ax]) 
% plots the hold time distribution
% for the data from a given jstruct. If multiple jstructs are given, it
% plots all data on the same axes.
% ARGUMENTS:
%   jslist :: list of structs containing filenames like the output of rdir
%       - may contain a single struct - this is not the same as a list of
%       jstructs
% OPTIONAL ARGS:
%   dist_thresh :: the distance threshold desired. 
%       DEFAULT: 150 (plots everything)
%   interv :: histogram interval (ms)
%       DEFAULT: 20 
%   combineflag :: if multiple jstructs are given, combines all data and
%       makes a single plot if 1, plots structs individually if 0
%       DEFAULT :: 0
%   normalize :: normalizes each plot to its sum to allow comparison of
%       distributions (1 normalizes, 0 doesn't)
%       DEFAULT :: 0
%   plotflag :: whether to plot (1) or just return data (0)
%       DEFAULT :: 1
%   ax :: list of axes handles - plots all data (if multiple jstructs) on
%       the first element in ax. If no axes are given and plotflag is on,
%       creates a new figure 
%       DEFAULT :: []
% OUTPUTS:
%   data :: cell array, where each cell is an n x 2 matrix representing the
%       dist_times and probability data at each bin
%   labels :: a struct containing the x, y, and title labels for plotting

%% Argument Handling
default = {150, 20, 0, 0, 1, []};
numvarargs = length(varargin);
if numvarargs > 6
    error(['too many arguments (> 7), only 1 required ' ... 
            'and 6 optional.']);
end
[default{1:numvarargs}] = varargin{:};
[dist_thresh, interv, combineflag, normalize, plotflag, ax] = default{:};
%% Initialize Labels and some data
colors = 'rgbkmcyrgbkmcyrgbkmcy';
labels.xlabel = 'Time (ms)';
labels.ylabel = 'Trials Count';
labels.title = ['Max Hold Times Under ',num2str(dist_thresh),' Distribution'];
if plotflag == 1 && length(ax) <1
        figure;
        ax(1) = gca();
end
if combineflag == 1; data = cell(1, 1); else data = cell(length(jslist), 1); end
dist_time = 0:interv:1000;
LINEWIDTH = 1;
%% Get individual data
if combineflag==0
    for i= 1:length(jslist)
        load(jslist(i).name);
        labels.legend{i} = datestr(jstruct(2).real_time, 'mm/dd/yy');
        %processing now
        [~,hold_dist]=xy_holddist(jstruct,dist_thresh,0.75);
        holddist_vect = histc(hold_dist,dist_time);
        if normalize == 1
            holddist_vect = holddist_vect./sum(holddist_vect);
        end
        data{i} = [dist_time', holddist_vect'];
    end
else
    LINEWIDTH=2;
%% Get jstructs combined data
    combined = [];
    for i= 1:length(jslist)
        load(jslist(i).name);
        combined = [combined, jstruct];
        labels.legend{i} = datestr(jstruct(2).real_time, 'mm/dd/yy');
    end
    labels.legend = {[labels.legend{1},'-',labels.legend{end}]};
    [~,hold_dist]=xy_holddist(combined,dist_thresh,0.75);
    holddist_vect = histc(hold_dist,dist_time);
    if normalize == 1
        holddist_vect = holddist_vect./sum(holddist_vect);
    end
    data{1} = [dist_time', holddist_vect'];
end
if plotflag==1
    axes(ax(1));hold on;
    for i = 1:length(data)
        stuff = data{i};
        dist_time = stuff(:, 1);
        holddist_vect = stuff(:, 2);
        stairs(dist_time, holddist_vect, colors(i), 'LineWidth',LINEWIDTH);
    end
    xlabel(labels.xlabel); ylabel(labels.ylabel); title(labels.title);
    legend(labels.legend);
    hold off;
end

