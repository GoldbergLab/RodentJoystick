function [data] = get_vel_accel_distr(dirlist,varargin)
%[median, variation, accel, accelv] = get_vel_accel_distr(stats) returns
%the relative velocity and acceleration distributions (their medians, and
%the differences between their 75th and 25th percentiles
% ARGUMENTS:
%   stats :: single stats structure
% OUTPUTS: all structures are 201x201 doubles corresponding to cells
% representing blocks in the x-y coordinate space -100:1:100 x -100:1:100
%   median :: median of the velocity profiles for each cell
%   variation :: difference between the 75th and 25th percentiles of the
%       velocity profile for each cell
%   accel :: median of the acceleration profiles for each cell
%   accelv :: difference between the 75th and 25th percentiles of the
%       acceleration profile for each cell
%   TODO :: decompose acceleration into tangential and normal components at
%       each point in trajectory


default = {1};
numvarargs = length(varargin);
if numvarargs > 1
    error('too many arguments (> 1), only one required and 1 optional.');
end
[default{1:numvarargs}] = varargin{:};
[tmp] = default{:};

SIZE = 101;
velocities = cell(SIZE, SIZE);
accelerations = cell(SIZE, SIZE);
accelerations_norm = cell(SIZE, SIZE);
accelerations_ang = cell(SIZE, SIZE);


if length(dirlist) == 1
    load([dirlist(1).name, '\velaccel.mat']);
    data.vel = velaccel.vel;
    data.velv = velaccel.velv;
    data.accel = velaccel.accel;
    data.accelv = velaccel.accelv;
    data.accel_norm = velaccel.accel_norm;
    data.accelv_norm = velaccel.accelv_norm;
    data.accelv_ang = velaccel.accel_ang;
    data.accelv_ang = velaccel.accelv_ang;

else
%% Entire section below combines data and reprocesses    
for i = 1:length(dirlist);
    load([dirlist(i).name, '\velaccelraw.mat']);
    for ind_x = 1:SIZE;
        for ind_y = 1:SIZE;
            velocities{ind_x, ind_y} = [velocities{ind_x, ind_y}, velaccelraw.vel{ind_x, ind_y}];
            accelerations{ind_x, ind_y} = [accelerations{ind_x, ind_y}, velaccelraw.accel{ind_x, ind_y}];
            accelerations_norm{ind_x, ind_y} = [accelerations_norm{ind_x, ind_y}, velaccelraw.accel_norm{ind_x, ind_y}];
            accelerations_ang{ind_x, ind_y} = [accelerations_ang{ind_x, ind_y}, velaccelraw.accel_ang{ind_x, ind_y}];
        end
    end
end


median = zeros(SIZE, SIZE);
variation = zeros(SIZE, SIZE);
accel = zeros(SIZE, SIZE);
accelv = zeros(SIZE, SIZE);
accel_norm = zeros(SIZE, SIZE);
accelv_norm = zeros(SIZE, SIZE);
accel_ang = zeros(SIZE, SIZE);
accelv_ang = zeros(SIZE, SIZE);

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
data.vel = median;
data.velv = variation;
data.accel = accel;
data.accelv = accelv;
data.accel_norm = accel_norm;
data.accelv_norm = accelv_norm;
data.accelv_ang = accel_ang;
data.accelv_ang = accelv_ang;
end

end
