function [failure, err] = doAllstats(wdir)
% [failure, err] = doAllstats(wdir)
%
%   performs all computation/post processing of specific statistics
%   and metrics. Currently, it just computes the stats structure along with
%   the velocity/acceleration data, but it can be extended to do additional 
%   post processing. Its better to change this rather than
%   doAllpp to cache specific post processing data
%
% OUTPUTS: 
%   
%       failure :: a status code indicating if the function failed to do
%           analysis on wdir. 4 if function failed, 0 otherwise. (4 was
%           selected to be consistent with doAllpp)
%
%       err :: a string with the full stack trace if an error was thrown
%
% ARGUMENTS:
%
%       wdir :: working directory (passed as a string). Must contain a
%           jstruct.
failure = 0; err = '';
list = rdir([wdir,'\jstruct.mat']);
if length(list)>1
    failure = 4;
    err = 'Multiple jstructs in a single folder';
elseif length(list)<1
    failure = 4;
    err = ['No jstructs found in ',wdir];
end
try
    load(list(1).name);
    stats = xy_getstats(jstruct, wdir);
    stats = xy_getstats(jstruct, wdir ,1);
    clear jstruct;
catch e
    failure = 4; err = getReport(e);
end