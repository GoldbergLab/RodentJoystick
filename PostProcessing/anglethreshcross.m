function [theta] = anglethreshcross(tstruct,thresh,varargin)
k=0;
for i=1:length(tstruct)    
    index = find(tstruct(i).magtraj>thresh);
    thresh_cross = min(index);
    if numel(thresh_cross)
        k=k+1;
        [theta(k),rho] = cart2pol(tstruct(i).traj_x,tstruct(i).traj_y);
    end
end