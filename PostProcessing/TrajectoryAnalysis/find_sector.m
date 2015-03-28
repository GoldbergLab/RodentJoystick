function [angle_distr] = find_sector(stats, thresh, colorperc)

tstruct = stats.traj_struct;
%360th slot corresponds to 0
angle_distr = zeros(360,1);
for i = 1:length(tstruct)
    [first, second] = get_sector(tstruct(i).traj_x,tstruct(i).traj_y,thresh);
    if first ~= -1 && second ~= -1
        if (first == 0); first = 360; end
        if (second == 0); second = 360; end
        indices = first:second;
        if (first>second); indices = [first:360, 1:second]; end
        angle_distr(indices)=1+angle_distr(indices);
    end
end

%Plot results from traj_pdf
subplot(1,3,1);
traj_pdf = reshape(log(stats.traj_pdf_jstrial), 100*100, 1);
traj_pdf = sort(traj_pdf(traj_pdf ~= -Inf ));
pcolorval2 = traj_pdf(floor(colorperc(2)/100*length(traj_pdf)));
pcolorval1 = traj_pdf(floor(colorperc(1)/100*length(traj_pdf))+1);
toplot = log(stats.traj_pdf_jstrial);
pcolor(toplot); shading flat; axis square; caxis([pcolorval1 pcolorval2]); hold on;
plot(sin(0:0.1:2*pi), cos(0:0.1:2*pi), 'y');
hold off;
%Plot angle histogram

subplot(1,3,2); %plot actual angle distribution (normalized)?
axis([1 359 0 inf]); hold on
colorv = [0.75 0.7 0.6 0.5];
for i = 25:25:100
    angle_dist = get_angle_distr_for_thresh(stats, i);
    c = colorv(i/25);
    plot(1:1:360, angle_dist./(sum(angle_dist)), 'Color', [c c c]);
end
plot(1:1:360, angle_distr./(sum(angle_distr)), 'r');

subplot(1,3,3); %plot 

end

function [angle_distr] = get_angle_distr_for_thresh(stats, thresh)
tstruct = stats.traj_struct;
%360th slot corresponds to 0
angle_distr = zeros(360,1);
for i = 1:length(tstruct)
    [first, second] = get_sector(tstruct(i).traj_x,tstruct(i).traj_y,thresh);
    if first ~= -1 && second ~= -1
        if (first == 0); first = 360; end
        if (second == 0); second = 360; end
        indices = first:second;
        if (first>second); indices = [first:360, 1:second]; end
        angle_distr(indices)=1+angle_distr(indices);
    end
end
end

%get_sector(x,y, thresh) obtains the sector found by looking at all x,y
%values of the trajectory with magnitude above the threshold.
%The sector is given as two positive angles in [0, 359] with first = the
%start of the sector, and second the end, always moving counterclockwise
function [first, second] = get_sector(x, y, thresh)
    [angles, rad] = cart2pol(x, y);
    angles=angles(rad>thresh).*180./pi;
    if length(angles)<2
        first = -1; second = -1;
    else
        minim = floor(min(angles));
        maxim = floor(max(angles));
        %weird trajectory - give error signal
        if (minim == maxim) || (length(angles) == 2) || minim > maxim || length(angles)<2
            first = -1; second = -1;            
        else
            angles = angles(angles~=minim & angles~=maxim);
            test= angles(floor(length(angles)/2)+1);
            if test<minim || test > maxim
                first = maxim; second = minim;
            else
                first = minim; second = maxim;
            end
            if first<0
                first = first+360;
            end
            if second<0
                second = second+360;
            end
        end
    end
end