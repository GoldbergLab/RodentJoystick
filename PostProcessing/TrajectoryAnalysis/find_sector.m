%[sortedtraj, fh] = 
%   find_sector(stats) or find_sector(stats, reward_rate, ... )
%   OPTIONAL ARG ORDER:
%       reward_rate, thresh, pflag, colorperc
%   computes the required target sector (angles) required for 'reward_rate'
%   a percentage of trials to be rewarded.
%   EXAMPLE:  
%       sector = find_sector(stats,25)
%       sector = find_sector(stats,25, 95)
%       sector = find_sector(stats, 25, 95, 'log', [0 99])
%   OUTPUTS:
%       sector :: a sector with sector(1) defining the start angle, and
%           sector(2) defining the end angle, moving counterclockwise.
%           I.e., sector = [350 10] defines a 20 degree arc
%       angle_distr :: 360 entry vector that contains distributions of
%           angles
%       fh :: figure handle to plots generated by calling find_sector
%       trajindices :: struct with index i as the angle and the field
%           traj_ind containing a vector of all the trajectory indices that
%           covered the angle i
%   ARGUMENTS: 
%       stats :: the result from xy_getstats(jstruct) for some jstruct
%       OPTIONAL ARGS:
%       reward_rate :: percentage giving desired reward rate for
%           computation of target sector
%           DEFAULT: 25
%       thresh :: only trajectory points with a magnitude above thresh will
%           be used in computing angle distributions and then target sector
%           DEFAULT: 75
%       pflag :: changes color mapping: 'log' places the color mapping on a
%           logarithmic scale, 'norm' leaves probabilities as is.
%           DEFAULT: 'log'
%       colorperc :: [c1 c2] tells color plotter for trajectory
%           distributions the percentiles caxis should use. This is always
%           automatically set to [0 99] if logarithmic color mapping is
%           used
%           DEFAULT: [20 80]
function [targsec, angle_distr, fh, trajindices] = find_sector(stats, varargin)
% argument handling
default = {25, 75, 'log', [25 75]};
numvarargs = length(varargin);
if numvarargs > 3
    error('trajectory_analysis: too many arguments (> 5), only one required and four optional.');
end
[default{1:numvarargs}] = varargin{:};
[targ_rate, thresh, pflag, colorperc] = default{:};
if strcmp(pflag, 'log'); colorperc = [0 99]; end;

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
    vec = ['Threshhold is too large, or not enough data. Not enough samples.'];
    error(vec);
end
[~, max_index] = max(angle_distr);
start_angle = mod(180+max_index, 360)+1;
[targsec] = calc_target_sector(start_angle, trajindices, sample_size, targ_rate/100);
fh = draw_plots(stats, angle_distr, pflag, colorperc, sample_size, targsec, thresh);
titlestr = strcat('Target Sector: ',num2str(targsec(1)),'->',num2str(targsec(2)));
subplottitle(fh, titlestr,'fontsize', 16, 'yoff', -0.4);
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
function sector = calc_target_sector(start_angle, traj_indices, sample_size, target_rate)
second = -1;
first = start_angle; union_indices = traj_indices(start_angle).traj_ind;
distribution = zeros(360, 1);
% loop until 360': accumulate probability distribution
for i = start_angle:360;
    union_indices = union(union_indices, traj_indices(i).traj_ind);
    distribution(i) = length(union_indices)/sample_size;
    if distribution(i)>=target_rate
        second = i; break;
    end
end
% if we still haven't reached the target, then we continue all the way around
if second == -1
    for i = 1:start_angle
        union_indices = union(union_indices, traj_indices(i).traj_ind);
        distribution(i) = length(union_indices)/sample_size;
        if distribution(i)>= target_rate
            second = i; break;
        end
    end
end
if second == -1
    error('Unable to compute target sector');
end
sector = [first second];
end

function fh = draw_plots(stats, angle_distr, pflag, colorperc, ss, target, thresh)
% just gathering data, with some basic processing;
data = stats.traj_pdf_jstrial;
if strcmp(pflag, 'log')
    data = log(data);
    traj_pdf = reshape(data, 100*100, 1);
    traj_pdf = sort(traj_pdf(traj_pdf ~= -Inf ));
else
    traj_pdf = reshape(data, 100*100, 1);
    traj_pdf = sort(traj_pdf(traj_pdf ~= 0));
end

fh = figure('Position', [100, 100, 1200, 500]);
% Plot results from traj_pdf
subplot(1,3,1); hold on;
title(['Trajectory Distribution: (',pflag,' scale)']); 
xlabel('X Position+50'); ylabel('Y Position + 50');
pcv2_ind = min(floor(colorperc(2)/100*length(traj_pdf)), length(traj_pdf));
pcolorval2 = traj_pdf(pcv2_ind);
pcv1_ind = max(floor(colorperc(1)/100*length(traj_pdf)), 1);
pcolorval1 = traj_pdf(pcv1_ind);
pcolor(data); shading flat; axis square; caxis([pcolorval1 pcolorval2]); hold off;

%grey color values for linear angle distribution
colorv = [0.8 0.6 0.4 0.2];

% plot normalized angle distribution
subplot(1,3,2); 
axis([1 359 0 inf]); hold on;
for i = 25:25:100
    angle_dist = get_angle_distr_for_thresh(stats, i);
    c = colorv(i/25);
    plot(1:1:360, angle_dist./(sum(angle_dist)), 'Color', [c c c]);
end
plot(1:1:360, angle_distr./sum(angle_distr), 'r'); hold on;
    %plot target range in green
t1 = target(1); t2 = target(2);
if t1<t2
plot(t1:1:t2, angle_distr(t1:t2)./sum(angle_distr), 'g');
else
plot(t1:1:360, angle_distr(t1:360)./sum(angle_distr), 'g');
plot(1:1:t2, angle_distr(1:t2)./sum(angle_distr), 'g');
end

title(['Angle Distribution @ ', num2str(thresh), '%: ',num2str(ss),' trajectories']); 
xlabel('Angle (Degrees)'); ylabel('Probability');

% plot polar angle distribution
subplot(1,3,3);
theta = (1:1:360)*pi./180;
axmax = max(angle_distr./sum(angle_distr));
polar(theta', angle_distr./sum(angle_distr), 'b'); hold on;
for i = 25:25:100
    angle_dist = get_angle_distr_for_thresh(stats, i); c = colorv(i/25); hold on;
    l=polar(theta', angle_dist./sum(angle_dist)); hold on;
    axmax = max([axmax, max(angle_dist./sum(angle_dist))]);
    set(l,'Color', [c c c]);
end
title(['Angle Distribution: (',num2str(ss),' trajectories)']);
hold off;
end

% 
function [angle_distr] = get_angle_distr_for_thresh(stats, thresh)
tstruct = stats.traj_struct;
%360th slot corresponds to 0
angle_distr = zeros(360,1);
for i = 1:length(tstruct)
    [first, second] = get_sector(tstruct(i).traj_x,tstruct(i).traj_y,thresh);
    if first ~= -1 && second ~= -1
        if (first == 0); first = 360; end
        if (second == 0); second = 360; end
        indices = first:second;
        if (first>second); indices = [first:360, 1:second]; end
        angle_distr(indices)=1+angle_distr(indices);
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