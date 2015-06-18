function [median, variation, accel, accelv] = get_vel_accel_distr(stats,varargin)
%[median, variation, accel, accelv] =
% get_vel_accel_distr(stats) returns the 201x201 arrays corresponding to
%relative velocity and acceleration distributions (looking at trajectories)
% ARGUMENTS:
%   stats :: single stats structure
% OUTPUTS:
%   median :: 201x201 double array (-100:1:100 x -100:1:100) containing
%       median velocity
%   variation :: 201x201 double array containing difference between 75th
%       and 25th percentile of velocity profile for each cell
%   accel :: 201x201 double array containing
%       median acceleration at each cell
%   accelv :: 201x201 double array containing difference between 75th and
%       25th percentiles for acceleration profile for each cell


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
    indy= x + 101;
    indx = y + 101;
end