function [stats, data, labels] = joystick_to_reward_distr(jslist, varargin )
%js_to_reward plots the distribution of joystick to reward onset times with
%a histogram interval specified by hist_int on a time range of 0 to
%time_range milliseconds
%OUTPUTS:
%   holdtimes :: list of hold times, in order of trajectories in
%       corresponding tstruct
%   rewtimes :: list of hold times for which mouse was rewarded
%   js2rew :: list of times between joystick onset and reward (for rewarded
%       trajectories only)
%ARGUMENTS:
%   tstruct :: structure containing all the information about each
%       trajectory. NOT the same as jstruct - after running
%       stats = xy_getstats, tstruct = stats.traj_struct
%   OPTIONAL
%   hist_int :: size of the bins for data generation and histogram plotting
%   plotflag :: flag that tells hold_time_distr whether to generate data or
%       plot - 'plot' - plots the figure, 'data' - just returns data
%       without plotting
%       DEFAULT : 'plot' 
%   statflag :: flag that tells hold_time_distr whether to display
%       statistics. 'stats' displays stats, 'none' doesn't display
%       DEFAULT : 'none'
%   TIME_RANGE :: number that tells end time range
%       DEFAULT : 2000

%% ARGUMENT MANIPULATION AND PRELIMINARY MANIPULATION
default = {20, 2000, 0, 1, []};
numvarargs = length(varargin);
if numvarargs > 4
    error('hold_time_distr: too many arguments (> 5), only two required and four optional.');
end
[default{1:numvarargs}] = varargin{:};
[hist_int, TIME_RANGE, combineflag, plotflag, ax] = default{:};
if (plotflag== 1 && length(ax)<1); figure; ax = gca(); end
colors = 'rgbkmcyrgbkmcyrgbkmcy';
labels.xlabel = 'Time (ms)';
labels.ylabel = 'Probability';
labels.title = 'Joystick Onset to Reward Time Distribution';

%% Actually get data now
if combineflag==0
%% GET LIST of individual data
    for i= 1:length(jslist)
        load(jslist(i).name);
        labels.legend{i} = datestr(jstruct(2).real_time, 'mm/dd/yyyy');
        %processing
        stats = xy_getstats(jstruct);
        js2rew = []; j=1;
        tstruct = stats.traj_struct;
        for k = 1:length(tstruct)
            if tstruct(k).rw == 1
                js2rew(j) = tstruct(k).rw_onset;
                j = j+1;
            end
        end
        data{i} = js2rew;
    end
else
%% FIND COMBINED DATA    

    combined = [];
    for i= 1:length(jslist)
        load(jslist(i).name);
        combined = [combined, jstruct];
        labels.legend{i} = datestr(jstruct(2).real_time, 'mm/dd/yyyy');
    end
    stats = xy_getstats(combined);
    js2rew = [];
    tstruct = stats.traj_struct;
    for k = 1:length(tstruct)
        if tstruct(k).rw == 1
            js2rew(j) = tstruct(k).rw_onset;
            j = j+1;
        end
    end
    data{1} = js2rew;

end
%% PLOT ALL DATA
time_range = 0:hist_int:TIME_RANGE;
if plotflag == 1
    axes(ax(1));
    for i = 1:length(data)
        js2rew_distr = histc(time_range, data{i});
        js2rew_distr = js2rew_distr./sum(js2rew_distr);
        stairs(time_range, js2rew_distr, colors(i), 'LineWidth', 1);
    end
    xlabel(labels.xlabel); ylabel(labels.ylabel); 
    title(labels.title);
    if combineflag==1
        legend([labels.legend{1}, '-', labels.legend{end}])
    else
        legend(labels.legend);
    end
end

end

