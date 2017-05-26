function [redir_points, quality, data] = detect_sharpturns(traj)
%take in a single trajectory, and fit a smoothing spline - then examine
%redirection points.

[redir_points,quality, data] = zero_points(traj.traj_x_seg, traj.traj_y_seg);

end

% zero_points(x, y, r_scale)
%
%   takes in x-y data and computes all local redirection points by
%   examining changes in radius of curvature and changes in speed
%
% ARGUMENTS
%   
%   x :: a vector of x position
%
%   y :: a vector of y position
%
%   r_scale :: a (1/0) flag indicating whether to scale data by the radius
%       or leave as is.
function [redir_points, quality, data]= zero_points(x, y)
cubic_x = fit((1:length(x))',x','cubicinterp');
cubic_y = fit((1:length(y))',y','cubicinterp');

x = cubic_x(1:0.1:length(x));
y = cubic_y(1:0.1:length(y));

x_d = diff(x);
y_d = diff(y);
        
x_dd = diff(x_d); y_dd = diff(y_d);        
x_d = x_d(2:end); y_d = y_d(2:end);
r_c = ((x_d.^2+y_d.^2).^(1.5))./(x_d.*y_dd-y_d.*x_dd); r_c = abs(r_c);

speed = (x_d.^2 + y_d.^2).^(0.5);
theta_dot = diff(wrapTo2Pi(atan2(y, x)));

[~,speed_minima] = findpeaks(speed*-1);
[~,r_curv_minima] = findpeaks(r_c*-1);
[~, theta_dot_minima] = findpeaks(theta_dot*-1);
[~, theta_dot_maxima] = findpeaks(theta_dot);
theta_dot_cp = [theta_dot_minima; theta_dot_maxima];

data.speed = speed(1:10:end)*10;
data.r_curv = r_c(1:10:end);
data.r_curv_minima = round(r_curv_minima./10);
data.speed_minima = round(speed_minima./10);

redir_points = [0];

for kk=1:length(speed_minima)
   %check if the speed minimum is close to a radius of curvature change
   if (min(abs(r_curv_minima - speed_minima(kk))))<10 %&&  ...
           %(min(abs(theta_dot_cp - speed_minima(kk))))<100
       if (speed_minima(kk) - redir_points(end))>30
        redir_points = [redir_points speed_minima(kk)];
       end
   end
end

redir_points = redir_points(redir_points>0);

[quality] = fit_speed_model(speed, redir_points);

redir_points = round(redir_points./10);

end
