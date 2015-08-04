function [statslist, dates, days] = load_stats(dirlist, combineflag)
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

if combineflag==0 || length(dirlist) == 1
%% GET LIST of individual data
    dates = cell(length(dirlist), 1);
    days = zeros(length(dirlist), 1);
    for i= 1:length(dirlist)
        jsname = [dirlist(i).name, '\jstruct.mat'];
        statsname = [dirlist(i).name, '\stats.mat'];
        load(jsname); 
        try
            load(statsname);
        catch
            stats = xy_getstats(jstruct);
        end
        statslist(i) = stats;
        try
            dates{i} = datestr(jstruct(2).real_time, 'mm/dd/yy');
            days(i) = floor(jstruct(2).real_time);
        catch
            dates{i} = ''; days(i) = '';
        end
        clear jstruct; clear stats;
    end
else
%% FIND COMBINED DATA    
    dates = cell(length(dirlist), 1);
    days = zeros(length(dirlist), 1);
    np_count = 0; js_r_count = 0; js_l_count = 0; pellet_count = 0;
    np_js = []; np_js_post = []; traj_pdf_jstrial = zeros(100, 100);
    numtraj = 0; traj_struct = []; trialnum = 0;
    for i= 1:length(dirlist)
        jsname = [dirlist(i).name, '\jstruct.mat'];
        statsname = [dirlist(i).name, '\stats.mat'];
        load(jsname); 
        try
            load(statsname);
        catch
            stats = xy_getstats(jstruct);
        end
        np_count = stats.np_count + np_count;
        js_r_count = stats.js_r_count + js_r_count;
        js_l_count = stats.js_l_count + js_l_count;
        pellet_count = stats.pellet_count + pellet_count;
        np_js = [stats.np_js; np_js];
        np_js_post = [stats.np_js_post; np_js_post];
        traj_struct = [stats.traj_struct, traj_struct];
        traj_pdf_jstrial = stats.traj_pdf_jstrial + traj_pdf_jstrial;
        numtraj = stats.numtraj + numtraj;
        trialnum = stats.trialnum + trialnum;
        try
            dates{i} = datestr(jstruct(2).real_time, 'mm/dd/yy');
            days(i) = floor(jstruct(2).real_time);
        catch
            dates{i} = ''; days(i) = '';
        end
        clear jstruct; clear stats;
    end
    statslist(1).np_count = np_count;
    statslist(1).js_r_count = js_r_count;
    statslist(1).js_l_count = js_l_count;
    statslist(1).pellet_count = pellet_count;
    statslist(1).np_js = np_js;
    statslist(1).np_js_post = np_js_post;
    statslist(1).traj_pdf_jstrial = (traj_pdf_jstrial)./(sum(sum(traj_pdf_jstrial)));
    statslist(1).numtraj = numtraj;
    statslist(1).traj_struct = traj_struct;
    statslist(1).trialnum = trialnum;
    statslist(1).srate = pellet_count/trialnum;
    dates={[dates{1}, ' - ', dates{end}]};
end