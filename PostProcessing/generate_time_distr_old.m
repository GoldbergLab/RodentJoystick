
%%% function takes in the jstruct as an argument, and 'int', the size of
%%% the bins on the histogram
%%% plots the nose poke distribution vs time on Figure 1, Figure 2 is
%%% reward distribution
function generate_time_distr(jstruct, int)
    dtime = gen_dtime(jstruct);
    nptime = gen_nptime(jstruct);
    rewtime = gen_rewtime(jstruct);
    [nptimes, np_on] = gen_hist_data(dtime, nptime, int);
    plot_sensor_on(nptimes, np_on, 'Nosepoke', 1);
    [rewtimes, rew_on] = gen_hist_data(dtime, rewtime, int);
    plot_sensor_on(rewtimes, rew_on, 'Reward', 2);
end

function [dtime] = gen_dtime(jstruct)
    dtime = [];
    for i = 1:length(jstruct)
        dtime= [dtime; jstruct(i).date_time];
    end
end

function [nptime] = gen_nptime(jstruct)
    nptime = [];
    for i = 1:length(jstruct)
        temp = jstruct(i).np_pairs;
        if length(temp) >= 1
            temp = temp(:, 1);
            temp = temp+jstruct(i).date_time;
            nptime = [nptime; temp];
        end
    end
end


function [rewtime] = gen_rewtime(jstruct)
    rewtime = [];
    for i = 1:length(jstruct)
       rewt = jstruct(i).reward_onset;
       rewt = rewt';
       if length(rewt) >= 1
           rewtime = [rewtime; (rewt + jstruct(i).date_time)];
       end
    end
end

%%%this function gives a vector of times (from start to end) and 
%%% additionally a vector 'on' marking when the sensor denoted by 'ontimes'
%%% came on. datetime corresponds to the frame. ontime is relative to the
%%% start of 'datetime'
function [times, on] = gen_hist_data(date_time, senson, histint)
    stime = date_time(1);
    interval = date_time(end) - stime;
    %normalize times to a 0->length of interval scale
    times = (0:histint:interval);
    on = senson - stime;
    
    
end

%%% this function just handles the plotting, taking in the bin sizes (times)
%%% and ontimes, the time when the sensor comes on
function plot_sensor_on(times, ontimes, label, fig)
    toplot = histc(ontimes, times);
    figure(fig)
    xlabel('Time');
    ylabel(label);
    stairs(times, toplot);
    hold on;
    
end

