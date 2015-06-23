function [jstructlist, dates, days] = load_jstructs(dirlist, combineflag)
%jstructlist is a cell array of jstructs - not structs containing filenames
%jstructlist{2} is an actual jstruct
%dates is a cell array of strings corresponding to the date in the format
%mm/dd/yy - days is the same information, but in the number format
%if combineflag == 1, then dates is the string indicating the time range

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
            dates{i} = ''; days(i) = '';
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
            dates{i} = ''; days(i) = '';
        end
        clear jstruct;
    end
    jstructlist{1} = combined;
    dates={[dates{1}, ' - ', dates{end}]};
end