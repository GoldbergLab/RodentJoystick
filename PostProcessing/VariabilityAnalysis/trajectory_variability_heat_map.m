function [ output_args ] = trajectory_variability_heat_map(statslist, varargin)
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
%   stats :: list of stats structure with field traj_struct
%       (typically across an entire contingency to evaluate 
%           variability and learning)
%
% OPTIONAL ARGS:
%
%   numgroups :: number of chronological blocks that are created for
%       analysis
%       DEFAULT - 3
%
%   normalize :: plot differences in the distribution (1), rather than 
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
[ht_range, threshold, bin_size, rew_filter, axlst] = default{:};
numgroups = length(statslist);
if length(axlst)<numgroups
    figure('Position', [200 200 400 800]);
    axlst(1) = subplot(numgroups, 2, 1); 
    for i = 2:numgroups;
        axlst(2*i-1) = subplot(numgroups, 2, 2*i-1);        
        axlst(2*i) = subplot(numgroups, 2, 2*i);
    end
end

angle_bins = -180:bin_size(1):180;
rad_bins = threshold:bin_size(2):100;

for i = 1:numgroups
    tstruct = statslist(i).traj_struct;
    bin = sort_traj_into_bins(tstruct, ht_range, rew_filter, 1); 
    tstruct = bin.traj_struct;
    
    [mu, sigma, data3d] = ...
        generate_heat_map_data( tstruct, ...
        threshold, angle_bins, rad_bins);
    
    draw_heat_map(mu, axlst(2*i-1), 'Trajectory Variability', 0, [5 95], ...
        angle_bins(1:end-1), rad_bins(1:end-1));
    colorbar;
    
    try
        avg_zscore = get_zscore(oldmu, oldsigma, data3d);
        draw_heat_map(avg_zscore, axlst(2*i), ...
            'Trajectory Variability Difference', ...
            0, [1 99], angle_bins(1:end-1), rad_bins(1:end-1));
        colorbar;
    catch e
        disp(getReport(e));
    end
    oldmu = mu; oldsigma = sigma;
end

end

%only adds points above a certain range to the heat map
function [mu, sigma, data3d] = ...
    generate_heat_map_data(tstruct, threshold, angle_bins, rad_bins)

    data3d = zeros(length(rad_bins)-1, length(angle_bins)-1, ...
        length(tstruct));
    for i = 1:length(tstruct)
        tx = tstruct(i).traj_x;
        ty = tstruct(i).traj_y;
        [rad, theta] = map_trajectory(tx, ty, 0);
        theta = theta(rad>threshold);
        rad = rad(rad>threshold);
        normalize = 0;
        traj_prob = hist2d([rad' theta'], rad_bins, angle_bins);
        traj_prob = ~~traj_prob; %binary histogram - visit or not?
        if normalize && sum(sum(traj_prob))>0
            traj_prob = traj_prob./sum(sum(traj_prob));
        end 
        data3d(:, :, i) = traj_prob;
    end
    mu = sum(data3d, 3)/length(tstruct);
    sigma = std(data3d, 0, 3);
end

function [avg_zscore] = get_zscore(mu_1, sigma_1, data3d_2)
    for i = 1:size(data3d_2)
        traj = data3d_2(:, :, i);
        traj = traj-mu_1;
        
        %avoid NaNs
        traj(sigma_1 == 0) = 0;
        sigma_1(sigma_1 == 0) = 1;
        
        zscore = traj./sigma_1;
        data3d_2(:, :, i) = zscore;
    end
    avg_zscore = sum(data3d_2, 3)./size(data3d_2, 3);

end

function [rad, theta] = map_trajectory(traj_x, traj_y, target_select)
% performs coordinate transformation  of traj_x and traj_y to polar
% coordinate system and then aligns by polar angle of end point.

[theta, rad] = cart2pol(traj_x, traj_y);
theta = theta*180/pi;

%align by angle to radial line of end point.
if target_select==1
    [~, maxind] = max(rad);
    theta = theta - theta(maxind);
elseif target_select == 2
    theta = theta - theta(end);
end

%now make sure we put everything in the range -180 to 180
theta = theta-360*(theta>180)+360*(theta<-180);

end