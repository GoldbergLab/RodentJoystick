%does all post processing, including combining contingencies, combining
%.dat files, generating jstruct, and by default, computing stats, velocity,
% and acceleration profiles.
%failedflag gives detailed information about how post processing went:
%   0 - no failures
%   1 - invalid/empty directory
%   2 - failure to combined .dat files
%   3 - failure to generate jstruct
%   4 - failure to do post processing statistics, if attempted.
%   5 - failure to combine contingency directories.
function [failedflag, err] = doAllpp(working_dir, varargin)
tic;
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

%combine contingencies
if ~failedflag
    try
        working_dir = combine_contingencies(working_dir);
    catch e
        failedflag = 5; err = getReport(e);
    end
end

%generate combined matlab files
if ~failedflag %hasn't failed so far
    try
        fileformatspec = '%f %f %s %s %s %s %s'; numfield = 7;
        ppscript(working_dir,fileformatspec,numfield);
    catch e
        failedflag = 2; err = getReport(e);
    end
end

%generate jstruct
if ~failedflag
    try
        jstruct=xy_makestruct(working_dir);
        save(strcat(working_dir,'/jstruct.mat'),'jstruct');
        clear jstruct;
    catch e ; failedflag = 3; err = getReport(e);
    end
end

%does additional post processing
if statflag
    if ~failedflag
        try
            failedflag = doAllstats(working_dir);
        catch e
            failedflag = 4; err = getReport(e);
        end
    end
end

% combine_contingencies is at the end (even though there's an extra 30 MB
% to move doing it this way) because it is much faster to move
% combine_contingencies manually if this fails, than if jstruct/stats
% analysis fails. While we could alternatively ignore errors from
% combine_contingencies and leave it at the top, this runs the risk of
% missing genuine errors.

toc;