%multi_doAll is a robust post processing function that can perform exactly
%what doAllpp does, but for a list of directories. It will not crash on
%single day failure, instead generating a report of all days that failed.
%It will also automatically exclude erroneous additions to dir_list,
%filtering out non directory items.
%failures is a struct containing error reports categorized by type of
%error. Each field is a category of error and contains a cell list of
%entries in dir_list that resulted in failure (possibly empty list).
%takes an optional argument computeflag that decides what set of post
%processing scripts to run
%   2 - runs all
%   1 - runs just basic jstruct creation and .dat combination
%   0 - runs only statistics/further post processing computation (requires
%       jstruct to be saved to directory
%Fields:
%   CombiningDat - indicates that the procedure failed to combine .dat
%       files sucessfully
%   MakingJstruct - failure to make jstruct
%   ComputingStats - failure to compute all statistics/processed data
%   SourceUnknown - error with unknown source.
function [failures, actual_count] = multi_doAll(dir_list, varargin) 
default = {2};
numvarargs = length(varargin);
if numvarargs > 1
    error('too many arguments (> 2), only one required and one optional.');
end
[default{1:numvarargs}] = varargin{:};
[computeflag] = default{:};

others ={}; combinefail={}; jstructfail={}; statsfail={};
actual_count = 0;
succeed = 0;
for i = 1:length(dir_list)
    wdir = dir_list(i).name;
    try
        %if it's actually a directory, process it, otherwise ignore
        if dir_list(i).isdir
            actual_count = actual_count+ 1;
            if computeflag==2; [fail, errormsg] = doAllpp(wdir, 1);
            elseif computeflag == 1; [fail, errormsg] = doAllpp(wdir, 0);
            elseif computeflag == 0; [fail, errormsg] = doAllstats(wdir);
            end
       
            %update appropriate record of failures
            if fail == 2
                combinefail{end+1} = [wdir,': ', errormsg];
            elseif fail==3
                jstructfail{end+1} = [wdir,': ', errormsg];
            elseif fail==4
                statsfail{end+1} = [wdir,': ', errormsg];
            elseif fail
                others{end+1} = [wdir,': ', errormsg];
            else
                succeed=succeed+1;
            end
        end
    catch e
        errormsg = getReport(e);
        others{end+1} = [wdir, ': ', errormsg];
    end
end

failures.CombiningDat = combinefail;
failures.MakingJstruct = jstructfail;
failures.ComputingStats = statsfail;
failures.SourceUnknown = others;

disp([num2str(actual_count), ' entries out of the input list were actually']);
disp(['directories. doAllpp processed ', num2str(succeed),'/',num2str(actual_count), ' of those directories.']);
disp('See failures struct for information on which days failed.');