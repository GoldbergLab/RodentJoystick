function [statslist, dates, days] = load_stats(dirlist, combineflag, varargin)
%[statslist, dates, days] = load_stats(dirlist, combineflag) attempts
%   to load the stats structures from the directories in dirlist.
%
% OUTPUTS:
%
%   statslist :: struct array of stats structures - not structs containing
%       filenames like used to be defined:
%       I.e. statslist(2) is an actual stat structure
%
%   dates :: a cell array of strings corresponding to the dates of each
%       stats struct in the format mm/dd/yy
%
%   days :: a vector containing MATLAB real number representation of the
%       day
%
% ARGS:
%   
%   dirlist :: struct representation of a list of directories (usually
%       obtained using the utility rdir). All entries in the list must have
%       been post processed. load_stats is not robust - if a single day
%       fails to load, the function will crash.
%   
%   combineflag :: a flag 2/1/0 that instructs load_stats how to combine
%       data
%       If combine flag is 1, then load_stats combines all data into a
%       single struct.
%       dates becomes a single cell string with the date range in the
%       format 'mm/dd/yy - mm/dd/yy'
%
% OPTIONAL ARGS:
%   
%   fields :: if no fields are provided, load_stats will load all fields of
%       the stats structure. Otherwise it will load only the fields
%       provided. Can select from:
%       'np_count', 'js_r_count', 'js_l_count', 'pellet_count', 'np_js',
%       'np_js_post', 'traj_pdf_jstrial', 'numtraj', 'traj_struct',
%       'trialnum', 'srate'
%

if combineflag==0 || length(dirlist) == 1
%% GET LIST of individual data
    dates = cell(length(dirlist), 1);
    days = zeros(length(dirlist), 1);
    for k= 1:length(dirlist)
        statsname = [dirlist(k).name, '\stats.mat'];
        try
            [stats, dates{k}, days(k)] = load_fields(statsname, varargin);
        catch e
            disp(getReport(e));
            %stats = xy_getstats(jstruct);
        end
        statslist(k) = stats;
        clear stats;
    end
elseif combineflag == 1 % combine all days' stats
    [statslist, dates, days] = combine_stats_struct(dirlist, 1, varargin);
