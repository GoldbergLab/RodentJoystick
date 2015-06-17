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

function leg = multi_time_distr(jslist, varargin)
    %Default argument handling:
default = {30, 'single', 0, Inf};
numvarargs = length(varargin);
if numvarargs > 3
    error('too many arguments (> 5), only one required and four optional.');
end
[default{1:numvarargs}] = varargin{:};
%normal code from here on
[interval, layout, combineflag, ylim] = default{:};
leg = [];
if strcmp(layout,'single')
    leg = multi_time_distr_single(jslist, interval, combineflag);
elseif strcmp(layout,'col')
    multi_time_distr_multi(jslist, interval, ylim);
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
function leg = multi_time_distr_single(jslist, interval, combineflag)
colors = 'rgbkmcyrgbkmcyrgbkmcy';
figure;
ax = gca();
if combineflag==0
    leg = cell(2*length(jslist), 1);
    for i=1:length(jslist)
        clear jstruct;
        load(jslist(i).name);
       [~,~,~,~, labels]=generate_time_distr(jstruct, interval, 1, ax, colors(i));
        leg{2*i}=labels.legend{2};
        leg{2*i-1}=labels.legend{1};
    end
    legend(leg);
    legend('Location', 'northwest');
    legend('boxoff');
else
    clear jstruct; load(jslist(1).name);
    [~,~,day1]=generate_time_distr(jstruct, interval, 0, ax, colors(1));
    clear jstruct; load(jslist(end).name);
    [~,~,day2]=generate_time_distr(jstruct, interval, 0, ax, colors(1));
    leg{1} = strcat(datestr(day1), '-',datestr(day2),': Nosepoke');
    leg{2} = strcat(datestr(day1), '-',datestr(day2),': Reward');

end
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
    subplot(plot_size,1,i); hold on;
    axis([0, 24, 0, ylim]);
    %minor formatting
    legend('Nosepoke', 'Reward'); legend('boxoff');
    if i == plot_size
        xlabel('Time (hours)');
    end
    ylabel(datestr(floor(day)));
    hold on;
end
end