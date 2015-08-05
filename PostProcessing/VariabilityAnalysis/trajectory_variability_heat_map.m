function [ output_args ] = trajectory_variability_heat_map(stats, varargin)
%[ output_args ] = trajectory_variability_heat_map(stats, [numgroups, min_ht, axlst])
%
%   trajectory_variability_heat_map analyzes the inherent variability in
%   various trajectories by aligning each trajectory by its end point, and
%   then generating a heat map with all these trajectories aligned. It 
%   filters trajectories, looking only at trajectories above a certain hold
%   time, and groups these trajectories into time blocks from stats 
%   (traj_struct is in chronological order)
%
% ARGUMENTS:
%
%   stats :: standard stats structure (typically across an entire
%       contingency to evaluate variability and learning
%
% OPTIONAL ARGS:
%
%   numgroups :: number of chronological blocks that are created for
%       analysis
%       DEFAULT - 3
%
%   comparediff :: plot differences in the distribution (1), rather than 
%       the distributions themselves (0)
%       
%   ht_range :: only trajectories in the range ht_range will be considered
%       in analysis 
%       DEFAULT - [300 800]
%   
%   threshold :: only looks at the portion of each trajectory with
%       magnitude greater than threshold 
%       DEFAULT - 20
%
%   bin_size :: 
%
%   rew_filter :: only rewarded trajectories will be analyzed
%       DEFAULT - 1
%
%   axlst :: list of axes handles for trajectory_variability_heat_map to
%       plot onto. If provided, must have as many valid axes handles as
%       numgroups. If empty, a new figure with subplots is generated
%       DEFAULT - []
%   
default = {2, 0, [200 Inf], 20, 2, 1, []};
numvarargs = length(varargin);
if numvarargs > 7
    error('too many arguments (> 8), only 1 required and 7 optional.');
end
[default{1:numvarargs}] = varargin{:};
[numgroups, comparediff, ht_range, threshold, bin_size, rew_filter, axlst] = default{:};
comparediff = ~~comparediff; %make sure 1/0;
if length(axlst)<(numgroups-comparediff)
    figure('Position', [200 200 400 800]);
    for i = 1:(numgroups-comparediff);
        axlst(i) = subplot(numgroups, 1, i);
    end
end

tstruct = stats.traj_struct;
bin = sort_traj_into_bins(tstruct, ht_range, rew_filter, 1); 
tstruct = bin.traj_struct;

indices = floor(linspace(1, numgroups+1-2*eps(numgroups), length(tstruct)));
endpoints = [1, find(diff(indices)), length(tstruct)];
for i = 1:(length(endpoints)-1)
    data = generate_heat_map_data(tstruct(endpoints(i):endpoints(i+1)), ...
        threshold, bin_size);
    
    angle_bins = -180:bin_size:180;
    rad_bins = threshold:bin_size:100;
    
    if ~comparediff
        draw_heat_map(data, axlst(i), 'Trajectory Variability', 1, [5 95], ...
            angle_bins(1:end-1), rad_bins(1:end-1));
    else
        try
            distrdiff = olddata - data;
            draw_heat_map(distrdiff, axlst(i-1), 'Trajectory Variability Difference', ...
                0, [1 99], angle_bins(1:end-1), rad_bins(1:end-1));
        catch e
            disp(getReport(e));
        end
    end
    olddata = data;
end

end

%only adds points above a certain range to the heat map
function data = generate_heat_map_data(tstruct, threshold, interv)
    angle_bins = -180:interv:180;
    rad_bins = threshold:interv:100;
    accumulator = zeros(length(rad_bins)-1, length(angle_bins)-1);
    for i = 1:length(tstruct)
        tx = tstruct(i).traj_x;
        ty = tstruct(i).traj_y;
        [rad, theta] = align_target(tx, ty, 1);
        theta = theta(rad>threshold);
        rad = rad(rad>threshold);
        accumulator = accumulator + hist2d([rad' theta'], rad_bins, angle_bins);
    end
    data = accumulator/length(tstruct);
end

function [rad, theta] = align_target(traj_x, traj_y, target_select)
% performs coordinate transformation  of traj_x and traj_y to polar
% coordinate system and then aligns by polar angle of end point.

[theta, rad] = cart2pol(traj_x, traj_y);
theta = theta*180/pi;

%align by angle to radial line of end point.
if target_select
    [~, maxind] = max(rad);
    theta = theta - theta(maxind);
else
    theta = theta - theta(end);
end

%now make sure we put everything in the range -180 to 180
theta = theta-360*(theta>180)+360*(theta<-180);


end