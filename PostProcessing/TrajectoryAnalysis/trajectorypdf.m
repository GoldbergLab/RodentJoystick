function tpdf = trajectorypdf(stats)
tpdf = zeros(100,100);
tstruct = stats.traj_struct;

for stlen = 1:length(tstruct)
    traj_y_t = tstruct(stlen).traj_y;
    traj_x_t = tstruct(stlen).traj_x;
    curr_tpdf = hist2d([traj_y_t',traj_x_t'],-100:2:100,-100:2:100);
    tpdf = tpdf+curr_tpdf;
end