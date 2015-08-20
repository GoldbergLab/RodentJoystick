function [ output_args ] = multi_start_to_target_distr(dirlist, varargin)
% multi_start_to_target_distr(dirlist, [hist_bin, smoothparam, chron_group, numplots, ht_range, rw_filter, axlst])
%
%   NOTE: This set of functions was a test to see if this kind of
%   variability analysis would work - but it didn't achieve anything
%   useful.
%   Probably still glitchy , but can edit and figure out if anything will
%   come of this analysis.
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
%   dirlist :: a set of days (most likely from the same contingency)
%
% OPTIONAL ARGS
%
%   hist_bin :: bin size for generating individual start-target 
%       distribution
%       DEFAULT - 5
%
%   smoothparam :: parameter for smoothing histogram plot (moving average)
%       DEFAULT - 1 (no smoothing)
%
%   chron_group :: number of chronological blocks that stats should be
%       grouped into for computation.
%       DEFAULT - 3
%
%   numplots :: how many plots (how many bins to generate from ht_range)
%       DEFAULT - 3
%
%   ht_range :: the hold time range of trajectories to bin and examine
%       DEFAULT - [200 800]
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

default = {5, 3, 3, 3, [200 800], 0, []};
numvarargs = length(varargin);
if numvarargs > 6
    error('too many arguments (> 7), only one required and six optional.');
end
[default{1:numvarargs}] = varargin{:};
[hist_bin, smoothparam, chron_group, numplots, ht_range, rw_filter, axlst] = default{:};

if length(axlst) < 1
    figure('Position', [300 300 1000 400]); 
    for i = 1:numplots;
        axlst(i) = subplot(1, numplots, i);
    end
end
colors = 'rgbkmcyrgbkmcyrgbkmcy';

stats = load_stats(dirlist, 1);
tstruct = stats.traj_struct;
tstructgrouping = cell(chron_group, 1);
tstructinterv = floor(length(tstruct)/chron_group);
bins = 1:tstructinterv:length(tstruct);
for i = 1:chron_group;
    start = bins(i);
    fin = bins(i+1);
    start_to_target_distr(tstruct(start:fin), hist_bin, smoothparam, ...
        numplots, ht_range, rw_filter, axlst, colors(i));
end

end

