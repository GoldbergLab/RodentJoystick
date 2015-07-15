%This function writes out all the contingency information from the
%automation analysis gui wherever possible (i.e. if a box has information
%available). If it cannot do so for a box, it will display a failed
%indicator, but it will not crash and prevent the other boxes from writing
%out. Also returns a list of failures and attachments to send. 
function [handles, failures, attachments] = write_out_all_contingencies_anlys_gui(handles, manual)
failures = {};
attachments = {};
failstr = 'Failed to write out contingency information for Box ';
for i = 1:8
    try
        contingencies = write_out_contingency(i, manual, handles);
        attachments = {attachments; contingencies};
    catch
        tmp = [failstr, num2str(i)];
        failures = [failures; tmp];
        disp([failstr, num2str(i)]);
    end
end

end
%write out contingency of (boxnum)
%involves moving oldfile to new archived directory
function contingencyfiles = write_out_contingency(boxnum, manual, handles)
%make cell array:
contingencyfiles = {};
exptdir = get(handles.exptdirlabel, 'String');
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
try
    thresh = str2num(get(thresholdsrec(boxnum), 'String'));
    thresh = max(min(thresh, 100), 0);
    ht = str2num(get(holdtimesrec(boxnum), 'String'));
    ht = max(ht, 0);
    holdthresh = str2num(get(holdthreshrec(boxnum), 'String'));
    holdthresh = max(min(holdthresh, 100), 0);
    minangle = str2num(get(minanglerec(boxnum), 'String'));
    minangle = max(min(minangle, 180), -180);
    maxangle = str2num(get(maxanglerec(boxnum), 'String'));
    maxangle = max(min(maxangle, 180), -180);

    towrite = ...
    {'Box Num', boxnum; ...
     'Out Threshold', thresh; ...
     'Hold Duration', ht; ...
     'Hold Threshold', holdthresh;...
     'Min Angle', minangle;...
     'Max Angle', maxangle};
catch
    if manual
        msgbox(['Failed to write out the contingencies specified for', ...
        'Box ', num2str(boxnum), '. Check that the spaces are not empty and', ...
        'valid numbers']);
    end
end

oldcontingency = [exptdir,'\Box_', num2str(boxnum),'\contingency*.txt'];
tmplist = rdir(oldcontingency); oldcontingency = tmplist.name;
archivefoldername = [exptdir, '\Box_', num2str(boxnum),'\ArchivedContingencies\'];
if exist(archivefoldername, 'dir')~=7
    mkdir(archivefoldername);
end
archivename = [archivefoldername, 'contingency_',...
                    datestr(now, 'mm_dd_yyyy_HH_MM'),'.txt'];
contingencyfiles = {archivename};
fid = fopen(oldcontingency);
info = textscan(fid,'%s %s %f',6);
towritearchive = ...
    {'Box Num', boxnum; ...
     'Out Threshold', info{3}(2); ...
     'Hold Duration', info{3}(3); ...
     'Hold Threshold', info{3}(4);...
     'Min Angle', info{3}(5);...
     'Max Angle', info{3}(6)};
    
%THIS IS SPECIFIC TO THE CURRENT CONTINGENCY FORMAT - writing old one, then
%new one:
newcontname = [exptdir, '\Box_', num2str(boxnum),'\contingency.txt'];
contingencyfiles = {contingencyfiles; newcontname};
fid = fopen(newcontname,'w');
fidarchive = fopen(archivename, 'w');
for i = 1:6
    fprintf(fid, '%s %f\r\n', towrite{i, :});
    fprintf(fidarchive, '%s %f\r\n', towritearchive{i, :});
    try
        disp(towrite{i, :});
        disp(towritearchive{i, :});
    end
end
fclose(fid); 
fclose(fidarchive);
end