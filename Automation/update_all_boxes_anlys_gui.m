% updates all information for all boxes in the GUI, including basic
% statistics and current contingency information.
% update_all_boxes_anlys_gui(handles) also puts recommendations based on
%   post processing analysis scripts for new contingency changes.
function handles = update_all_boxes_anlys_gui(handles)
% hObject    handle to contstartstop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
for i = 1:8
    try
        handles = update_box(handles, i); 
    catch e
        if i == 2
            disp(getReport(e))
        end
        disp(['Failed to find contingency info for Box ', num2str(i)]);
    end
end

%helper to be called for each base directory name - updates all current
%contingency information as well as updating statistics information
%including things like pellet count, nosepokes, and trial counts. Also
%issues recommendations as necessary.
function handles = update_box(handles, boxnum)
contents = get(handles.contdayselect, 'String');
NumDaysCompare = str2num(contents{get(handles.contdayselect, 'Value')});
exptdir = get(handles.exptdirlabel, 'String');
basepath = [exptdir, '\Box_', num2str(boxnum),'_*'];
today = floor(now);
dayscompare = [];
for i = 1:60 %how far we're willing to look back for contingency information
            %currently set to 60 days
    daypath = [basepath,'\*\',datestr(today-i, 'mmddyy')];
    day = rdir([daypath,'*']);
    js = rdir([daypath, '\jstruct.mat']);
    if ~isempty(day)  && ~isempty(js) %has been postprocessed
        dayscompare = [dayscompare; day];
    end
    if length(dayscompare) >= NumDaysCompare; break; end;
end
if length(dayscompare)<1
    error(['Not enough days recently to update contigency automatically',...
            '- must be done manually']);
end

%deal with old contigency info (get right boxes);
thresholds = [handles.oldthresh1, handles.oldthresh2, handles.oldthresh3, ...
                handles.oldthresh4, handles.oldthresh5, handles.oldthresh6,...
                handles.oldthresh7, handles.oldthresh8];
holdtimes = [handles.oldht1, handles.oldht2, handles.oldht3, handles.oldht4, ...
                handles.oldht5, handles.oldht6, handles.oldht7, handles.oldht8];
holdthresh = [handles.oldholdthresh1, handles.oldholdthresh2, handles.oldholdthresh3, ...
                handles.oldholdthresh4, handles.oldholdthresh5, ...
                handles.oldholdthresh6, handles.oldholdthresh7, handles.oldholdthresh8];
minangle = [handles.oldminangle1, handles.oldminangle2, handles.oldminangle3, ...
                handles.oldminangle4, handles.oldminangle5, handles.oldminangle6, ...
                handles.oldminangle7, handles.oldminangle8];
maxangle = [handles.oldmaxangle1, handles.oldmaxangle2, handles.oldmaxangle3, ...
                handles.oldmaxangle4, handles.oldmaxangle5, handles.oldmaxangle6, ...
                handles.oldmaxangle7, handles.oldmaxangle8];
pelletcounts = [handles.pelletcount1, handles.pelletcount2, handles.pelletcount3,...
                    handles.pelletcount4, handles.pelletcount5, handles.pelletcount6, ...
                    handles.pelletcount7, handles.pelletcount8];
srates = [handles.successrate1, handles.successrate2, handles.successrate3,...
            handles.successrate4, handles.successrate5, handles.successrate6,...
            handles.successrate7, handles.successrate8];
npokes = [handles.nosepokecount1, handles.nosepokecount2, handles.nosepokecount3, ...
            handles.nosepokecount4, handles.nosepokecount5, handles.nosepokecount6, ...
            handles.nosepokecount7, handles.nosepokecount8];
trialcount = [handles.trialcount1, handles.trialcount2, handles.trialcount3, ...
                handles.trialcount4, handles.trialcount5, handles.trialcount6, ...
                handles.trialcount7, handles.trialcount8];
thresholdsrec = [handles.newthresh1, handles.newthresh2, handles.newthresh3,...
                    handles.newthresh4, handles.newthresh5, handles.newthresh6,...
                    handles.newthresh7, handles.newthresh8];
holdtimesrec = [handles.newht1, handles.newht2, handles.newht3, handles.newht4, ...
                    handles.newht5, handles.newht6, handles.newht7,...
                    handles.newht8];
holdthreshrec = [handles.newholdthresh1, handles.newholdthresh2,...
                    handles.newholdthresh3, handles.newholdthresh4,...
                    handles.newholdthresh5, handles.newholdthresh6,...
                    handles.newholdthresh7, handles.newholdthresh8];
minanglerec = [handles.newminangle1, handles.newminangle2, handles.newminangle3,...
                handles.newminangle4, handles.newminangle5, handles.newminangle6,...
                handles.newminangle7, handles.newminangle8];
maxanglerec = [handles.newmaxangle1, handles.newmaxangle2, handles.newmaxangle3,...
                handles.newmaxangle4, handles.newmaxangle5, handles.newmaxangle6,...
                handles.newmaxangle7, handles.newmaxangle8];
            
stats = load_stats(dayscompare, 1);
sz = length(dayscompare);
set(pelletcounts(boxnum), 'String', num2str(stats.pellet_count/sz));
set(srates(boxnum), 'String', num2str(stats.srate));
set(npokes(boxnum), 'String', num2str(stats.np_count/sz));
set(trialcount(boxnum), 'String', num2str(stats.trialnum/sz));
[thresh, holdtime, centerhold, sector, oldcont] = recommend_contigencies(handles, exptdir, dayscompare, boxnum);

set(thresholds(boxnum), 'String', num2str(oldcont.thresh));
set(holdtimes(boxnum), 'String', num2str(oldcont.holdtime));
set(holdthresh(boxnum), 'String', num2str(oldcont.centerhold));
set(minangle(boxnum), 'String', num2str(oldcont.sector(1)));
set(maxangle(boxnum), 'String', num2str(oldcont.sector(2)));

set(thresholdsrec(boxnum), 'String', num2str(thresh));
set(holdtimesrec(boxnum), 'String', num2str(holdtime));
set(holdthreshrec(boxnum), 'String', num2str(centerhold));
set(minanglerec(boxnum), 'String', num2str(sector(1)));
set(maxanglerec(boxnum), 'String', num2str(sector(2)));