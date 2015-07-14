function [dist, holdtime, centerhold, sector] = recommend_contigencies(handles, dirlist)
%Automatically recommends a set of contigencies based on data from dirlist
%   (implicitly assumes all entries in dirlist are from the same day)

%PELLET COUNT THRESHOLD - if a mouse receives anything lower, contingency
%will not change
pellet_count_threshold = 100;

%set defaults to current values (implemented later, temp for now)
dist = 100; holdtime = 200; centerhold = 100; sector = [-180 180];

stats = load_stats(dirlist, 1);

%daily pellet count is acceptable
pc_acceptable = (stats.pellet_count)/length(dirlist) >= pellet_count_threshold;
rewardrate = str2num(get(handles.rewardrate, 'String'));

if pc_acceptable && get(handles.thresholdselect, 'Value')
    dist = recommend_threshold(dirlist, rewardrate);
elseif pc_acceptable && get(handles.holdtimeselect, 'Value')
    holdtime = recommend_holdtime(dirlist, rewardrate);
elseif pc_acceptable && get(handles.centerthresholdselect, 'Value')
    centerhold = recommend_centerhold(dirlist, rewardrate);
elseif pc_acceptable && get(handles.sectorselect, 'Value')
    sector = recommend_sector(dirlist, rewardrate);
end


end

function dist = recommend_threshold(dirlist, rewardrate)
    %this will need to be changed to include current hold time/distance
    %information
    disp(dirlist(1).name);
    [set_dists] = multi_js_touch_dist(dirlist, rewardrate, 80, 200, 0);
    dist = prctile(set_dists, 50);
end

function holdtime = recommend_holdtime(dirlist, rewardrate)
    holdtime = 200;
end

function centerhold = recommend_centerhold(dirlist, rewardrate)
    centerhold = 40;
end

function sector = recommend_sector(dirlist, rewardrate)
    sector = [-180 180];
end
