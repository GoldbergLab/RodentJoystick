function [holdtimes,ht_distr, phandle] = hold_time_distr(tstruct, hist_int, plotflag)
TIME_RANGE = 2000;
%hold_time_distr plots the distribution of hold times with a histogram
%   interval specified by hist_int on a time range of 0 to TIME_RANGE
%   milliseconds
% ARGUMENTS:
%   tstruct :: structure containing all the information about each
%       trajectory. NOT the same as jstruct - after running
%       stats = xy_getstats, tstruct = stats.traj_struct
%   hist_int :: size of the bins for data generation and histogram plotting
%   plotflag :: flag that tells hold_time_distr whether to generate data or
%       plot - 'plot' - plots the figure, 'data' - just returns data
%       without plotting

holdtimes = zeros(length(tstruct), 1);
for i = 1:length(tstruct)
    holdtimes(i) = length(tstruct(i).magtraj);
end
timerange = 0:hist_int:TIME_RANGE;
[ht_distr] = histc(holdtimes, timerange);

if strcmp(plotflag, 'plot')
    phandle = figure(1);
    xlabel('Hold Time (milliseconds)');
    stairs(timerange, ht_distr, 'b');
end

end

