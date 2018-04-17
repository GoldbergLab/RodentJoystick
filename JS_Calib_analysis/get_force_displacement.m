

dirlist = rdir(strcat('.\*\*\*\*.mat'));
figure
x_vect = [];
y_vect = [];

for i = 1:53
    load(dirlist(i).name);
    
    x = working_buff(:,1);
    y = working_buff(:,2);
    
    mean_x(i) = mean(x);
    mean_y(i) = mean(y);
    std_x = std(x);
    std_y = std(y);    
    
    hold on
    plot(mean_x(i),mean_y(i),'ro','markersize',2);
end

axis equal
axis([-100 100 -100 100])

mean_dist = (mean_x.^2 + mean_y.^2).^(0.5);

force_vect(mean_dist<20) = 5;
force_vect(mean_dist>20&mean_dist<40) = 15;
force_vect(mean_dist>40&mean_dist<60) = 25;
force_vect(mean_dist>60) = 32;

mean_arr(1) = mean(mean_dist(force_vect == 5));
std_arr(1) = std(mean_dist(force_vect == 5));

mean_arr(2) = mean(mean_dist(force_vect == 15));
std_arr(2) = std(mean_dist(force_vect == 15));

mean_arr(3) = mean(mean_dist(force_vect == 25));
std_arr(3) = std(mean_dist(force_vect == 25));

mean_arr(4) = mean(mean_dist(force_vect == 32));
std_arr(4) = std(mean_dist(force_vect == 32));

mean_dist = mean_dist*6.35/100;

[obj,gof] = fit(force_vect',mean_dist','poly1');

errorbar([5 15 25 32],(mean_arr*6.35/100)-obj.p2,std_arr*6.35/100,'ko');
hold on;
plot(0:1:40,(obj(0:1:40)-obj.p2),'r');
axis([0 40 0 4.35]);
xlabel('Force (mN)');
ylabel('Displacement (mm)');
axis square;
%legend(strcat('Coefficient: ',num2str(obj.p1),'mm/mN'));