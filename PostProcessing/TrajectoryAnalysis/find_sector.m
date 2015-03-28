function [angles] = find_sector(stats, thresh, angle_int)

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

%get_sector(x,y, thresh) obtains the sector found by looking at all x,y
%values of the trajectory with magnitude above the threshold.
%The sector is given as a vector of angles indicating the sector, rather
%than two points. I.e. the sector from the angle 2 to 25 is given by the
%vector 2:1:25. This is to avoid any confusion, for example with the angles
%340, and 5. 
%This will be represented by the vector [340, 341, ... 359, 0, 1, ... 5]'
function [sector] = get_sector(x, y, thresh)
    [angles, rad] = cart2pol(x, y);
    angles=angles(rad>thresh);
    if length(angles)<2
        sector = -1;
    else
        minim = min(angles);
        maxim = max(angles);
        %weird trajectory - give error signal
        if (minim == maxim) || (length(angles) == 2) || minim > maxim
            sector = -1;
        else
            angles = angles(angles~=minim && angles~=maxim);
            test= angles(floor(length(angles)/2)+1);
            first = 0; second = 0;
            if test<minim || test > maxim
                first = maxim; second = minim;
            elseif test>minim && test<maxim
            end
                

            sector = minim:1:maxim;
        end
    end
end