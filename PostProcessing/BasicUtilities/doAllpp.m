%does all post processing, including combined .dat files, generating
%jstruct, and by default, computing stats, velocity, and acceleration
%structures.
%failedflag gives detailed information about how post processing went:
%   0 - no failures
%   1 - invalid/empty directory
%   2 - failure to combined .dat files
%   3 - failure to generate jstruct
%   4 - failure to do post processing statistics, if attempted.
function [failedflag, err] = doAllpp(working_dir, varargin) 
disp(['Processing: ', working_dir]);
default = {1};
numvarargs = length(varargin);
if numvarargs > 1
    error('too many arguments (> 2), only one required and one optional.');
end
[default{1:numvarargs}] = varargin{:};
[statflag] = default{:};

failedflag = 0; err='';
try
    if (numel(working_dir)==0)
        working_dir = uigetdir(pwd);
    end
catch e
    failedflag = 1; err = getReport(e);
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
