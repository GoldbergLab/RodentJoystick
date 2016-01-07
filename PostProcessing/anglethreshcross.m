function [theta,line] = anglethreshcross(tstruct,varargin)
%% argument handling
default = {30, 1, [], 'b'};
numvarargs = length(varargin);
if numvarargs > 5
    error('find_sector: too many arguments (> 6), only one required and five optional.');
end
[default{1:numvarargs}] = varargin{:};
[thresh, plotflag, ax, color] = default{:};
if plotflag == 1 && length(ax)<1; figure; ax = gca(); end;
axes(ax);
hold on;
k=0;

for i=1:length(tstruct)
    index = find(tstruct(i).magtraj>thresh);
    thresh_cross = min(index);
   if index>100
    if numel(thresh_cross)
        k=k+1;
        [theta(k),rho] = cart2pol(tstruct(i).traj_x(thresh_cross),tstruct(i).traj_y(thresh_cross));
    end
   end
end

% theta(sign(theta)==-1) = 2*pi + theta(sign(theta)==-1);
edges = -1*pi:10*(pi/180):pi;
dist_theta = histc(theta,edges);
dist_theta = dist_theta./(sum(dist_theta));
median(theta)
%  x_pl = dist_theta.*(cosd(0:10:360));
%  y_pl = dist_theta.*(sind(0:10:360));
% 
%  line = plot(x_pl,y_pl,color);
line = stairs(-180:10:180,dist_theta,color);
hold off;