% [failedflag, err] = doAllpp(working_dir, [statflag, combinecont])
%
%   does all standard post processing analysis, based on the combination
%   of flags:
%   always: combines .dat files, generates jstruct
%   if statflag: calls doAllstats
%   if combinecont: combines contingency folder if possible
% 
% OUTPUT: 
%   
%       failedflag :: a status code describing how post processing
%           performed.
%           0 - no failures
%           1 - invalid/empty directory
%           2 - failure to combined .dat files
%           3 - failure to generate jstruct
%           4 - failure to do post processing statistics, if attempted.
%           5 - failure to combine contingency directories.
%       
%       err :: string describing the full callback trace if an error was
%           thrown
%
% ARGUMENTS:
%   
%       working_dir :: should be a directory with raw data. If combinecont
%           flag enabled, then should not have anything other than raw
%           data. If statflag enabled and combinecont disabled, user should
%           be prepared to move data to contingency folder manually if
%           desired
% 
% OPTIONAL ARGS: 
%
%       statflag :: whether to compute and save stats struct along with
%           velaccel structs (1) or not perform computation (0). Highly
%           recommended to leave this enabled, as many analysis scripts
%           require the stats structure to be saved.
%       
%       combinecont :: a flag indicating whether to combine the raw data
%           folder with the previous and appropriate contingency (1), 
%           or leave as is (0). Recommend to leave enabled for automated
%           post processing, but otherwise depends on user.
%
function [failedflag, err] = doAllpp(working_dir, varargin)
tic; %begin timing analysis

%% Argument manipulation and check validity of working_dir
disp(['Processing: ', working_dir]);
default = {1, 1};
numvarargs = length(varargin);
if numvarargs > 1
    error('too many arguments (> 2), only one required and one optional.');
end
[default{1:numvarargs}] = varargin{:};
[statflag, combinecont] = default{:};

failedflag = 0; err='';
try
    if (numel(working_dir)==0)
        working_dir = uigetdir(pwd);
    end
catch e
    failedflag = 1; err = getReport(e);
end

%% combine_contingencies: place in appropriate folder
if ~failedflag && combinecont
    try
        working_dir = combine_contingencies(working_dir);
    catch e
        failedflag = 5; err = getReport(e);
    end
end

%% ppscript: generate combined matlab files
if ~failedflag %hasn't failed so far
    try
        fileformatspec = '%f %f %s %s %s %s %s'; numfield = 7;
        ppscript(working_dir,fileformatspec,numfield);
    catch e
        failedflag = 2; err = getReport(e);
    end
end

%% xy_makestruct: generate jstruct
if ~failedflag
    try
        jstruct=xy_makestruct(working_dir);
        save(strcat(working_dir,'/jstruct.mat'),'jstruct');
        clear jstruct;
    catch e ; failedflag = 3; err = getReport(e);
    end
end

%% doAllstats: additional post processing
if statflag && ~failedflag
    try
        failedflag = doAllstats(working_dir);
    catch e
        failedflag = 4; err = getReport(e);
    end
end

toc; %end timing and display