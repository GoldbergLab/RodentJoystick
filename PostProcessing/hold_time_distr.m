function [ht_distr, holdtimes] = hold_time_distr(tstruct, hist_int, plotflag)
TIME_RANGE = 2000;
%hold_time_distr plots the distribution of hold times with a histogram
%   interval specified by hist_int on a time range of 0 to TIME_RANGE
%   milliseconds
% ARGUMENTS:
%   tstruct :: structure containing all the information about each
%       trajectory. NOT the same as jstruct - after running
%       stats = xy_getstats, tstruct = stats.traj_struct

holdtimes = zeros(length(tstruct), 1);
for i = 1:length(tstruct)
    holdtimes(i) = tstruct(i).posttouch;
end
timerange = 0:hist_int:TIME_RANGE;
[ht_distr] = histc(holdtimes, timerange);

if strcmp(plotflag, 'plot')
    plot = figure(1);
    xlabel('Hold Time (milliseconds)');
    stairs(timerange, ht_distr, 'b');
end

end

