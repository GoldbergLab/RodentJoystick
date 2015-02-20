function [] = traj_update(x,y,v1,t,v2,s1)
fopen(s1);
pause(1);
n_length = length(x);
fwrite(s1,3);
pause(0.1);
fwrite(s1,n_length);
pause(0.1);
for i=1:n_length
    fwrite(s1,v2(i));
    pause(0.1);
    fwrite(s1,t(i));
    pause(0.1);
    fwrite(s1,v1(i));
    pause(0.1);
    fwrite(s1,y(i));
    pause(0.1);
    fwrite(s1,x(i));
end
pause(0.1)
fwrite(s1,2);
pause(0.1);
fclose(s1);