
%[thresh, holdtime, centerhold, sector, oldcont] 
%   = recommend_contigencies(handles, exptdir, dirlist, boxnum)
% takes in an experiment director, the list of directories for which to
% generate its analysis, and a box number as an identifier. 
% handles is a set of handles for an instance of a valid automated analysis
%   The functions below should be edited if you want to change how new
%   contingencies are automatically updated.
function [thresh, holdtime, centerhold, sector, oldcont] = recommend_contigencies(handles, exptdir, dirlist, boxnum)
%Automatically recommends a set of contigencies based on data from dirlist
%   (implicitly assumes all entries in dirlist are from the same day)

%PELLET COUNT THRESHOLD - if a mouse receives anything lower, contingency
%will not change
pellet_count_threshold = 100;

stats = load_stats(dirlist, 1);

[thresh, holdtime, centerhold, sector] = load_contingencies(exptdir, boxnum);
oldcont.thresh = thresh; oldcont.holdtime = holdtime;
oldcont.centerhold = centerhold; oldcont.sector = sector;

%Is average daily pellet count acceptable? (Also looks at Pellet Count
%Override, which ignores the threshold)
stats = load_stats(dirlist, 1);
pc_acceptable = ((stats.pellet_count)/length(dirlist) >= pellet_count_threshold) ...
                    || get(handles.pcoverride, 'Value');
rewardrate = str2num(get(handles.rewardrate, 'String'));

if pc_acceptable && get(handles.thresholdselect, 'Value')
    thresh = recommend_threshold(dirlist, rewardrate);
elseif pc_acceptable && get(handles.holdtimeselect, 'Value')
    holdtime = recommend_holdtime(dirlist, rewardrate);
elseif pc_acceptable && get(handles.centerthresholdselect, 'Value')
    centerhold = recommend_centerhold(dirlist, rewardrate, holdtime, centerhold);
elseif pc_acceptable && get(handles.sectorselect, 'Value')
    sector = recommend_sector(dirlist, rewardrate);
end

end

function thresh = recommend_threshold(dirlist, rewardrate)
    %this will need to be changed to include current hold time/distance
    %information
    thresh = 1;
end

function holdtime = recommend_holdtime(dirlist, rewardrate)
    holdtime = 200;
end

function centerhold = recommend_centerhold(dirlist, rewardrate, oldht, oldcenterhold)
    %LOWEST POSSIBLE VALUE FOR CENTERHOLD
    MIN_CH = 20;
    [set_dists] = multi_js_touch_dist(dirlist, rewardrate, oldcenterhold, oldht, 0, 0);
    centerhold = prctile(set_dists, 50);
    centerhold = max(centerhold, MIN_CH);
end

function sector = recommend_sector(dirlist, rewardrate)
    sector = [-180 180];
end

function [threshold, holdtime, centerhold, sector] = load_contingencies(exptdir, boxnum)
    fid = fopen([exptdir,'\Box_', num2str(boxnum),'\contingency.txt']);
    info = textscan(fid,'%s %s %f',6);
    threshold = info{3}(2); holdtime = info{3}(3); centerhold = info{3}(4); 
    sector = [info{3}(5) info{3}(6)];
end