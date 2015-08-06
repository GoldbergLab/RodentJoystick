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
%       analysisflag :: instructs where in analysis process to begin
%           combine_contingencies (1) -> ppscript (2) -> make jstruct (3)
%           -> generate stats (4)
%           DEFAULT - 2
%
%       singlestep :: when enabled, only performs the single step selected (1),
%           otherwise does rest of analysis process
%           DEFAULT - 0
%       

function [failedflag, err] = doAllpp(working_dir, varargin)
tic; %begin timing analysis

%% Argument manipulation and check validity of working_dir
disp(['Processing: ', working_dir]);
default = {2, 0};
numvarargs = length(varargin);
if numvarargs > 2
    error('too many arguments (> 3), only 1 required and 2 optional.');
end
[default{1:numvarargs}] = varargin{:};
[analysisflag, singlestep] = default{:};

failedflag = 0; err='';
try
    if (numel(working_dir)==0)
        working_dir = uigetdir(pwd);
    end
catch e
    failedflag = 1; err = getReport(e);
end

%% combine_contingencies: place in appropriate folder
if ~failedflag && ((analysisflag<=1 && ~singlestep) || analysisflag == 1)
    try
        working_dir = combine_contingencies(working_dir);
    catch e
        failedflag = 5; err = getReport(e);
    end
end

%% ppscript: generate combined matlab files
if ~failedflag && ((analysisflag<=2 && ~singlestep) || analysisflag == 2)
    try
        fileformatspec = '%f %f %s %s %s %s %s'; numfield = 7;
        ppscript(working_dir,fileformatspec,numfield);
    catch e
        failedflag = 2; err = getReport(e);
    end
end

%% xy_makestruct: generate jstruct
if ~failedflag && ((analysisflag<=3 && ~singlestep) || analysisflag == 3)
    try
        [jstruct] =xy_makestruct(working_dir);
        save([working_dir,'/jstruct.mat'],'jstruct');
        clear jstruct;
    catch e ; failedflag = 3; err = getReport(e);
    end
end

%% doAllstats: additional post processing
if ~failedflag && ((analysisflag<=4 && ~singlestep) || analysisflag == 4)
    try
        [failedflag, err] = doAllstats(working_dir);
    catch e
        failedflag = 4; err = getReport(e);
    end
end

toc; %end timing and display