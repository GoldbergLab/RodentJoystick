%behavior_report(dirlist, pelletmin, pelletmax) takes a directory list and
%generates a string cell array report of the pellet counts and success
%rates of the boxes 
function [special, report] = behavior_report(dirlist, pelletmin, pelletmax)
try
    statslist = load_stats(dirlist, 0);
    report = cell(length(statslist)*2, 3);
    special = {};
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
        if stats.pellet_count < pelletmin || stats.pellet_count > pelletmax
            special{end+1} = [split_up{end-2}, ' received ', num2str(stats.pellet_count),...
                                ' pellets on ', split_up{end}];
        end
    end
catch e
    special = '';
    report = {'', '', ''};
end