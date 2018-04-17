function [statslist, dates, days, errlist] = load_stats(dirlist,varargin)
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
%       load_stats either groups data by days* (2), combines all data into a
%       single struct (1), or leaves as separate structs as loaded (0)
%
%       *Note that currently, grouping by days only works as long as there
%       are not more than 2 contingencies in a single day, otherwise it
%       will miss some days.
%
%       When combining all (1):
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
errlist = cell(length(dirlist), 1);
 
default = {0, 1, 12,[]};
numvarargs = length(varargin);
[default{1:numvarargs}] = varargin{:};

[combineflag,to_stop,hrin,varargin] = default{:};

if to_stop
    statstr = strcat('\stats_ts_',num2str(hrin),'.mat');
else
    statstr = strcat('\stats_',num2str(hrin),'.mat');
end
if combineflag==0 || length(dirlist) == 1
    %% GET LIST of individual data
    days = zeros(length(dirlist), 1);
    
    for k = 1:length(dirlist)
        [statslist(k), days(k), errlist{k}] = load_fields([dirlist(k).name, statstr], varargin);
    end
elseif combineflag == 1 % combine all days' stats
    [statslist, days, errlist] = combine_stats_struct(dirlist, [], statstr);
else %combine all alike days
    slistind = 1; days = [];
    for k = 1:length(dirlist)
        day = strsplit(dirlist(k).name, '\'); day = day{end};
        
        if (exist('prev_day', 'var')) &&  (strcmp(day, prev_day))
            slistind = slistind-1;
            %currently assumes only max of two contingencies per day - this
            %may need to be changed in the future
            [statslist(slistind),tmpdays, errlist{k-1:k}] = combine_stats_struct(dirlist(k-1:k), [], statstr);
        else
            [statslist(slistind),tmpdays, errlist{k}] = load_fields([dirlist(k).name, statstr], varargin);
        end
        %store results
        days(slistind) = tmpdays(1);
        
        %update for next iteration
        slistind = slistind+1; prev_day = day;
    end
end
dates = cellfun(@(d) datestr(d, 'mm/dd/yy'), num2cell(days), 'UniformOutput', 0);
if combineflag == 1
    dates = {[dates{1},'-',dates{end}]};
end

end

%combines all stats in dirlist into a single stats struct
function [statslist, days, errlist] = combine_stats_struct(dirlist, fieldlist, statstr)
%% FIND COMBINED DATA
errlist = cell(length(dirlist), 1);
days = zeros(length(dirlist), 1);
for k= 1:length(dirlist)
    statsname = [dirlist(k).name, statstr];
    [stats, days(k), e] = load_fields(statsname, fieldlist);
    errlist{k} = e;
    if exist('statsaccum', 'var')
        try statsaccum.np_count = stats.np_count + statsaccum.np_count; end;
        try statsaccum.js_r_count = stats.js_r_count + statsaccum.js_r_count; end;
        try statsaccum.js_l_count = stats.js_l_count + statsaccum.js_l_count; end;
        try statsaccum.pellet_count = stats.pellet_count + statsaccum.pellet_count; end;
        try statsaccum.np_js = [statsaccum.np_js; stats.np_js]; end;
        try statsaccum.np_js_post = [stats.np_js_post; statsaccum.np_js_post]; end;
        try statsaccum.np_js_nc_nl = [statsaccum.np_js_nc_nl;stats.np_js_nc_nl]; end;
        try statsaccum.np_js_nc = [statsaccum.np_js_nc;stats.np_js_nc]; end;
        try statsaccum.np_js_masked_l = [statsaccum.np_js_masked_l;stats.np_js_masked_l]; end;
        try statsaccum.np_js_masked_nl = [statsaccum.np_js_masked_nl;stats.np_js_masked_nl]; end;
        try statsaccum.traj_struct = [statsaccum.traj_struct, stats.traj_struct]; end;
        try statsaccum.traj_pdf_jstrial = stats.traj_pdf_jstrial + ...
                statsaccum.traj_pdf_jstrial; end;
        try statsaccum.numtraj = stats.numtraj + statsaccum.numtraj; end;
        try statsaccum.trialnum = stats.trialnum + statsaccum.trialnum; end;
        try statsaccum.srate(end+1) = stats.srate; end; %+ statsaccum.pellet_count/statsaccum.trialnum; end;
    else
        try statsaccum.np_count = stats.np_count; end;
        try statsaccum.js_r_count = stats.js_r_count; end;
        try statsaccum.js_l_count = stats.js_l_count; end;
        try statsaccum.pellet_count = stats.pellet_count; end;
        try statsaccum.np_js = stats.np_js; end;
        try statsaccum.np_js_post = stats.np_js_post; end;
        try statsaccum.np_js_nc_nl = stats.np_js_nc_nl; end;
        try statsaccum.np_js_nc = stats.np_js_nc; end;
        try statsaccum.np_js_masked_l = stats.np_js_masked_l; end;
        try statsaccum.np_js_masked_nl = stats.np_js_masked_nl; end;
        try statsaccum.traj_struct = stats.traj_struct; end;
        try statsaccum.traj_pdf_jstrial = stats.traj_pdf_jstrial; end;
        try statsaccum.numtraj = stats.numtraj; end;
        try statsaccum.trialnum = stats.trialnum; end;
        try statsaccum.srate = stats.srate; end;
    end
    clear stats;
end
statslist = statsaccum;
end

function [stats, day, e] = load_fields(fname, fieldlist)
stats = struct();
e = [];
try
    if isempty(fieldlist)
        stats = add_field(stats, fname, '');
    else
        for k = 1:length(fieldlist)
            stats = add_field(stats, fname, fieldlist{k});
        end
    end
    load(fname, 'day');
catch e
    day = 0;
end

end

function [stats] = add_field(stats, fname, fieldname)
allfields = isempty(fieldname);
srateneeded = strcmp(fieldname, 'srate');
try
    if allfields || (strcmp(fieldname, 'np_count'))
        load(fname, 'np_count');
        stats.np_count = np_count;
    end
catch e
    display(e.message);
end
try
    if allfields || strcmp(fieldname, 'js_r_count')
        load(fname, 'js_r_count');
        stats.js_r_count = js_r_count;
    end
catch e
    display(e.message);
end
try
    if allfields || strcmp(fieldname, 'js_l_count')
        load(fname, 'js_l_count');
        stats.js_l_count = js_l_count;
    end
catch e
    display(e.message);
end
try
    if allfields || strcmp(fieldname, 'pellet_count') || srateneeded
        load(fname, 'pellet_count');
        stats.pellet_count = pellet_count;
    end
catch e
    display(e.message);
end
try
    if allfields || strcmp(fieldname, 'np_js')
        load(fname, 'np_js');
        stats.np_js = np_js;
    end
catch e
    display(e.message);
end
try
    if allfields || strcmp(fieldname, 'np_js_nc')
        load(fname, 'np_js_nc');
        stats.np_js_nc = np_js_nc;
    end
catch e
    display(e.message);
end
try
    if allfields || strcmp(fieldname, 'np_js_post')
        load(fname, 'np_js_post');
        stats.np_js_post = np_js_post;
    end
catch e
    display(e.message);
end
try
    if allfields || strcmp(fieldname, 'np_js_nc_nl')
        load(fname, 'np_js_nc_nl');
        stats.np_js_nc_nl = np_js_nc_nl;
    end
catch e
    display(e.message);
end
try
    if allfields || strcmp(fieldname, 'np_js_masked_nl')
        load(fname, 'np_js_masked_nl');
        stats.np_js_masked_nl = np_js_masked_nl;
    end
catch e
    display(e.message);
end
try
    if allfields || strcmp(fieldname, 'np_js_masked_l')
        load(fname, 'np_js_masked_l');
        stats.np_js_masked_l = np_js_masked_l;
    end
catch e
    display(e.message);
end
try
    if allfields || strcmp(fieldname, 'traj_pdf_jstrial')
        load(fname, 'traj_pdf_jstrial');
        stats.traj_pdf_jstrial = traj_pdf_jstrial;
    end
catch e
    display(e.message);
end
try
    if allfields || strcmp(fieldname, 'numtraj')
        load(fname, 'numtraj');
        stats.numtraj = numtraj;
    end
catch e
    display(e.message);
end
try
    if allfields || strcmp(fieldname, 'traj_struct')
        load(fname, 'traj_struct');
        stats.traj_struct = traj_struct;
    end
catch e
    display(e.message);
end
try
    if allfields || strcmp(fieldname, 'trialnum') || srateneeded
        load(fname, 'trialnum');
        stats.trialnum = trialnum;
    end
catch e
    display(e.message);
end
try
    if  allfields ||strcmp(fieldname, 'srate')
        load(fname, 'srate');
        stats.srate = srate;
    end
catch e
    display(e.message);
end



end