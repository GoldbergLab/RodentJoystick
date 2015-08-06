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
%   combineflag :: a flag 1/0 that instructs load_stats whether or not
%       to combine all data from all directories into a single day
%       If combine flag is 1, then load_stats combines all data, and
%       dates becomes a single cell string with the date range in the
%       format 'mm/dd/yy - mm/dd/yy'
%
% OPTIONAL ARGS:
%
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
        clear jstruct; clear stats;
    end
else
%% FIND COMBINED DATA    
    dates = cell(length(dirlist), 1);
    days = zeros(length(dirlist), 1);
    np_count = 0; js_r_count = 0; js_l_count = 0; pellet_count = 0;
    np_js = []; np_js_post = []; traj_pdf_jstrial = zeros(100, 100);
    numtraj = 0; traj_struct = []; trialnum = 0;
    for k= 1:length(dirlist)
        statsname = [dirlist(k).name, '\stats.mat'];
        try
            [stats, dates{k}, days(k)] = load_fields(statsname, varargin);
        catch e 
            disp(getReport(e))
            %jsname = [dirlist(k).name, '\jstruct.mat'];
            %load(jsname); 
            %stats = xy_getstats(jstruct);
        end
        try; np_count = stats.np_count + np_count; end;
        try; js_r_count = stats.js_r_count + js_r_count; end;
        try; js_l_count = stats.js_l_count + js_l_count; end;
        try; pellet_count = stats.pellet_count + pellet_count; end;
        try; np_js = [stats.np_js; np_js]; end;
        try; np_js_post = [stats.np_js_post; np_js_post]; end;
        try; traj_struct = [stats.traj_struct, traj_struct]; end;
        try; traj_pdf_jstrial = stats.traj_pdf_jstrial + traj_pdf_jstrial; end;
        try; numtraj = stats.numtraj + numtraj; end;
        try; trialnum = stats.trialnum + trialnum; end;
        clear stats;
    end
    try; statslist(1).np_count = np_count; end;
    try; statslist(1).js_r_count = js_r_count; end;
    try; statslist(1).js_l_count = js_l_count; end;
    try; statslist(1).pellet_count = pellet_count; end;
    try; statslist(1).np_js = np_js; end;
    try; statslist(1).np_js_post = np_js_post; end;
    try; statslist(1).traj_pdf_jstrial = (traj_pdf_jstrial)./(sum(sum(traj_pdf_jstrial))); end;
    try; statslist(1).numtraj = numtraj; end;
    try; statslist(1).traj_struct = traj_struct; end;
    try; statslist(1).trialnum = trialnum; end;
    try; statslist(1).srate = pellet_count/trialnum; end;
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
    if allfields || strcmp(fieldname, 'pellet_count') 
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
    if allfields || strcmp(fieldname, 'trialnum')
        load(fname, 'trialnum');
        stats.trialnum = trialnum;
    end
    if  allfields ||strcmp(fieldname, 'srate')
        load(fname, 'srate');
        stats.srate = srate;        
    end
end