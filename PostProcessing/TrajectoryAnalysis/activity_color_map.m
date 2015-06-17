function [data, labels] = activity_color_map(stats, varargin)
%activity_color_map(stats [ax, logmapping, colorperc ]) plots the probability distribution given
%by stats.traj_pdf_jstrial onto the axes handle ax if available (otherwise
%it simply generates a new figure)
% ARGUMENTS:
%   stats :: single stats structure
%   logmappping :: a flag indicating whether the function should plot using
%       a logarithmic scale, or standard scale (1 or 0)
%   colorperc :: [lower upper] - colorperc defines the color percentiles
%       for the color mapping when logarithmic mapping is turned off
%   ax :: an axes handle (can be empty) for where activity_color_map should
%       plot 

default = {1, [25 75], []};
numvarargs = length(varargin);
if numvarargs > 3
    error('too many arguments (> 4), only one required and three optional.');
end
[default{1:numvarargs}] = varargin{:};
[colorperc, logmapping, ax] = default{:};
if logmapping == 1; colorperc = [0 99]; end;
if (length(ax)<1); figure; ax = gca(); end

data = stats.traj_pdf_jstrial;
if logmapping == 1
    data = log(data);
    traj_pdf = reshape(data, 100*100, 1);
    traj_pdf = sort(traj_pdf(traj_pdf ~= -Inf ));
else
    traj_pdf = reshape(data, 100*100, 1);
    traj_pdf = sort(traj_pdf(traj_pdf ~= 0));
end
%% Calculate information for plotting traj_pdf
pflag = 'Normal'; if logmapping == 1; pflag = 'Log'; end;
tstr = ['Trajectory Distribution: (',pflag,' scale)'];
xlab = 'X'; ylab = 'Y';

pcv2_ind = min(floor(colorperc(2)/100*length(traj_pdf)), length(traj_pdf));
pcolorval2 = traj_pdf(pcv2_ind);
pcv1_ind = max(floor(colorperc(1)/100*length(traj_pdf)), 1);
pcolorval1 = traj_pdf(pcv1_ind);
axes(ax(1));
hold on; title(tstr); 
xlabel(xlab); ylabel(ylab);
pcolor(ax, -98:2:100, -98:2:100, data); shading flat; axis square;
set(ax, 'XTick', [-100 -50 0 50 100]);
set(ax, 'YTick', [-100 -50 0 50 100]);
caxis([pcolorval1 pcolorval2]); hold off;

labels.xlabel = xlab; labels.ylabel = ylab; labels.title = tstr;

