%[report] = behavior_report(dirlist) 
%
%   takes a directory list and generates a string cell array report 
%   of the pellet counts and success rates of all directory entries in
%   dirlist. Statistics are separated by directory (not necessarily box)
%   
% ARGUMENTS
%
%   dirlist :: dirlist is a cell array of directory path strings
%
% OUTPUTS
%
%   special :: cell array of size (k x 1) containing single strings
%       describing unusually high/low pellet_counts
%
%   report :: cell array of size (m x 3) describing the full results of
%       each directory entry
%       each directory receives two lines
function [report] = behavior_report(celldirlist)
for i = 1:length(celldirlist)
    dirlist(i).name = celldirlist{i};
end
try
    statslist = load_stats(dirlist, 0, 'pellet_count', 'srate');
    report = cell(length(statslist)*2, 3);
    for i = 1:length(statslist);
        stats = statslist(i);
        split_up = strsplit(dirlist(i).name, '\');
        j = 2*i - 1; k = 2*i;
        report{j, 1} = split_up{end-2}; 
        report{j, 2} = [split_up{end}, ' pellets:'];
        report{j, 3} = num2str(stats.pellet_count);
        report{k, 1} = split_up{end-2};
        report{k, 2} = [split_up{end}, ' success rate: '];
        report{k, 3} = num2str(stats.srate);
    end
catch e
    disp(getReport(e));
    report = {'', '', ''};
end