function [quality] = fit_speed_model(speed, redir_points)
quality = zeros(length(redir_points)-1, 1);

for i = 1:(length(redir_points)-1)
    timetmp = redir_points(i):redir_points(i+1);
    speedtmp = speed(timetmp);
    [f, gof] = fit(timetmp', speedtmp, 'gauss1');
    %hold off; plot(f, timetmp, speedtmp); 
    quality(i) = gof.rsquare;
end


end

