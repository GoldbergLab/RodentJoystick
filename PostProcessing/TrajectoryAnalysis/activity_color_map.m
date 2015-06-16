function [data, labels] = activity_color_map(stats, varargin)
%activity_color_map(stats [ax, logmapping, colorperc ]) plots the probability distribution given
%by stats.traj_pdf_jstrial onto the axes handle ax if available (otherwise
%it simply generates a new figure)
% ARGUMENTS:
%   stats :: single stats structure
%   ax :: an axes handle (can be empty) for where activity_color_map should
%       plot 
%   logmappping :: a flag indicating whether the function should plot using
%       a logarithmic scale, or standard scale (1 or 0)
%   colorperc :: [lower upper] - colorperc defines the color percentiles
%       for the color mapping when logarithmic mapping is turned off
%

%% Processing Arguments, assuming defaults where necessary
default = {[], 1, [25 75]};
numvarargs = length(varargin);
if numvarargs > 3
    error('find_sector: too many arguments (> 4), only one required and three optional.');
end
[default{1:numvarargs}] = varargin{:};
[ax, logmapping, colorperc] = default{:};

%% Preliminary manipulation
%logarithmic mapping means we can use the entire color range without loss
if strcmp(logmapping, 1); colorperc = [0 99]; end;

%if ax is not given, create a new figure
if (length(ax)<1); figure; ax = gca(); end

%% Actual data processing
data = stats.traj_pdf_jstrial;
if strcmp(pflag, 'log')
    data = log(data);
    traj_pdf = reshape(data, 100*100, 1);
    traj_pdf = sort(traj_pdf(traj_pdf ~= -Inf ));
else
    traj_pdf = reshape(data, 100*100, 1);
    traj_pdf = sort(traj_pdf(traj_pdf ~= 0));
end

%% Calculate information for plotting traj_pdf
tstr = ['Activity Distribution: (',pflag,' scale)'];
xlab = '0.5*X+50'; ylab = '0.5*Y+ 50';

% Calculate actual color values
pcv2_ind = min(floor(colorperc(2)/100*length(traj_pdf)), length(traj_pdf));
pcolorval2 = traj_pdf(pcv2_ind);
pcv1_ind = max(floor(colorperc(1)/100*length(traj_pdf)), 1);
pcolorval1 = traj_pdf(pcv1_ind);

title(tstr); 
xlabel(xlab); ylabel(ylab);
pcolor(data); shading flat; axis square;
caxis([pcolorval1 pcolorval2]); hold off;

end

