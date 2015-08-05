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
%

%% Argument Manipulation
default = {1, [5 80], [], []};

numvarargs = length(varargin);
if numvarargs > 4
    error('too many arguments (> 7), only 3 required and 4 optional.');
end
[default{1:numvarargs}] = varargin{:};
[logmapping, colorperc, xax, yax]= default{:};

if isempty(xax) || isempty(yax)
    xscalesize = size(data, 1);
    yscalesize = size(data, 2);
    xax = -100:(floor(201/scalesize)):100;
    yax = xax;
    activitymap = 1;
end

%% Mapping Data Appropriately
if logmapping == 1
    data = log(data);
    traj_pdf = reshape(data, xscalesize*yscalesize, 1);
    traj_pdf = sort(traj_pdf(traj_pdf ~= -Inf ));
else
    traj_pdf = reshape(data, xscalesize*yscalesize, 1);
    traj_pdf = sort(traj_pdf(traj_pdf ~= 0));
end

%% Calculate information for plotting traj_pdf
pflag = 'Normal'; if logmapping == 1; pflag = 'Log'; end;
tstr = [type, ' (',pflag,' mapping)'];
xlab = 'X'; ylab = 'Y';
pcolorval = prctile(traj_pdf, colorperc);


%% Nothing interesting, just actually plotting data now
axes(ax(1));
hold on; title(tstr); 
xlabel(xlab); ylabel(ylab);
scale = -100:(floor(201/scalesize)):100;
pcolor(ax, xax, yax, data); shading interp; axis square;
if activitymap
    set(ax, 'XTick', [-100 -50 0 50 100]);
    set(ax, 'YTick', [-100 -50 0 50 100]);  
end
caxis(pcolorval); hold off;

labels.xlabel = xlab; labels.ylabel = ylab; labels.title = tstr;
end

