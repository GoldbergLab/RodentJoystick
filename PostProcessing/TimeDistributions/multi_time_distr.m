% multi_time_distr(jslist[, interval, layout, combineflag, lim]) generates 
% histogram time distributions of nosepokes and rewards for all jstructs 
% in the list jslist - only jslist & interval are required arguments, rest
% are optional
% ARGUMENTS:
%   jslist :: a list of files referring to saved jstructs:
%       Ex: jslist(1).name = 'K:\expt4\expt_4_0004_16\Box_2\2_18_2015\jstruct.mat'
%   OPTIONAL:
%   interval :: interval of time in minutes for histogram bin size 
%       positive nonzero integer
%   layout :: flag tells multi_time_distr whether to put all plots on a
%       single figure or on its own subplot
%       'single' :: put each plot on the same figure
%       'col' :: put each plot on a single figure in a column
%   combineflag :: 
%       if 'single' is selected, combines data when 1, and plots individually if 1.
%       otherwise does nothing
%   ylim :: changes the y-axis limit for all plots if 'col' is selected.
%       otherwise does nothing
% OUTPUTS: None

function [data, labels] = multi_time_distr(jslist, varargin)
    %Default argument handling:
default = {30, 'single', 0, Inf, []};
numvarargs = length(varargin);
if numvarargs > 5
    error('too many arguments (> 6), only one required and five optional.');
end
[default{1:numvarargs}] = varargin{:};
%normal code from here on
[interval, layout, combineflag, ylim, ax] = default{:};
if strcmp(layout,'single')
    [data, labels] = multi_time_distr_single(jslist, interval, combineflag, ax);
elseif strcmp(layout,'col')
    [data, labels] = multi_time_distr_multi(jslist, interval, ylim);
else
    s1 ='Invalid flag. \n multi_time_distr(interval, flag) takes';
    s2 = ' an interval argument(integer) (for the histogram) and a';
    s3 = ' flag that is either "indiv": the function prints individual figures \n';
    s4 = ' or "col": the function plots all subplots on the same figure';
    error(sprintf(strcat(s1, s2, s3, s4)));
end
end

%multi_time_distr_indiv(jslist, interval, sfignum) plots the
%   nosepoke/reward time distribution with bin size specified by interval
%   of each jstruct in jslist on its own figure, starting at sfignum and 
%   incrementing by 1 each time
function [data, labels] = multi_time_distr_single(jslist, interval, combineflag, ax)
colors = 'rgbkmcyrgbkmcyrgbkmcy';
if length(ax) <1
        figure;
        ax(1) = gca();
end
data = cell(length(jslist), 1);
leg = []; labelstmp = [];
if combineflag==0
    leg = cell(2*length(jslist), 1);
    for i=1:length(jslist)
        clear jstruct;
        load(jslist(i).name);
        [np_plot, rew_plot,~,times, labelstmp]=generate_time_distr(jstruct, interval, 1, ax, colors(i));
        data{i} = [times', np_plot, rew_plot];
        leg{2*i}=labelstmp.legend{2};
        leg{2*i-1}=labelstmp.legend{1};
    end
    legend('Location', 'northwest');
    legend('boxoff');
else
    clear jstruct; load(jslist(1).name);
    [~,~,day1, labelstmp]=generate_time_distr(jstruct, interval, 0, ax, colors(1));
    clear jstruct; load(jslist(end).name);
    [~,~,day2]=generate_time_distr(jstruct, interval, 0, ax, colors(1));
    leg{1} = strcat(datestr(day1, 'mm/dd'), '-',datestr(day2, 'mm/dd/yy'),': Nosepoke');
    leg{2} = strcat(datestr(day1, 'mm/dd'), '-',datestr(day2, 'mm/dd/yy'),': Reward');
    combined = [];
    for i=1:length(jslist)
        clear jstruct;
        load(jslist(i).name);
        combined = [combined, jstruct];
    end
    generate_time_distr(combined, interval, 1, ax, colors(1));
end
labels = labelstmp;
labels.legend = leg;
legend(leg);
legend('Location', 'northwest');
legend('boxoff');
end

function multi_time_distr_multi(jslist, interval, ylim)
figure;
hold on; 
plot_size = length(jslist);
for i = 1:plot_size
    clear jstruct;
    load(jslist(i).name);
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