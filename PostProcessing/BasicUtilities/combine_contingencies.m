function [success, newloc] = combine_contingencies(dir)

% assumption here that dir is in format:
% expt_dir\Box_<i>_<mouse id>\<date>_<contingency>

entries = strsplit(dir, '\');
datecontingency = entries{end};
basepath = strjoin(entries(1:end-1), '\');
disp(basepath);

datecontingency = strsplit(datecontingency, '_');
contingency = strjoin(datecontingency(2:end), '_');
disp(contingency)
date = datecontingency{1};
disp(date);
m = date(1:2); d = date(3:4); y = date(5:6);
dirday = datenum(str2num(y)+2000, str2num(m), str2num(d));
disp(datestr(dirday));

if dirday == floor(now); 
    success = 0; 
    error('Combining contigencies attempted on todays data.');
end

%Find earliest day before directory entry
for i = 1:200
    lookupday = dirday - i;
    %return the first directory entries we find of the first day prior to
    %dir. List allows the possibility of multiple directories (same day
    %contingency changes)
    list = rdir([basepath, '\', datestr(lookupday, 'mmddyy'), '_*']);
    if ~isempty(list); break; end;
end
%iterate through all day matches and see if contingency code matches
existingdir = 0; 
for i = 1:length(list)
    candidate = strsplit(list(i).name, '\');
    candidate_contingency = strsplit(candidate{end}, '_');
    candidate_contingency = strjoin(candidate_contingency(2:end), '_');
    if strcmp(contingency, candidate_contingency)
        existingdir = 1; match = list(i).name;
        break;
    end
end

if existingdir 
    disp(match);
end

try
if existingdir
    movefile(dir, [match, '\', date], 'f');
    newloc = [match, '\', date];
else
    mkdir(dir,date);
    movefile([dir,'\*'], [dir, '\', date, '\'], 'f');
    newloc = [dir, '\', date];
end
catch e
    success = 0;
    disp(getReport(e));
    error('Failed to move files');
end