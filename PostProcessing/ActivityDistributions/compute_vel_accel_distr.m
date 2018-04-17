function [data, rawdata] = compute_vel_accel_distr(stats,varargin)
%[median, variation, accel, accelv] = get_vel_accel_distr(stats) 
%   returns the relative velocity and acceleration distributions 
%   (their medians, and the differences between their 75th and 25th
%   percentiles)
%
% OUTPUTS: all structures are 201x201 doubles corresponding to cells
% representing blocks in the x-y coordinate space -100:1:100 x -100:1:100
%
%   data :: struct with a 201x201 double array for each field corresponding
%       to cells representing blocks in the x-y coordinate space 
%       -100:1:100 x -100:1:100. has the following fields
%
%       vel :: median of the velocity profiles for each cell
%
%       velv :: difference between the 75th and 25th percentiles of the
%           velocity profile for each cell
%
%       accel :: median of the acceleration profiles for each cell
%
%       accelv :: difference between the 75th and 25th percentiles of the
%           acceleration profile for each cell
%       
%       accel_norm :: median of the normal component of the acceleration
%           profile for each cell
%
%       accelv_norm :: difference in the 75th and 25th percentiles of the
%           acceleration profile for each cell
%
%       accel_ang :: median of the angular acceleration profile for each
%           cell
%
%       accelv_ang :: difference between the 75th and 25th percentiles for
%           the angular acceleration profile for each cell
%       
%   rawdata :: struct with 201x201 cell arrays corresponding to cells
%       representing blocks in the x-y coordinate space -100:1:100 x
%       -100:1:100. Each cell contains a double vector 
%       TODO :: decompose acceleration into tangential and normal components at
%           each point in trajectory
%
% ARGUMENTS:
%
%       stats :: single stats structure

default = {'1'};
numvarargs = length(varargin);
if numvarargs > 1
    error('too many arguments (> 1), only one required and 1 optional.');
end
[default{1:numvarargs}] = varargin{:};
[tmp] = default{:};

SIZE = 201;
velocities = cell(SIZE, SIZE);
median = zeros(SIZE, SIZE);
variation = zeros(SIZE, SIZE);

accelerations = cell(SIZE, SIZE);
accelerations_norm = cell(SIZE, SIZE);
accelerations_ang = cell(SIZE, SIZE);
accel = zeros(SIZE, SIZE);
accelv = zeros(SIZE, SIZE);
accel_norm = zeros(SIZE, SIZE);
accelv_norm = zeros(SIZE, SIZE);
accel_ang = zeros(SIZE, SIZE);
accelv_ang = zeros(SIZE, SIZE);

tstruct = stats.traj_struct;
for i = 1:length(tstruct);
if length(tstruct(i).traj_x) > 5
    i
    x = tstruct(i).traj_x;
    y = tstruct(i).traj_y;
    mag = (x.^2 + y.^2);
    
    v_x = diff(x);
    v_y = diff(y);
    v = sqrt(v_x.^2 + v_y.^2);

    a_x = diff(v_x);
    a_y = diff(v_y);
    a = sqrt(a_x.^2 + a_y.^2);
    %v dot a = 0 -> orthonormal
    %v dot a = a -> tangential
    %tangential component = v/|v| dot a
    x_norm = x ./mag;
    y_norm = y ./mag;
    
    v_x_norm = v_x ./v; 
    v_y_norm = v_y ./v;
    
    a_x_norm = a_x ./a;
    a_y_norm = a_y ./a;
    
    a = sqrt(a_x.^2 + a_y.^2);
    av_x = v_x_norm(1:end-1) .* a_x_norm;
    av_y = v_y_norm(1:end-1) .* a_y_norm;
    a_tan = av_x + av_y;
    a_normal = sqrt(1-a_tan.^2);
    %Temporarily changed a_tan to radial acceleration
    
    a_x_radial = a_x_norm .* x_norm(2:end-1);
    a_y_radial = a_y_norm .* y_norm(2:end-1);
    a_rad = (a_x_radial + a_y_radial);
    a_ang = sqrt(1 - a_rad.^2);
    [ind_x, ind_y] = trajectorypos_to_index(x, y);
    ind_x = ind_x(1:end-1); ind_y = ind_y(1:end-1);
    for j = 1:length(ind_x)
        if j>2
            accelerations{ind_x(j), ind_y(j)} = [accelerations{ind_x(j), ind_y(j)}, a(j-1)];
            accelerations_norm{ind_x(j), ind_y(j)} = [accelerations_norm{ind_x(j), ind_y(j)}, a_normal(j-1)];
            accelerations_ang{ind_x(j), ind_y(j)} = [accelerations_ang{ind_x(j), ind_y(j)}, a_ang(j-1)];
        end
        old = velocities{ind_x(j), ind_y(j)};
        newv = [old, v(j)];
        velocities{ind_x(j), ind_y(j)} = newv;
    end
end
end

for indx = 1:SIZE
    for indy = 1:SIZE
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
        
        a_normal = accelerations_norm{indx, indy};
        quartilesat = [0, 0, 0];
        if ~isempty(a)
            quartilesat = prctile(a_normal,[25 50 75]);
        end
        accel_norm(indx, indy) = quartilesat(2);
        accelv_norm(indx, indy) = quartilesat(3) - quartilesat(1);
        
        a_ang = accelerations_ang{indx, indy};
        quartilesan = [0,0,0];
        if ~isempty(a)
            quartilesan = prctile(a_ang, [25 50 75]);
        end
        accel_ang(indx, indy) = quartilesan(2);
        accelv_ang(indx, indy) = quartilesan(3)-quartilesan(1);
    end
end
rawdata.vel = velocities;
rawdata.accel = accelerations;
rawdata.accel_norm = accelerations_norm;
rawdata.accel_ang = accelerations_ang;

data.vel = median;
data.velv = variation;
data.accel = accel;
data.accelv = accelv;
data.accel_norm = accel_norm;
data.accelv_norm = accelv_norm;
data.accel_ang = accel_ang;
data.accelv_ang = accelv_ang;
end

%necessary transposition occurs here too - but it doesn't eliminate
function [indx, indy] = trajectorypos_to_index(x, y)
    SIZE = 201;
    x = round(x); y = round(y);
    x = max(x, -100); x = min(x, 100);
    y = max(y, -100); y = min(y, 100);
    %transposition in step below
    indy= x + 101;
    indx = y + 101;
    %now bin in 2 so that we have same bin size as activity map
    indx = max(min(round(indx), SIZE), 1);
    indy = max(min(round(indy), SIZE), 1);
end
