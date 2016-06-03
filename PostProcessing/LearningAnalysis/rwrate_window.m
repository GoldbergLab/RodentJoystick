function [rw_vect] = rwrate_window(stats,windowlen)

a = 1;
b = ones(windowlen,1)/windowlen;

rw = [stats.traj_struct.rw];
rw_vect = filter(b,a,rw);
