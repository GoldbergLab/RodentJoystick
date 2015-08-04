function [jstructlist, dates, days] = load_jstructs(dirlist, combineflag)
%[jstructlist, dates, days] = load_jstructs(dirlist, combineflag) 
%
%   attempts to load the jstructs from the directories in dirlist.
%
% OUTPUTS:
%
%   jstructlist :: cell array of jstructs - not structs containing
%       filenames like it used to be defined:
%       I.e. jstructlist{2} is an actual jstruct
%
%   dates :: a cell array of strings corresponding to the dates of each
%       jstruct in the format mm/dd/yy
%
%   days :: a vector containing MATLAB real number representation of the
%       day
%
% ARGS:
%   
%   dirlist :: struct representation of a list of directories (usually
%       obtained using the utility rdir). All entries in the list must have
%       been post processed. load_jstructs is not robust - if a single day
%       fails to load, the function will crash.
%   
%   combineflag :: a flag 1/0 that instructs load_jstructs whether or not
%       to combine all data from all directories into a single day
%       If combine flag is 1, then load_jstructs combines all data, and
%       dates becomes a single cell string with the date range in the
%       format 'mm/dd/yy - mm/dd/yy'

if combineflag==0
%% GET LIST of individual data
    jstructlist = cell(length(dirlist), 1);
    dates = cell(length(dirlist), 1);
    days = zeros(length(dirlist), 1);
    for i= 1:length(dirlist)
        jsname = [dirlist(i).name, '\jstruct.mat'];
        load(jsname);
        jstructlist{i} = jstruct;
        try
            dates{i} = datestr(jstruct(2).real_time, 'mm/dd/yy');
            days(i) = floor(jstruct(2).real_time);
        catch
            dates{i} = ''; days(i) = NaN;
        end
        clear jstruct;
    end
else
%% FIND COMBINED DATA    
    combined = [];
    dates = cell(length(dirlist), 1);
    days = zeros(length(dirlist), 1);
    for i= 1:length(dirlist)
        jsname = [dirlist(i).name, '\jstruct.mat'];
        load(jsname);
        combined = [combined, jstruct];
        try
            dates{i} = datestr(jstruct(2).real_time, 'mm/dd/yy');
            days(i) = floor(jstruct(2).real_time);
        catch
            dates{i} = ''; days(i) = NaN;
        end
        clear jstruct;
    end
    jstructlist{1} = combined;
    dates={[dates{1}, ' - ', dates{end}]};
end