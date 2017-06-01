% updates all information for all boxes in the GUI, including basic
% statistics and current contingency information.
% update_all_boxes_anlys_gui(handles) also puts recommendations based on
%   post processing analysis scripts for new contingency changes.
function handles = update_all_boxes_anlys_gui(handles)
% hObject    handle to contstartstop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.calculatingindicator, 'BackgroundColor', [0.6, 1.0, 1.0]);
pause(0.2);
for i = 1:4
    try
        handles = update_box(handles, i); 
    catch e
        disp(['Failed to find contingency info for Box ', num2str(i), e.message]);
    end
end
set(handles.calculatingindicator, 'BackgroundColor', [0, 0, 0.4]);


%helper to be called for each base directory name - updates all current
%contingency information as well as updating statistics information
%including things like pellet count, nosepokes, and trial counts. Also
%issues recommendations as necessary.
function handles = update_box(handles, boxnum)
contents = get(handles.contdayselect, 'String');
NumDaysCompare = str2num(contents{get(handles.contdayselect, 'Value')});
exptdir = get(handles.exptdirlabel, 'String');
basepath = [exptdir, '\data\Box_', num2str(boxnum),'*'];
today = floor(now);
dayscompare = []; duplicates = 0;
for i = 1:60 %how far we're willing to look back for contingency information
    daypath = [basepath,'\*\',datestr(today-i, 'mmddyy')];
    day = rdir([daypath,'*']);
    duplicates = duplicates + length(day)- ~(~length(day));
    js = rdir([daypath, '\jstruct.mat']);
    if ~isempty(day)  && ~isempty(js)
        dayscompare = [dayscompare; day];
    end
    if length(dayscompare)-duplicates>= NumDaysCompare; break; end;
end
if length(dayscompare)<1
    error(['Not enough days recently to update contigency automatically',...
            '- must be done manually']);
end

%deal with old contigency info (get right boxes);
thresholds = [handles.oldthresh1, handles.oldthresh2, handles.oldthresh3, ...
                handles.oldthresh4];
holdtimes = [handles.oldht1, handles.oldht2, handles.oldht3, handles.oldht4];
holdthresh = [handles.oldholdthresh1, handles.oldholdthresh2, handles.oldholdthresh3, ...
                handles.oldholdthresh4];
minangle_l = [handles.oldminangle1_l, handles.oldminangle2_l, handles.oldminangle3_l, ...
                handles.oldminangle4_l];
maxangle_l = [handles.oldmaxangle1_l, handles.oldmaxangle2_l, handles.oldmaxangle3_l, ...
                handles.oldmaxangle4_l];
minangle = [handles.oldminangle1, handles.oldminangle2, handles.oldminangle3, ...
                handles.oldminangle4];
maxangle = [handles.oldmaxangle1, handles.oldmaxangle2, handles.oldmaxangle3, ...
                handles.oldmaxangle4];           
pelletcounts = [handles.pelletcount1, handles.pelletcount2, handles.pelletcount3,...
                    handles.pelletcount4];
srates = [handles.successrate1, handles.successrate2, handles.successrate3,...
            handles.successrate4];
npokes = [handles.nosepokecount1, handles.nosepokecount2, handles.nosepokecount3, ...
            handles.nosepokecount4];
trialcount = [handles.trialcount1, handles.trialcount2, handles.trialcount3, ...
                handles.trialcount4];
thresholdsrec = [handles.newthresh1, handles.newthresh2, handles.newthresh3,...
                    handles.newthresh4];
holdtimesrec = [handles.newht1, handles.newht2, handles.newht3, ...
                    handles.newht4];
holdthreshrec = [handles.newholdthresh1, handles.newholdthresh2,...
                    handles.newholdthresh3, handles.newholdthresh4];
minanglerec_l = [handles.newminangle1_l, handles.newminangle2_l, handles.newminangle3_l,...
                handles.newminangle4_l];
maxanglerec_l = [handles.newmaxangle1_l, handles.newmaxangle2_l, handles.newmaxangle3_l,...
                handles.newmaxangle4_l];                
minanglerec = [handles.newminangle1, handles.newminangle2, handles.newminangle3,...
                handles.newminangle4];
maxanglerec = [handles.newmaxangle1, handles.newmaxangle2, handles.newmaxangle3,...
                handles.newmaxangle4];
            
stats = load_stats(dayscompare, 1, 0, 0, 'pellet_count', 'srate', 'np_count', 'trialnum');
sz = length(dayscompare)-duplicates;
try
set(pelletcounts(boxnum), 'String', num2str(stats.pellet_count/sz));
set(srates(boxnum), 'String', num2str(stats.srate(end).total));
set(npokes(boxnum), 'String', num2str(stats.np_count/sz));
set(trialcount(boxnum), 'String', num2str(stats.trialnum/sz));
catch
end
[thresh, holdtime, centerhold, sector, oldcont] = recommend_contigencies(handles, exptdir, dayscompare, duplicates);

set(thresholds(boxnum), 'String', num2str(oldcont.thresh));
set(holdtimes(boxnum), 'String', num2str(oldcont.holdtime));
set(holdthresh(boxnum), 'String', num2str(oldcont.centerhold));
set(minangle(boxnum), 'String', num2str(oldcont.sector(1)));
set(maxangle(boxnum), 'String', num2str(oldcont.sector(2)));
set(minangle_l(boxnum), 'String', num2str(oldcont.sector(3)));
set(maxangle_l(boxnum), 'String', num2str(oldcont.sector(4)));

set(thresholdsrec(boxnum), 'String', num2str(thresh));
set(holdtimesrec(boxnum), 'String', num2str(holdtime));
set(holdthreshrec(boxnum), 'String', num2str(centerhold));
set(minanglerec(boxnum), 'String', num2str(sector(1)));
set(maxanglerec(boxnum), 'String', num2str(sector(2)));
set(minanglerec_l(boxnum), 'String', num2str(sector(3)));
set(maxanglerec_l(boxnum), 'String', num2str(sector(4)));