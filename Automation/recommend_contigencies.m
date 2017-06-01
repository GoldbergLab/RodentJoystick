%[thresh, holdtime, centerhold, sector, oldcont] 
%   = recommend_contigencies(handles, exptdir, dirlist, boxnum)
% takes in an experiment director, the list of directories for which to
% generate its analysis, and a box number as an identifier. 
% handles is a set of handles for an instance of a valid automated analysis
%   The functions below should be edited if you want to change how new
%   contingencies are automatically updated.
function [thresh, holdtime, centerhold, sector, oldcont] = recommend_contigencies(handles, exptdir, dirlist, duplicates)
%Automatically recommends a set of contigencies based on data from dirlist
%   (implicitly assumes all entries in dirlist are from the same day)

%PELLET COUNT THRESHOLD - if a mouse receives anything lower, contingency
%will not change
pellet_count_threshold = 100;

[thresh, holdtime, centerhold, sector] = load_contingencies(dirlist);
oldcont.thresh = thresh; oldcont.holdtime = holdtime;
oldcont.centerhold = centerhold; oldcont.sector = sector;

%Is average daily pellet count acceptable? (Also looks at Pellet Count
%Override, which ignores the threshold)
stats = load_stats(dirlist, 1, 0, 0, 'pellet_count');

%get the relvant box number
split_path = strsplit(dirlist(1).name,'\');
split_cont = strsplit(split_path{end-2},'_');
boxnum_str = split_cont{2};

%pc_acceptable = ((stats.pellet_count)/(length(dirlist)-duplicates) >= pellet_count_threshold) ...
%                    || ~get(handles.pcoverride, 'Value');
rewardrate = str2num(get(handles.rewardrate, 'String'));
dir_def = 0;
split_def = 0;

if get(handles.thresholdselect, 'Value')
    thresh = recommend_threshold(dirlist, rewardrate);
elseif get(handles.holdtimeselect, 'Value')
    holdtime = recommend_holdtime(dirlist, rewardrate);
elseif get(handles.centerthresholdselect, 'Value')
    centerhold = recommend_centerhold(dirlist, rewardrate, holdtime, centerhold);
elseif get(handles.sectorselect, 'Value')
    split = eval(strcat('get(handles.SplitSel',boxnum_str,',''Value'')'))-1;
    def_dir = eval(strcat('get(handles.MovDir',boxnum_str,',''Value'')'))-1;
    
   %%Find the datenum for the files in the selected directories, and pick the
   %%directory with the newest file
   
    for dirind = 1:length(dirlist)
        fl = rdir(strcat(dirlist(dirind).name,'/*.dat'));
        max_datenum(dirind) = max([fl.datenum]);
    end
    
    dirlist_index = (max_datenum==max(max_datenum));
    
    sector = update_contingency(dirlist(dirlist_index),rewardrate,split,def_dir);
    sector = [sector(1) sector(2) sector(4) sector(5)];
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
    MIN_CH = 30;
    hist_interval = 20; combineflag = 1; plotflag = 0;
    [set_dists] = multi_js_touch_dist(dirlist, hist_interval, rewardrate, ...
        oldcenterhold, oldht, combineflag, plotflag);
    centerhold = set_dists;
    centerhold = max(centerhold, MIN_CH);
    if centerhold > oldcenterhold
        centerhold = oldcenterhold;
    end
end

function [threshold, holdtime, centerhold, sector] = load_contingencies(dayscompare)
    last = dayscompare(end).name;
    datecont = strsplit(last, '\');
    datecont = strsplit(datecont{end-1}, '_');
    threshold = str2num(datecont{2});
    holdtime = str2num(datecont{3});
    centerhold = str2num(datecont{4});
    sector = [str2num(datecont{5}) str2num(datecont{6}) str2num(datecont{7}) str2num(datecont{8})];
end