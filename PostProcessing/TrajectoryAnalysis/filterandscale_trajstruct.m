function [tstruct] = filterandscale_trajstruct(tstruct)

d1 = fdesign.lowpass('N,F3db',8,50,1000);
hd1 = design(d1,'butter');

for ii=1:length(tstruct)
x = tstruct(ii).traj_x; y = tstruct(ii).traj_y;
%filter the data at 50HZ with a butterworth filter
x = filter(hd1,x); y = filter(hd1,y);

%Scale by radius
x = x*(6.25/100); y = y*(6.25/100);

tstruct(ii).traj_x = x;
tstruct(ii).traj_y = y;
end

