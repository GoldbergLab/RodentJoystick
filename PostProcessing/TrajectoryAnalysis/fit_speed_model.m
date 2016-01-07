function [quality] = fit_speed_model(speed, redir_points)
quality = zeros(length(redir_points)-1, 1);

for i = 1:(length(redir_points)-1)
    timetmp = redir_points(i):redir_points(i+1);
%     timetmp = timetmp(10:(end-10));
    speedtmp = speed(timetmp);
    try
    %[f, gof] = fit(timetmp', speedtmp, 'poly2' ,'Normalize','on');
    quality(i) = numel(findpeaks(diff(speedtmp)));
    
    %quality(i) = gof.rsquare;
    %hold off; plot(f, timetmp, speedtmp); 
    end


end

