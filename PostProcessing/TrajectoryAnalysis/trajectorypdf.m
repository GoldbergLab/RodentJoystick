function tpdf = trajectorypdf(stats,rw_only)
tpdf = zeros(100,100);
tstruct = stats.traj_struct;


for stlen = 1:length(tstruct)
    
        rw_onset = tstruct(stlen).rw_onset;
        
        if rw_onset == 0
            if rw_only == 1
                continue;
            else
                rw_onset = numel(tstruct(stlen).traj_y);
            end
        end
    
    traj_y_t = tstruct(stlen).traj_y(1:rw_onset);
    traj_x_t = tstruct(stlen).traj_x(1:rw_onset);
    curr_tpdf = hist2d([traj_y_t',traj_x_t'],-6.35:0.127:6.35,-6.35:0.127:6.35);
    tpdf = tpdf+curr_tpdf;
end