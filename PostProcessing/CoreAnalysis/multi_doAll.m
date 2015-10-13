% [report, actual_count, succeed, newdirs] = multi_doAll(dir_list, varargin) 
%
%   a robust post processing function that can perform exactly
%   what doAllpp does, but for a list of directories. It will not crash on
%   single day failure, instead generating a log of analysis attempts
%   Automatically excludes erroneous additions to dir_list, filtering out 
%   non directory items. 
%
% OUTPUTS:
%
%       report :: n x 3 cell array. third column is status (failure type,
%           success), second column is error message, if it exists, and 
%           first column is directory name.
%
%       actual_count :: count of entries in dir_list that were actually
%           directories
%   
%       succeed :: number of entries in dir_list that multi_doAll succeeded
%           in its analysis
%
%       newdirs :: a list of the new directories containing successfully
%           analyzed data
%
% ARGUMENTS:
%       
%       dir_list :: list of directories (in struct representation) that
%           need to be analyzed
%
% OPTIONAL ARGUMENTS:
%
%       computeflag :: flag instructing what post processing analysis to perform
%           1 - contingency combining
%           2 - combine .dat files
%           3 - create jstruct (and save into folder)
%           4 - create stats (and save into folder)


function [report, actual_count, succeed, newdirs] = multi_doAll(dir_list, varargin) 
default = {1};
numvarargs = length(varargin);
if numvarargs > 1
    error('too many arguments (> 2), only one required and one optional.');
end
[default{1:numvarargs}] = varargin{:};
[computeflag] = default{:};

report = cell(length(dir_list), 3);
actual_count = 0;
succeed = 0;
for i = 1:length(dir_list)
    wdir = dir_list(i).name;
    report{i, 1} = wdir; 
    try
        %if it's actually a directory, process it, otherwise ignore
        if dir_list(i).isdir
            actual_count = actual_count+ 1;
            errormsg = ''; fail = 0;
            [fail, errormsg, newdir] = doAllpp(wdir, computeflag);
            
            %update appropriate record of failures
            report{i, 2} = errormsg;
            if fail == 2
                report{i, 3} = 'Combining .dat failure';
            elseif fail==3
                report{i, 3} = 'Generating jstruct.mat failure';
            elseif fail==4
                report{i, 3} = 'Computing stats failure';
            elseif fail==5
                report{i, 3} = 'Combining contingency failure';
            elseif fail
                report{i, 3} = 'Cause of failure unknown';
            else
                succeed = succeed+1;
                newdirs{succeed} = newdir;
                report{i, 3} = 'Succeeded';
            end
        else
            report{i, 2} = '';
            report{i, 3} = 'Not a directory';
        end
    catch e
        errormsg = getReport(e);
        report{i, 2} = errormsg;
        report{i, 3} = 'Cause of failure unknown';
    end
end

disp([num2str(actual_count), ' entries out of the input list were actually']);
disp(['directories. doAllpp processed ', num2str(succeed),'/',num2str(actual_count), ' of those directories.']);
disp('See report struct for information on which days failed.');