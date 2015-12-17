function [newloc] = combine_contingencies(dir)
% [newloc] = combine_contingencies(dir)
%
%   takes a directory of raw, unprocessed data, and
%   moves it to the correct folder based on contingency information.
%   Recall that raw data is written in the format 
%       expt_dir\Box_<i>_<mouse id>\<date>_<contingency>\*.dat
%   Processed data, however, is stored in the following manner:
%       expt_dir\Box_<i>_<mouse id>\<date>_<contingency>\<date>\*.dat
%   combine_contingencies executes this step, moving data from one folder
%   to another. For specifics, see the wiki on the overall file
%   managment/organization system.
%
% OUTPUTS:
%
%       newloc :: a string with the new location of the moved data
%
% ARGUMENTS: 
%
%       dir :: a string representation of the directory with raw data


entries = strsplit(dir, '\');
datecontingency = entries{end};
basepath = strjoin(entries(1:end-1), '\');
datecontingency = strsplit(datecontingency, '_');
contingency = strjoin(datecontingency(2:end), '_');
date = datecontingency{1};
m = date(1:2); d = date(3:4); y = date(5:6);
dirday = datenum(str2num(y)+2000, str2num(m), str2num(d));

if dirday == floor(now); 
    disp('Attempted combining contingencies on data that is still being collected');
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

combexist = 0;
try
    if exist([dir, '\comb'], 'file')==7; combexist = 1; end;
    if existingdir
        newloc = [match, '\', date];
        movefile(dir, newloc, 'f');
    else
        mkdir(dir,date);
        newloc = [dir, '\', date];
        movefile([dir,'\*'], [newloc,'\'], 'f');
    end
catch
    %disp(getReport(e));
    if combexist
        try
            movefile([dir, '\comb'], newloc);
        catch e
            disp(getReport(e));
        end
    end
    %for some reason, MATLAB will move the files successfully, but throw an
    %error regardless - for that reason the catch block is here instead of
    %passing the error to doAllpp
end

