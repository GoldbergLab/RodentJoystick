function [labels] = draw_heat_map(data, ax, type, varargin)
% [labels] = draw_heat_map(data, ax, type, varargin)
%
%   Creates a two dimensional heat map, representing activity
%   distributions. Automatically computes pcolor values with options for
%   logarithmic scaling and color percentile selection.
%   Returns the X, Y labels used as well as the final title.
% 
% OUTPUTS:
%   
%       labels :: a struct with fields xlabel, ylabel, and title,
%           containing strings for each of these
%
% ARGUMENTS:
%
%       data :: 2-dimensional square matrix of data to be plotted
%  
%       ax :: axes handle  - unlike other functions, cannot be empty,
%           draw_heat_map requires an existing figure
%
%       type :: string that composes title to indicate what kind of
%           plot was performed ('Activity Heat Map'/'Velocity Heat Map'/...)
%
% OPTIONAL ARGS:
%
%       logmapping :: flag indicating whether data should be 
%           logarithmically scaled and plotted (1) or left as is (0)
%
%       colorperc :: color percentiles for pcolor axis 

default = {1, [5 80]};
numvarargs = length(varargin);
if numvarargs > 2
    error('too many arguments (> 4), only two required and two optional.');
end
[default{1:numvarargs}] = varargin{:};
[logmapping, colorperc] = default{:};
scalesize = size(data, 1);
if logmapping == 1
    data = log(data);
    traj_pdf = reshape(data, scalesize*scalesize, 1);
    traj_pdf = sort(traj_pdf(traj_pdf ~= -Inf ));
else
    traj_pdf = reshape(data, scalesize*scalesize, 1);
    traj_pdf = sort(traj_pdf(traj_pdf ~= 0));
end

%% Calculate information for plotting traj_pdf
pflag = 'Normal'; if logmapping == 1; pflag = 'Log'; end;
tstr = [type, ' (',pflag,' mapping)'];
xlab = 'X'; ylab = 'Y';
pcv2_ind = min(floor(colorperc(2)/100*length(traj_pdf)), length(traj_pdf));
pcolorval2 = traj_pdf(pcv2_ind);
pcv1_ind = max(floor(colorperc(1)/100*length(traj_pdf)), 1);
pcolorval1 = traj_pdf(pcv1_ind);


%% Nothing interesting, just actually plotting data now
axes(ax(1));
hold on; title(tstr); 
xlabel(xlab); ylabel(ylab);
scale = -100:(floor(201/scalesize)):100;
scale = scale(1:scalesize);
pcolor(ax, scale, scale, data); shading interp; axis square;
set(ax, 'XTick', [-100 -50 0 50 100]);
set(ax, 'YTick', [-100 -50 0 50 100]);
caxis([pcolorval1 pcolorval2]); hold off;

labels.xlabel = xlab; labels.ylabel = ylab; labels.title = tstr;
end

