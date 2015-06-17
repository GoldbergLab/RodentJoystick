function [ hold_dist ] = holdtime_firstcontact_distribution(jstruct, varargin)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

[~,hold_dist]=xy_holddist(jstruct,dist_thresh_ip,0.75);    
dist_time_hld = 0:10:600;
holddist_vect = histc(hold_dist,dist_time_hld);

try
    axes(ax);
    xlabel('Time (ms)'); ylabel('# of trials');
    title('JS first contact hold time at thresh');
    stairs(dist_time_hld, holddist_vect,'b','LineWidth',2);
    hold on
catch
    error('Failure in plotting');
end

end

