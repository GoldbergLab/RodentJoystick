function [x_filt, y_filt] = filter_noise_traj(x, y, hd, range)
% [x_filt, y_filt ] = filter_noise_traj(x, y, hd, range)
%   
%   takes in raw x, raw y data, and generates filtered samples x_filt
%   and y_filt using the time range specified by range
%   current implementation uses filter specified by hd
%
% ARGS:
%   
%   x :: raw x data
%
%   y :: raw y data
%
%   hd :: a filter argument, used for processing - because
%       filter_noise_traj is called inside of a loop, recreating the filter
%       inside this function is too costly.
%
%   range :: 2 element vector with range(1) indicating start time, and
%       range(2) indicating end time
%
% OUTPUTS:
%
%   x_filt :: filtered x data
%
%   y_filt :: filtered y data

OFFSET = 20;
r1 = max(range(1));
r2 = min(range(2));
x_filt = filter(hd, x);
x_filt = x_filt((1+OFFSET):end);
x_filt = x_filt(r1:r2);
x_filt = x_filt*(6.35/100);

y_filt = filter(hd, y);
y_filt = y_filt((1+OFFSET):end);
y_filt = y_filt(r1:r2);
y_filt = y_filt*(6.35/100);


end

