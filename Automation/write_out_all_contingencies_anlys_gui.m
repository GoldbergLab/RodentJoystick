%This function writes out all the contingency information from the
%automation analysis gui wherever possible (i.e. if a box has information
%available). If it cannot do so for a box, it will display a failed
%indicator, but it will not crash and prevent the other boxes from writing
%out. Also returns a list of failures and attachments to send. 
function [handles, failures, attachments] = write_out_all_contingencies_anlys_gui(handles, manual)
failures = {};
attachments = {};
failstr = 'Failed to write out contingency information for Box ';
try
    write_out_contingency(1, manual, handles)
catch
    failures = [failures; [failstr, '1']];
    disp([failstr, '1']);
end
try
    write_out_contingency(2, manual, handles)
catch e
    failures = [failures; [failstr, '2']];
    disp([failstr, '2']);
    disp(getReport(e));
end
try
    write_out_contingency(3, manual, handles)
catch
    failures = [failures; [failstr, '3']];
    disp([failstr, '3']);
end
try
    write_out_contingency(4, manual, handles)
catch
    failures = [failures; [failstr, '4']];
    disp([failstr, '4']);
end
try
    write_out_contingency(5, manual, handles)
catch
    failures = [failures; [failstr, '5']];
    disp([failstr, '5']);
end
try
    write_out_contingency(6, manual, handles)
catch
    failures = [failures; [failstr, '6']];
    disp([failstr, '6']);
end
try
    write_out_contingency(7, manual, handles)
catch
    failures = [failures; [failstr, '7']];
    disp([failstr, '7']);
end
try
    write_out_contingency(8, manual, handles)
catch
    failures = [failures; [failstr, '8']];
    disp([failstr, '8']);
end

%write out contingency of (boxnum)
%involves moving oldfile to new archived directory
function write_out_contingency(boxnum, manual, handles)
%make cell array:
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
    {'Out Threshold', thresh; ...
     'Hold Duration', ht; ...
     'Hold Threshold', holdthresh;...
     'Min Angle', minangle;...
     'Max Angle', maxangle};
disp([thresh, ht, holdthresh, minangle, maxangle]);
catch
    if manual
        msgbox(['Failed to write out the contingencies specified for', ...
        'Box ', num2str(boxnum), '. Check that the spaces are not empty and', ...
        'valid numbers']);
    end
end

oldcontingency = [exptdir,'\Box_', num2str(boxnum),'\contingency*.txt'];
tmplist = rdir(oldcontingency); oldcontingency = tmplist.name;
archivename = [exptdir, '\Box_', num2str(boxnum),'\ArchivedContingencies\',...
            'contingency_',datestr(now, 'mm_dd_yyyy_HH_MM'),'.txt'];

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
fid = fopen(newcontname,'w');
fidarchive = fopen(archivename, 'w');
for i = 1:6
    fprintf(fid, '%s %f\r\n', towrite{i, :});
    fprintf(fidarchive, '%s %f\r\n', towritearchive{i, :});
end
fclose(fid); 
fclose(fidarchive);