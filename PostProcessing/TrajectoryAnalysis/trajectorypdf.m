function tpdf = trajectorypdf(stats,rw_only)
tpdf = zeros(100,100);
tstruct = stats.traj_struct;


for stlen = 1:length(tstruct)
    
    if (tstruct(stlen).rw == rw_only) || ~rw_only
        traj_y_t = tstruct(stlen).traj_y;%*6.35/100;
        traj_x_t = tstruct(stlen).traj_x;%*6.35/100;
        curr_tpdf = hist2d([traj_y_t',traj_x_t'],-6.35:0.127:6.35,-6.35:0.127:6.35);
        tpdf = tpdf+curr_tpdf;
    end
end