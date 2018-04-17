function [f] = make_avi(data,avi_path)

traj_x = data(:,1);
traj_y = data(:,2);

d = fdesign.lowpass('N,F3db',8, 50, 1000);
hd = design(d, 'butter');
[traj_x, traj_y] = filter_noise_traj(traj_x, traj_y, hd,[21, numel(traj_x)-20]);

laser_on_off = find(abs(diff(data(:,7))));
laser_len = laser_on_off(2)-laser_on_off(1);

a = sin((2*pi*40).*((0:laser_len)/1000))*0.5+0.5;
b = sin((2*pi*40).*((laser_len:(laser_len+99)))/1000).*(1:-0.01:0.01)/2+(1:-0.01:0.01)/2;

data(laser_on_off(1):(laser_on_off(2)+100),7) = [a';b'];

%% Trace vs Times

figure;
pause(0.00001);
frame_h = get(handle(gcf),'JavaFrame');
set(frame_h,'Maximized',1); 

hold on;

xlim([1 956]);
ylim([0 57]);

% %intact
% js_on_off = [638,830];
%inactivated
js_on_off = [205,839];

sens_index = [7 6 4 3 5];
c_str = 'rgkbk';
for i=1:(numel(traj_x)/2 - 1)
    
    cla
    index = (1):(1+i*2);
      
    for j = 1:5
        plot(index,4*data(index + 20,sens_index(j)) + j*5,'linewidth',4,'Color',c_str(j));
    end    
    
    if (i<(js_on_off(1)/2))
        plot(index,traj_y(index) + 40,'linewidth',4,'color',[128 128 128]/256);
        plot(index,traj_x(index) + 50,'linewidth',4,'color',[128 128 128]/256);
    elseif (i>(js_on_off(2)/2))
        plot(index(1:js_on_off(1)),traj_y(index(1:js_on_off(1))) + 40,'linewidth',4,'color',[128 128 128]/256);
        plot(index(1:js_on_off(1)),traj_x(index(1:js_on_off(1))) + 50,'linewidth',4,'color',[128 128 128]/256);
        
        plot(index(js_on_off(1):js_on_off(2)),traj_y(index(js_on_off(1):js_on_off(2))) + 40,'linewidth',4,'color','b');
        plot(index(js_on_off(1):js_on_off(2)),traj_x(index(js_on_off(1):js_on_off(2))) + 50,'linewidth',4,'color','b');
        
        plot(index(js_on_off(2):end),traj_y(index(js_on_off(2):end)) + 40,'linewidth',4,'color',[128 128 128]/256);
        plot(index(js_on_off(2):end),traj_x(index(js_on_off(2):end)) + 50,'linewidth',4,'color',[128 128 128]/256);
    else
        plot(index(1:js_on_off(1)),traj_y(index(1:js_on_off(1))) + 40,'linewidth',4,'color',[128 128 128]/256);
        plot(index(1:js_on_off(1)),traj_x(index(1:js_on_off(1))) + 50,'linewidth',4,'color',[128 128 128]/256);
        
        plot(index(js_on_off(1):end),traj_y(index(js_on_off(1):end)) + 40,'linewidth',4,'color','b');
        plot(index(js_on_off(1):end),traj_x(index(js_on_off(1):end)) + 50,'linewidth',4,'color','b');        
    end
    
    set(gca,'xtick',[])
    set(gca,'xticklabel',[])
    
    set(gca,'ytick',[])
    set(gca,'yticklabel',[])
    
    f(i) = getframe(gca);                    
end

v = VideoWriter(strcat(avi_path,'.avi'));
open(v);
writeVideo(v,f);
close(v);

clear f;

%% Polar Trace
figure;
pause(0.00001);
frame_h = get(handle(gcf),'JavaFrame');
set(frame_h,'Maximized',1); 

hold on;

xlim([-6.35 6.35]);
ylim([-6.35 6.35]);

axis square;
t_d = 0:1:360;
sin_dt = sind(t_d);
cos_dt = cosd(t_d);

for i=1:((numel(traj_x)-25)/2 - 1)
    cla
    
    y_di = 2*sin_dt;
    x_di = 2*cos_dt;
    
    y_do = 4*sin_dt;
    x_do = 4*cos_dt;
        
    plot(x_di,y_di,'k','linewidth',4);
    plot(x_do,y_do,'k','linewidth',4);
    plot(x_do(290:350),y_do(290:350),'g','linewidth',4);
    
    index = (1+(i-1)*2):(25+i*2);
    
    if (i<(js_on_off(1)/2)) || (i>(js_on_off(2)/2))
        plot(traj_x(index),traj_y(index),'linewidth',4,'color',[128 128 128]/256);                      
    else
        plot(traj_x(index),traj_y(index),'linewidth',4,'color','b');
    end
    
    set(gca,'xtick',[])
    set(gca,'xticklabel',[])
    
    set(gca,'ytick',[])
    set(gca,'yticklabel',[])
    
    f(i) = getframe(gca);            
end

 v = VideoWriter(strcat(avi_path,'pol.avi'));
 open(v);
 writeVideo(v,f);
 close(v);

 %% Final Figure Polar
 figure;
 pause(0.00001);
 frame_h = get(handle(gcf),'JavaFrame');
 set(frame_h,'Maximized',1);
 
 hold on;
 
 xlim([-6.35 6.35]);
 ylim([-6.35 6.35]);
 
 axis square;
 
 y_di = 2*sin_dt;
 x_di = 2*cos_dt;
 
 y_do = 4*sin_dt;
 x_do = 4*cos_dt;
 
 plot(x_di,y_di,'k','linewidth',4);
 plot(x_do,y_do,'k','linewidth',4);
 plot(x_do(290:350),y_do(290:350),'g','linewidth',4);
 
 plot(traj_x(js_on_off(1):js_on_off(2)),traj_y(js_on_off(1):js_on_off(2)),'linewidth',4,'color','b');

 
 
 

