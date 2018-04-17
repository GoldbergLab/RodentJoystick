function seg_dir = get_seg_dir_teja(seg_list)

for i=1:numel(seg_list)
    [~,locs] = findpeaks(seg_list(i).velprofile);
    if numel(locs)
        vel_x = diff(seg_list(i).traj_x);vel_y=diff(seg_list(i).traj_y);
        vel_x = vel_x(locs(1));vel_y = vel_y(locs(1));
        seg_dir(i) = rad2deg(atan2(vel_y,vel_x));
    else
        seg_dir(i) = nan;
    end
end

end