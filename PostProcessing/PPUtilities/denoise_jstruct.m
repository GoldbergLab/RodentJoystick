function jstruct = denoise_jstruct(jstruct)
for i = 1:length(jstruct)
    traj_x = jstruct(i).traj_x;
    traj_x = medfilt1(traj_x);
    jstruct(i).traj_x = traj_x;
    traj_y = jstruct(i).traj_y;
    traj_y = medfilt1(traj_y);
    jstruct(i).traj_y = traj_y;
end

