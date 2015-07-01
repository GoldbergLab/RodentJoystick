% getmaxcontlength(magtraj, thresh) finds the maximum length of time for a 
% given trajectory that the joystick deviation (magnitude) stayed within a
% threshold
% ARGUMENTS:
%   magtraj :: a vector corresponding to the magnitude of a trajectory over
%       time 
%   thresh :: threshold for reward - a number in the range of 0-100
%       (though 0 wouldn't make much sense as a threshold)
% OUTPUT:
%   max_cont_len :: a number corresponding to the maximum time the
%       specified trajectory (magtraj) remained within the threshold
%       (thresh)
function max_cont_len = getmaxcontlength(magtraj,thresh)
thresh_ind = magtraj<thresh;
m=1;
%% Get the max length
if sum(thresh_ind)>1
    %following three lines generate vector of transitions to show when the
    % joystick crosses the threshold - either going above, or back below
    tch_transition = diff([0 thresh_ind 0]);
    b=tch_transition;
    flag=1;
    %for loop iterates over entire trajectory magnitude structure
    % and generates a list of pairs corresponding to segments where the
    % joystick remained within the threshhold
    for j=1:length(b)
        if b(j)==1 && flag==1
            d(m,1) = j;
            d(m,2) = 0;
            flag=0;
        elseif b(j)==-1 && flag==0
            d(m,2) = j;
            flag=1;
            m=m+1;
        end
    end
    %now just look at list of pairs and pick out the maximum length
    try
        max_cont_len = max((d(:,2)-d(:,1)))-1;
    catch
        max_cont_len=0;
    end
else
    max_cont_len=0;
end

