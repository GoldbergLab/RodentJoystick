function [median, variation, accel, accelv] = get_vel_accel_distr(stats,varargin)
%activity_color_map(stats [plotflag, ax, logmapping, colorperc ]) plots a velocity heat map given
%by the valid trajectories
% ARGUMENTS:
%   stats :: single stats structure
%   plotflag :: instructs velocity_heat_map which plots to generate
%       0 :: plots nothing, just gives data;
%       1 :: plots just velocity heat map
%       2 :: plots just velocity variation
%       3 :: plots both
%   logmappping :: a flag indicating whether the function should plot using
%       a logarithmic scale, or standard scale (1 or 0)
%   colorperc :: [lower upper] - colorperc defines the color percentiles
%       for the color mapping when logarithmic mapping is turned off
%   ax :: an axes handle (can be empty) for where activity_color_map should
%       plot 

default = {};
numvarargs = length(varargin);
if numvarargs > 1
    error('too many arguments (> 4), only one required and three optional.');
end
[default{1:numvarargs}] = varargin{:};
[tmp] = default{:};

velocities = cell(201, 201);
median = zeros(201, 201);
variation = zeros(201, 201);
accelerations = cell(201, 201);
accel = zeros(201, 201);
accelv = zeros(201, 201);
tstruct = stats.traj_struct;
for i = 1:length(tstruct);
    x = tstruct(i).traj_x;
    y = tstruct(i).traj_y;
    v_x = diff(x);
    v_y = diff(y);
    a_x = diff(v_x);
    a_y = diff(v_y);
    v = sqrt(v_x.^2 + v_y.^2);
    a = sqrt(a_x.^2 + a_y.^2);
    [ind_x, ind_y] = trajectorypos_to_index(x, y);
    ind_x = ind_x(1:end-1); ind_y = ind_y(1:end-1);
    for j = 1:length(ind_x)
        if j>2
            accelerations{ind_x(j), ind_y(j)} = [accelerations{ind_x(j), ind_y(j)}, a(j-1)];
        end
        old = velocities{ind_x(j), ind_y(j)};
        newv = [old; v(j)];
        velocities{ind_x(j), ind_y(j)} = newv;
    end
end

for indx = 1:201
    for indy = 1:201
        v = velocities{indx, indy};
        quartiles = [0, 0, 0];
        if ~isempty(v)
            quartiles = prctile(v,[25 50 75]);
        end
        median(indx, indy) = quartiles(2);
        variation(indx, indy) = quartiles(3) - quartiles(1);
        
        a = accelerations{indx, indy};
        quartilesa = [0, 0, 0];
        if ~isempty(a)
            quartilesa = prctile(a,[25 50 75]);
        end
        accel(indx, indy) = quartilesa(2);
        accelv(indx, indy) = quartilesa(3) - quartilesa(1);
    end
end
end

%necessary transposition occurs here too - but it doesn't eliminate
function [indx, indy] = trajectorypos_to_index(x, y)
    x = round(x); y = round(y);
    x = max(x, -100); x = min(x, 100);
    y = max(y, -100); y = min(y, 100);
    %transposition in step below
    indy= x + 101;
    indx = y + 101;
end