% doAllstats performs all computation/post processing of specific statistics
% and metrics. Currently, it just computes the stats structure in addition to
% the velocity/acceleration data, but it can be extended to do additional 
% post processing.
% failure is a flag that is 4 if the function failed on wdir or 0 if it
% succeeded. (4 is selected to be consistent with doAllpp).
% it is also possible for the function to throw an error, if wdir is a bad
% argument - (folder containing multiple, or no jstructs).
function [failure, err] = doAllstats(wdir)
failure = 0; err = '';
list = rdir([wdir,'\jstruct.mat']);
if length(list)>1
    failure = 1;
    error('Multiple jstructs in a single folder');
elseif length(list)<1
    failure = 1;
    error(['No jstructs found in ',wdir]);
end
try
    load(list(1).name);
    stats = xy_getstats(jstruct);
    clear jstruct;
    save(strcat(wdir,'\stats.mat'),'stats');
    [velaccel, velaccelraw] = compute_vel_accel_distr(stats);
    save(strcat(wdir,'\velaccel.mat'), 'velaccel');
    save(strcat(wdir,'\velaccelraw.mat'), 'velaccelraw');
catch e
    failure = 1; err = getReport(e);
end