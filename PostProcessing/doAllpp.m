function doAllpp(working_dir) 
working_dir
if (numel(working_dir)==0)
working_dir = uigetdir(pwd);
end
%%Combine files
 ppscript(working_dir);
 
%%filter nose poke data
%  xy_np_combine(working_dir_1);

%Get the onsets and joystick movements
%[np js] =xy_js_onset(working_dir_1);

%plot the onset aligned joystick onsets
  %list = np_js_dist(np,js);

% t_stats = traj_stat(np,js,working_dir);
jstruct=xy_makestruct(working_dir);

save(strcat(working_dir,'/jstruct.mat'),'jstruct');