%[targsec, cumulative_distr, angle_distr, labels, line] = 
%   perform_sector_analysis(stats, [reward_rate, thresh, plotflag, ax])
%   computes the required target sector (angles) required for 'reward_rate'
%   a percentage of trials to be rewarded, looking only at portions of
%   trajectories with magnitude greater than the threshold thresh
%   EXAMPLE:  
%       targsec = find_sector(stats,25)
%       targsec = find_sector(stats,25, 95)
%       targsec = find_sector(stats, 25, 95, 'log', [0 99]) 
%   OUTPUTS:
%       targsec :: a sector with targsec(1) defining the start angle, and
%           targsec(2) defining the end angle, moving counterclockwise.
%           I.e., targsec = [350 10] defines a 20 degree arc
%       distr :: 360 entry vector that is cumulative probability distribution
%           of reaching that location (different than angle distribution,
%           which contains the probability of hitting an angle);
%       angle_distr :: 360 entry vector with distribution of angles
%   ARGUMENTS: 
%       stats :: the result from xy_getstats(jstruct) for some jstruct
%       OPTIONAL ARGS:
%       reward_rate :: percentage giving desired reward rate for
%           computation of target sector
%           DEFAULT: 25
%       thresh :: only trajectory points with a magnitude above thresh will
%           be used in computing angle distributions and then target sector
%           DEFAULT: 75
%       plotflag :: 0 results in not plotting, just returning data, 1
%           plots all, 2 plots just distribution with highlight targeted
%           but without reference, 3 plots just distribution
%           DEFAULT: 1
%       ax :: an axes handle for perform_sector_analysis to plot data on.
%           if empty (as by default) and plotflag is on, then generates a
%           new figure automatically
%       

function [targsec, cumulative_distr, angle_distr, labels, line] = perform_sector_analysis(stats, varargin)
%% argument handling
default = {25, 75, 1, [], 'b'};
numvarargs = length(varargin);
if numvarargs > 5
    error('find_sector: too many arguments (> 6), only one required and five optional.');
end
[default{1:numvarargs}] = varargin{:};
[targ_rate, thresh, plotflag, ax, color] = default{:};
if plotflag == 1 && length(ax)<1; figure; ax = gca(); end;

% basic structure initialization
tstruct = stats.traj_struct;
%360th slot corresponds to 0
%trajectory_indices:
trajindices(1) = struct('traj_ind', []);
for i= 2:360; trajindices(i) = struct('traj_ind', []); end;
angle_distr = zeros(360,1); sample_size = 0;
% loop over all trajectories, assigning sectors to each one, then adding 
for i = 1:length(tstruct)
    [first, second] = get_sector(tstruct(i).traj_x,tstruct(i).traj_y,thresh);
    if first ~= -1 && second ~= -1
        if (first == 0); first = 360; end; if (second == 0); second = 360; end
        if (first>second)
            indices = [first:360, 1:second];
            %add information to struct containing trajectory into struct
            for j = first:360; trajindices(j).traj_ind = [trajindices(j).traj_ind; i]; end
            for j = 1:second; trajindices(j).traj_ind = [trajindices(j).traj_ind; i]; end 
        else
            indices = first:second;
            for j = indices; trajindices(j).traj_ind = [trajindices(j).traj_ind; i]; end
        end
        %add information about sector covered by trajectory to 
        %angle_distribution 
        angle_distr(indices)=1+angle_distr(indices);
        %note that not all trajectories are actually used, in computing a
        %quarter, we only end up taking the subset of the total
        %trajectories in tstruct
        sample_size = sample_size + 1;
    end
end
%now use processed data from tstruct to (1) draw plots and (2) find target
for i = 1:360; trajindices(i).traj_ind = sort(trajindices(i).traj_ind); end
if sample_size < 10
    vec = 'Threshhold is too large, or not enough data. Not enough samples.';
    error(vec);
end
[~, max_index] = max(angle_distr);
pos_starts = find(angle_distr == min(angle_distr));
angle_dists = pos_starts - max_index;
angle_dists(angle_dists < 1) = angle_dists(angle_dists < 1)+360;
angle_dists(angle_dists > 180)= 360 - angle_dists(angle_dists>180);
[~, max_dist] = max(angle_dists);
start_angle = pos_starts(max_dist);
[targsec, cumulative_distr] = calc_target_sector(start_angle, trajindices, sample_size, targ_rate/100);

if plotflag > 0 && length(ax)<1; 
    figure; 
    ax = subplot(1, 1, 1); 
end;
[labels, line] = draw_plots(stats, ax, angle_distr, sample_size, targsec, thresh, plotflag, color);
end

