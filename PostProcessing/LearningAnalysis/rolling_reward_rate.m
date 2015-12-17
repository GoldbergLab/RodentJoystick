function rolling_reward_rate(dirlist, window, varargin)
% rolling_reward_rate(dirlist, window, [filter_ht, ax])
%
%   rolling_reward_rate combines all data from dirlist, and then generates a
%   rolling reward rate using <window> trajectories. seemed to have
%   mediocre results - not sure if significant
%
% ARGUMENTS 
%
%   dirlist :: multiple directories, (typically from one contingency to
%       evaulate learning)
%
%   window :: number of trajectories included in the window
%
% OPTIONAL ARGS
%
%   rw_coding :: 0/1/2 flag indicating whether to use the trial to compute 
%       reward time histogram (0), rolling reward 
%       rate (1), or use trajectories to generate a rolling average (0)
%   
%   filter_ht :: a minimum hold time for all included trajectories - this
%       is to avoid incorporating swats in the calculation
%
%   ax :: axes handle for plotting - otherwise generates a new figure

default = {0, 100, []};
numvarargs = length(varargin);
if numvarargs > 2
    error('too many arguments (> 4), only 2 required and 1 optional.');
end
[default{1:numvarargs}] = varargin{:};
[rw_coding, filter_ht, ax] = default{:};
if length(ax)<1;
    figure;
    ax = gca();
end

stats = load_stats(dirlist, 1, 'traj_struct', 'trialnum');
tstruct = stats.traj_struct;

rwfilter = 0; %include all
ht_def = 0; %rw_or_stop
tstructbin = sort_traj_into_bins(tstruct, [filter_ht Inf], rwfilter, ht_def);
tstruct = tstructbin(1).traj_struct;

if rw_coding == 0
    rew = extractfield(tstruct, 'rw');
    rewtraj = find(rew);
    trajnumbers = 1:window:length(tstruct);
    rewtrajs = histc(rewtraj, trajnumbers);
    rewtrajs = rewtrajs./window;
    endrn = length(tstruct);
    len = length(trajnumbers);
elseif rw_coding == 1
    trialrewards = count_rewards_trials(tstruct);
    len = length(trialrewards);
    endrn = len-window+1;
    rewardrates = zeros(endrn, 1);
    for i = 1:endrn
        rewardrates(i) = sum(trialrewards(i:i+window-1))/window;
    end
    trajnumbers = 1:endrn;
else
    len = length(tstruct);
    endrn = len-window+1;
    rewardrates = zeros(endrn, 1);
    holdtimes = zeros(endrn, 1);
    for i = 1:endrn
        tstructmp = tstruct(i:i+window-1);
        rewardrates(i) = sum(extractfield(tstructmp, 'rw'))/window;
        holdtimes(i) = median(extractfield(tstructmp, 'rw_or_stop'));
    end
    trajnumbers = 1:endrn;
end

if rw_coding
    plotyy(trajnumbers, rewardrates, trajnumbers, holdtimes);
else
    axes(ax);
    stairs(trajnumbers, rewtrajs);
end
title(ax, ['Rolling Reward Rate (', num2str(len), ')']);
axis([1 endrn 0 Inf]);
if rw_coding == 1
    xlabel('Trial Number');
else
    xlabel('Trajectory Number');
end
ylabel('Reward Rate');

end

function trialrewards = count_rewards_trials(tstruct)
np_start = tstruct(1).start_p; trialrewards = [];
rew = tstruct(1).rw;
for i = 2:length(tstruct)
    if tstruct(i).start_p == np_start
        rew = rew + ~~(tstruct(i).rw);
    else
       trialrewards = [trialrewards; rew];
       np_start = tstruct(i).start_p;
       rew = ~~(tstruct(i).rw);
    end
end

end



