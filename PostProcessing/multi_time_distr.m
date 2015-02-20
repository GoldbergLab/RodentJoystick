% multi_time_distr(jslist, interval, flag, sfignum) generates histogram time distributions
% of nosepokes and rewards for all jstructs in the list jslist
% ARGUMENTS:
%   jslist :: a list of files referring to saved jstructs:
%       Ex: jslist(1).name = 'K:\expt4\expt_4_0004_16\Box_2\2_18_2015\jstruct.mat'
%   interval :: interval of time in minutes for histogram bin size 
%       positive nonzero integer
%   flag :: flag tells multi_time_distr whether to put all plots on a
%       single figure or on its own separate figure
%       'indiv' :: put each plot on its own separate figure
%       'col' :: put each plot on a single figure in a column
% OUTPUTS: None
function multi_time_distr(jslist, interval, flag, sfignum)

    if strcmp(flag,'indiv')
        multi_time_distr_indiv(jslist, interval, sfignum)
    elseif strcmp(flag,'col')
        multi_time_distr_multi(jslist, interval, sfignum)
    else
        s1 ='Error: Flag not in range. \n multi_time_distr(interval, flag) takes';
        s2 = ' an interval argument(integer) (for the histogram) and a';
        s3 = ' flag that is either "indiv": the function prints individual figures \n';
        s4 = ' or "grid": the function plots all 4 subplots on the same figure';
        error(sprintf(strcat(s1, s2, s3, s4)));
    end
end

%multi_time_distr_indiv(jslist, interval, sfignum) plots the
%   nosepoke/reward time distribution with bin size specified by interval
%   of each jstruct in jslist on its own figure, starting at sfignum and 
%   incrementing by 1 each time
function multi_time_distr_indiv(jslist, interval, sfignum)
    for i=1:length(jslist)
        clear jstruct;
        load(jslist(i).name);
        generate_time_distr(jstruct, interval, sfignum, 'plot')
        sfignum = sfignum + 1;
    end
end

function [plot] = multi_time_distr_multi(jslist, interval, fignum)
    plot = figure(fignum);
    hold on; plot_size = length(jslist);
    for i = 1:plot_size
        clear jstruct;
        load(jslist(i).name);
        %actual calculations, plot data below
        [np_plot, rew_plot, day, times] = generate_time_distr(jstruct, interval, 1, 'data');
        subplot(plot_size,1,i); hold on;
        stairs(times, np_plot, 'b');
        stairs(times, rew_plot, 'r');
        axis([0, 24, 0, inf]);
        
        %minor formatting
        legend('Nosepoke', 'Reward'); legend('boxoff');
        if i == plot_size
            xlabel('Time (hours)');
        end
        ylabel(datestr(floor(day)));
        hold on;
    end
end