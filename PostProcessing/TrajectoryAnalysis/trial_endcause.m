function [laser_endcause,nonlaser_endcause] = trial_endcause(tstruct,plotflag)

% 1: Joystick let go
% 2: Nose Poke disengaged
% 3: Fixed Post let go

laser_endcause=[];
nonlaser_endcause=[];
for i=1:length(tstruct)
    
    if tstruct(i).laser == 1
        laser_endcause = [laser_endcause tstruct(i).stop_index];
    else
        nonlaser_endcause =[nonlaser_endcause tstruct(i).stop_index];
    end
end

if plotflag
    figure;
    l = histc(laser_endcause,1:4)./(numel(laser_endcause));
    nl = histc(nonlaser_endcause,1:4)./(numel(nonlaser_endcause));
    stairs(1:4,l,'r');
    hold on;
    stairs(1:4,nl,'b');
end