else %combine all alike days
    statslistind = 1; dates = {}; days = [];
    for k = 1:length(dirlist)
        day = strsplit(dirlist(k).name, '\'); day = day{end};
        test = (exist('prev_day', 'var'));
        if (exist('prev_day', 'var')) &&  (strcmp(day, prev_day))
            statslistind = statslistind-1;
            [stats, tmpdates, tmpdays] = combine_stats_struct(dirlist(k-1:k), 0, varargin);
            statslist(statslistind) = stats;
            dates{statslistind} = tmpdates{1};
            days(statslistind) = tmpdays(1);
            statslistind = statslistind+1;
        else
            statsname = [dirlist(k).name, '\stats.mat'];
            try
                [statslist(statslistind), dates{statslistind}, days(statslistind)] = load_fields(statsname, varargin);
            catch e 
                disp(getReport(e));
            end
            statslistind = statslistind+1;
            prev_day = day;
        end
    end
    
end
end

%combines all stats in dirlist into a single stats struct
function [statslist, dates, days] = combine_stats_struct(dirlist, combinedate, fieldlist)
%% FIND COMBINED DATA    
    dates = cell(length(dirlist), 1);
    days = zeros(length(dirlist), 1);
    for k= 1:length(dirlist)
        statsname = [dirlist(k).name, '\stats.mat'];
        try
            [stats, dates{k}, days(k)] = load_fields(statsname, fieldlist);
        catch e 
            disp(getReport(e))
            %jsname = [dirlist(k).name, '\jstruct.mat'];
            %load(jsname); 
            %stats = xy_getstats(jstruct);
        end
        if exist('statsaccum', 'var')
            try; statsaccum.np_count = stats.np_count + statsaccum.np_count; end;
            try; statsaccum.js_r_count = stats.js_r_count + statsaccum.js_r_count; end;
            try; statsaccum.js_l_count = stats.js_l_count + statsaccum.js_l_count; end;
            try; statsaccum.pellet_count = stats.pellet_count + statsaccum.pellet_count; end;
            try; statsaccum.np_js = [statsaccum.np_js; stats.np_js]; end;
            try; statsaccum.np_js_post = [stats.np_js_post; statsaccum.np_js_post]; end;
            try; statsaccum.traj_struct = [statsaccum.traj_struct, stats.traj_struct]; end;
            try; statsaccum.traj_pdf_jstrial = stats.traj_pdf_jstrial + ...
                    statsaccum.traj_pdf_jstrial; end;
            try; statsaccum.numtraj = stats.numtraj + statsaccum.numtraj; end;
            try; statsaccum.trialnum = stats.trialnum + statsaccum.trialnum; end;
            try; statsaccum.srate = statsaccum.pellet_count/statsaccum.trialnum; end;
        else
            try; statsaccum.np_count = stats.np_count; end;
            try; statsaccum.js_r_count = stats.js_r_count; end;
            try; statsaccum.js_l_count = stats.js_l_count; end;
            try; statsaccum.pellet_count = stats.pellet_count; end;
            try; statsaccum.np_js = stats.np_js; end;
            try; statsaccum.np_js_post = stats.np_js_post; end;
            try; statsaccum.traj_struct = stats.traj_struct; end;
            try; statsaccum.traj_pdf_jstrial = stats.traj_pdf_jstrial; end;
            try; statsaccum.numtraj = stats.numtraj; end;
            try; statsaccum.trialnum = stats.trialnum; end;
        end
        clear stats;
    end
    statslist = statsaccum;
    if combinedate
        dates={[dates{1}, ' - ', dates{end}]};
    end
end

function [stats, date, day] = load_fields(fname, fieldlist)
    stats = struct();
    for k = 1:length(fieldlist)
        stats = add_field(stats, fname, fieldlist{k});
    end
    if isempty(fieldlist)
        stats = add_field(stats, fname, '');
    end
    try
        load(fname, 'day');
        date = datestr(day, 'mm/dd/yy');
    catch e 
        disp(getReport(e));
        day = 0; date = '';
    end
end

function [stats] = add_field(stats, fname, fieldname)
    allfields = isempty(fieldname);
    srateneeded = strcmp(fieldname, 'srate');
    if allfields || (strcmp(fieldname, 'np_count'))
        load(fname, 'np_count');
        stats.np_count = np_count;
    end
    if allfields || strcmp(fieldname, 'js_r_count')
        load(fname, 'js_r_count');
        stats.js_r_count = js_r_count;
    end
    if allfields || strcmp(fieldname, 'js_l_count')
        load(fname, 'js_l_count');
        stats.js_l_count = js_l_count;
    end
    if allfields || strcmp(fieldname, 'pellet_count') || srateneeded
        load(fname, 'pellet_count');
        stats.pellet_count = pellet_count;
    end
    if allfields || strcmp(fieldname, 'np_js') 
        load(fname, 'np_js');
        stats.np_js = np_js;
    end
    if allfields || strcmp(fieldname, 'np_js_post') 
        load(fname, 'np_js_post'); 
        stats.np_js_post = np_js_post; 
    end
    if allfields || strcmp(fieldname, 'traj_pdf_jstrial') 
        load(fname, 'traj_pdf_jstrial');
        stats.traj_pdf_jstrial = traj_pdf_jstrial;
    end
    if allfields || strcmp(fieldname, 'numtraj') 
        load(fname, 'numtraj');
        stats.numtraj = numtraj;
    end
    if allfields || strcmp(fieldname, 'traj_struct')
        load(fname, 'traj_struct');
        stats.traj_struct = traj_struct;
    end
    if allfields || strcmp(fieldname, 'trialnum') || srateneeded
        load(fname, 'trialnum');
        stats.trialnum = trialnum;
    end
    if  allfields ||strcmp(fieldname, 'srate')
        load(fname, 'srate');
        stats.srate = srate;        
    end
end