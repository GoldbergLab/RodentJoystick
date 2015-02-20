function [xc,yc,r] = xy_calib_script(data)

data = mean(data,1);
data_x = data(1:2:end);
data_y = data(2:2:end);

[xc,yc,r] = circfit(data_x,data_y);