%calc_target_sector computes the target sector with the following arguments
%ARGUMENTS: 
%   start_angle: initial angle for target sector computation
%   traj_indices: struct with field trajindices, satisfying the property
%       that traj_indices(i).trajindices is a vector of indices
%       corresponding to the trajectories that have a point at angle i
%   sample_size: number of trajectories in the struct traj_indices
%   target_rate: the desired reward rate (i.e. 25%) as a number less than
%       1. i.e. 0.25
%OUTPUT:
%   sector: a two entry vector [a1 a2] where a1 defines the start angle, and
%           a2 definies the end angle, moving counterclockwise.
%           I.e., sector = [350 10] defines a 20 degree arc (not 340)
function [sector, dist] = calc_target_sector(start_angle, traj_indices, sample_size, target_rate)
second = -1;
first = start_angle; union_indices = traj_indices(start_angle).traj_ind;
distribution = zeros(360, 1);
% loop until 360': accumulate probability distribution
for i = start_angle:360;
    union_indices = union(union_indices, traj_indices(i).traj_ind);
    distribution(i) = length(union_indices)/sample_size;
    if distribution(i)>target_rate && second == -1
        second = i;
    end
end
%% continue all the way around to obtain entire probability distribution
for i = 1:start_angle
    union_indices = union(union_indices, traj_indices(i).traj_ind);
    distribution(i) = length(union_indices)/sample_size;
    if distribution(i)>target_rate && second == -1
        second = i;
    end
end
if distribution(start_angle) == target_rate; second = start_angle; end
if second == -1; error('Unable to compute target sector'); end
sector = [first second]; dist = distribution;
end

function [labels, line] = draw_plots(stats, ax, angle_distr, ss, target, thresh, plotflag, color)
%grey color values for linear angle distribution
colorv = [0.8 0.6 0.4 0.2];
%% get normalized angle distribution information
%target range

tstr=['Angle Distribution @ ', num2str(thresh), '%: ',num2str(ss),' trajectories'];
labels.title = tstr;
labels.xlabel = 'Angle (Degrees)';
labels.ylabel = 'Probability';

if plotflag > 0
    axes(ax); %plot onto axes
    hold on;
    if plotflag == 1
        for i = 1:4
            t = i*25; if i == 4; t = 95; end
            [angle_dist, ssize] = get_angle_distr_for_thresh(stats, t); c = colorv(i);
            x = 1:1:360; y = angle_dist./ssize; col = [c c c];
            plot(x, y, 'Color', col); hold on;
        end
    end
    hold on;
    title(labels.title); xlabel(labels.xlabel); ylabel(labels.ylabel);
    axis([1 359 0 inf]);
    angles = 1:1:360;
    distribution = angle_distr./ss;
    line= plot(angles, distribution, color);
    if plotflag < 3
        target1 = []; target2 = [];
        t1 = target(1); t2 = target(2);
        if t1<t2
            target1=t1:1:t2;
            target2=t1:1:t2;
        else
            target1=t1:1:360;
            target2=1:1:t2;
        end
        plot(target1, distribution(target1), 'g');
        plot(target2, distribution(target2), 'g');
    end
    hold off;
end
end

function [angle_distr, samplesize] = get_angle_distr_for_thresh(stats, thresh)
tstruct = stats.traj_struct;
%360th slot corresponds to 0
angle_distr = zeros(360,1); samplesize = 0;
for i = 1:length(tstruct)
    [first, second] = get_sector(tstruct(i).traj_x,tstruct(i).traj_y,thresh);
    if first ~= -1 && second ~= -1
        if (first == 0); first = 360; end
        if (second == 0); second = 360; end
        indices = first:second;
        if (first>second); indices = [first:360, 1:second]; end
        angle_distr(indices)=1+angle_distr(indices);
        samplesize = samplesize + 1;
    end
end
end


%get_sector(x,y, thresh) obtains the sector found by looking at all x,y
%values of the trajectory with magnitude above the threshold.
%The sector is given as two positive angles in [0, 359] with first = the
%start of the sector, and second the end, always moving counterclockwise
function [first, second] = get_sector(x, y, thresh)
    [angles, rad] = cart2pol(x, y);
    angles=angles(rad>thresh).*180./pi;
    if length(angles)<2
        first = -1; second = -1;
    else
        minim = floor(min(angles));
        maxim = floor(max(angles));
        %weird trajectory - give error signal
        if (minim == maxim) || (length(angles) == 2) || minim > maxim || length(angles)<2
            first = -1; second = -1;            
        else
            angles = angles(angles~=minim & angles~=maxim);
            test= angles(floor(length(angles)/2)+1);
            if test<minim || test > maxim
                first = maxim; second = minim;
            else
                first = minim; second = maxim;
            end
            if first<0
                first = first+360;
            end
            if second<0
                second = second+360;
            end
        end
    end
end