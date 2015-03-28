function [angles] = angle_distr(stats, thresh, angle_int)

tstruct = stats.traj_struct;
angles = []; x = []; y = [];
for i = 4:length(tstruct)
    temp = get_angles(tstruct(i).traj_x, tstruct(i).traj_y, thresh);
    x = [x; (tstruct(i).traj_x)'];
    y = [y; (tstruct(i).traj_y)'];
    angles = [angles;temp'];
end
figure(1);
plot(x, y);
axis([-100 100 -100 100]); hold on
for i = 10:10:100;
    t = 0:0.1:2*pi; hold on;
    plot(i*cos(t), i*sin(t)); hold on;
end
figure(2);
rose(angles, floor(360/angle_int));

end

function [angles] = get_sector(x, y, thresh)
    k=1; x = (x./100); y= (y./100);
    mag = (x.^2 + y.^2).^0.5;
    angles = [];
    for i = 1:length(x)
        if mag(i) > thresh
        invc = acosd(x(i)/mag(i));
        invs = asind(x(i)/mag(i));
        if invc <= 90
            if invs >= 0
                angles(k) = invs;
            else
                angles(k)=360+invs;
            end
        else
            if invs>=0
                angles(k) = invc;
            else
                angles(k) = 180 - invs;
            end
        end
        k=k+1;
        end
    end
end