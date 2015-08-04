function start_to_target_distr(traj_struct, varargin)
% start_to_target_distr(traj_struct, [hist_bin, smoothparam, numplots, ht_range, rw_filter, axlst, color])
%
%   generates plots of the distribution of distances from a trajectory's
%   start to its end point. start_to_target_distribution takes a stats 
%   structure (typically representing an entire contingency's data) and 
%   bins by hold time.
%
% OUTPUTS
%
%   None
%
% ARGUMENTS
%
%   traj_struct :: a standard trajectory structure (from xy_getstats),
%       obtain from the field stats.traj_struct
%
% OPTIONAL ARGS
%
%   hist_bin :: bin size for generating individual start-target 
%       distribution
%       DEFAULT - 10
%
%   numplots :: how many plots (how many bins to generate from ht_range)
%       DEFAULT - 3
%
%   ht_range :: the hold time range of trajectories to bin and examine
%       DEFAULT - [200 600]
%
%   rw_filter :: a 1/0 flag indicating whether to only look at rewarded
%       trajectories (1) or whether to not filter and look at all
%       trajectories (0)
%       DEFAULT - 0
%
%   axlst :: a list of axes handles. If empty, start_to_target_distribution
%       will generate its own figure with the `numplots` number of subplots
%       If provided, must have at least as many valid figure handles as
%       numplots or an error is thrown
%       DEFAULT - []
%

%% Arg manipulation/extraction
default = {5, 3, 3, [200 600], 0, [], 'r'};
numvarargs = length(varargin);
if numvarargs > 7
    error('too many arguments (> 8), only 1 required and 7 optional.');
end
[default{1:numvarargs}] = varargin{:};
[hist_bin, smoothparam, numplots, ht_range, rw_filter, axlst, color] = default{:};


%% Create axlst and make bins based on args
if length(axlst) < 1
    figure('Position', [300 300 1000 400]); 
    for i = 1:numplots;
        axlst(i) = subplot(1, numplots, i);
    end
end
interv = (ht_range(2) - ht_range(1))/numplots;
bins = ht_range(1):interv:ht_range(2);

tstruct = traj_struct;
binnedtstruct = sort_traj_into_bins(tstruct, bins, rw_filter, 0);

for i = 1:numplots
    [histbins, distr] = generate_start_target_distr(binnedtstruct(i).traj_struct, hist_bin);
    %data{1} = [histbins, distr];
    axes(axlst(i));
    hold on;
    stairs(axlst(i), histbins, smooth(distr, smoothparam), color);
    xlabel(axlst(i), 'Start to Target Distance');
    ylabel(axlst(i), 'Probability');
    title(axlst(i), 'Start to Target Trajectory Distance');
    hold off;
    axes(axlst(i));
end

end

function [histbins, distr] = generate_start_target_distr(tstruct, interv)
    data = zeros(length(tstruct), 1);
    for i = 1:length(tstruct)
        tx = tstruct(i).traj_x;
        ty = tstruct(i).traj_y;
        data(i) = sqrt((tx(end)-tx(1)).^2 + (ty(end)-ty(1)).^2);
    end
    histbins = (0:interv:150)';
    distr = histc(data, histbins);
    distr = distr./sum(distr);
end

