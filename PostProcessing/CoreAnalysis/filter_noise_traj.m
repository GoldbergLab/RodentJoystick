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
%   range :: 2 element vector with range(1) indicating start time, and
%       range(2) indicating end time
%
% OUTPUTS:
%
%   x_filt :: filtered x data
%
%   y_filt :: filtered y data

OFFSET = 20;
x = x(range(1)-OFFSET:range(2)+OFFSET);
x_filt = filter(hd, x);
x_filt = x_filt(OFFSET:end-OFFSET);

y = y(range(1)-OFFSET:range(2)+OFFSET);
y_filt = filter(hd, y);
y_filt = y_filt(OFFSET:end-OFFSET);

end

