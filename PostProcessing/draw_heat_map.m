function [labels] = draw_heat_map(data, ax, type, scale, varargin)
%Creates a two dimensional heat map, representing things such as activity
%distributions.
default = {1, [5 80]};
numvarargs = length(varargin);
if numvarargs > 2
    error('too many arguments (> 4), only two required and two optional.');
end
[default{1:numvarargs}] = varargin{:};
[logmapping, colorperc] = default{:};
scalesize = length(scale);
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

axes(ax(1));
hold on; title(tstr); 
xlabel(xlab); ylabel(ylab);
pcolor(ax, scale, scale, data); shading interp; axis square;
set(ax, 'XTick', [-100 -50 0 50 100]);
set(ax, 'YTick', [-100 -50 0 50 100]);
caxis([pcolorval1 pcolorval2]); hold off;

labels.xlabel = xlab; labels.ylabel = ylab; labels.title = tstr;
end

