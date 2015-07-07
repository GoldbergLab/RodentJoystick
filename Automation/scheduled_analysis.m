function scheduled_analysis( )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

%put the main directory containing experiment data here.
toprocesslist = directories_to_do('K:\DataSync');
time = now;
%recipients of reports:
recipients={'nitinshyamk@gmail.com', 'glab.cornell@gmail.com'};

report = {'Analysis attempted on the following directories:'};
failurereport = multi_doAll(toprocesslist);
for i = 1:length(toprocesslist)
    report{end+1} = toprocesslist(i).name;
end

report{end+1} = 'Analysis on the following directories failed:';
report{end+1} = 'Combining .dat files failures:';
for i = 1:length(failurereport.CombiningDat)
    report{end+1} = failurereport.CombiningDat{i};
end
report{end+1} = 'Making jstruct files failures:';
for i = 1:length(failurereport.MakingJstruct)
    report{end+1} = failurereport.MakingJstruct{i};
end
report{end+1} = 'Computing Statistics failures:';
for i = 1:length(failurereport.ComputingStats)
    report{end+1} = failurereport.ComputingStats{i};
end
report{end+1} = 'Failure source unknown:';
for i = 1:length(failurereport.SourceUnknown)
    report{end+1} = failurereport.SourceUnknown{i};
end
title = ['Analysis Report', datestr(now)];
matlabmail(recipients, report, title);


end

