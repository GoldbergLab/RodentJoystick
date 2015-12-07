% multi_time_distr(dirlist[, interval, layout, combineflag, lim, ax]) generates 
%
%   histogram time distributions of nosepokes and rewards for all jstructs 
%   in the list dirlist - only dirlist is a required argument, rest
%   are optional
%
% ARGUMENTS:
%
%   dirlist :: a list of files referring to saved (and post processed) dir:
%       Ex: dirlist(1).name = 'K:\expt4\expt_4_0004_16\Box_2\2_18_2015'
%
% OPTIONAL:
%
%   interval :: interval of time in minutes for histogram bin size 
%       positive nonzero integer
%
%   layout :: flag tells multi_time_distr whether to put all plots on a
%       single figure or on its own subplot
%       'single' :: put each plot on the same figure
%       'col' :: put each plot on a single figure in a column
%
%   combineflag :: 
%       if 'single' is selected, combines data when 1, and plots individually if 1.
%       otherwise does nothing
%
%   normalize :: normalizes to a distribution summing to 1 for each plot
%       (1), or alternatively leaves as is (0)
%
%   rewonly :: flag that enabled plots only reward rate by time (1)
%
%   ylim :: changes the y-axis limit for all plots if 'col' is selected.
%       otherwise does nothing
%
%   ax :: axes for what to plot data on.
%
% OUTPUTS: None

function [data, labels] = multi_time_distr(dirlist, varargin)
    %Default argument handling:
default = {30, 'single', 0, 0, 0, Inf, []};
numvarargs = length(varargin);
if numvarargs > 7
    error('too many arguments (> 8), only one required and 7 optional.');
end
[default{1:numvarargs}] = varargin{:};
%normal code from here on
[interval, layout, combineflag, normalize, rewonly, ylim, ax] = default{:};
if strcmp(layout,'single')
    [data, labels] = multi_time_distr_single(dirlist, interval, combineflag, ax, normalize, rewonly);
elseif strcmp(layout,'col')
    [data, labels] = multi_time_distr_multi(dirlist, interval, ylim);
else
    s1 ='Invalid flag. \n multi_time_distr(interval, flag) takes';
    s2 = ' an interval argument(integer) (for the histogram) and a';
    s3 = ' flag that is either "indiv": the function prints individual figures \n';
    s4 = ' or "col": the function plots all subplots on the same figure';
    error(sprintf(strcat(s1, s2, s3, s4)));
end
end

%multi_time_distr_indiv(dirlist, interval, sfignum) plots the
%   nosepoke/reward time distribution with bin size specified by interval
%   of each jstruct in dirlist on its own figure, starting at sfignum and 
%   incrementing by 1 each time
function [data, labels] = multi_time_distr_single(dirlist, interval, combineflag, ax, normalize, rewonly)
colors = 'rbkmcgyrbkmcgyrbkmcgy';
if length(ax) <1; figure; ax(1) = gca(); end
data = cell(length(dirlist), 1);
[jslist, dates] = load_jstructs(dirlist, combineflag);
for i = 1:length(jslist);
    jstruct = jslist{i};
    [np_plot, rew_plot,~,times, labelstmp]=generate_time_distr(jstruct, interval, normalize, 1, rewonly, ax, colors(i));
    data{i} = [times', np_plot, rew_plot];
    lines(i) = labelstmp.line;
end
labels = labelstmp;
labels.legend = dates;
legend(lines, dates);
%legend('Location', 'northwest');
legend('boxoff');
end

function multi_time_distr_multi(dirlist, interval, ylim)
figure;
hold on; 
plot_size = length(dirlist);
for i = 1:plot_size
    clear jstruct;
    load(dirlist(i).name);
    ax = subplot(plot_size,1,i); hold on;
    [~, ~, day]=generate_time_distr(jstruct, interval, 1, ax);
    axes(ax);
    axis([0, 24, 0, ylim]);
    %minor formatting
    legend('Nosepoke', 'Reward'); legend('boxoff');
    if i == plot_size
        xlabel('Time (hours)');
    end
    ylabel(datestr(floor(day), 'mm/dd/yy'));
    hold on;
end
end