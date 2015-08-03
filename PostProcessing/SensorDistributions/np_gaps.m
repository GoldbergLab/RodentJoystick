function [dist] = np_gaps(jstruct)
len = length(jstruct);
gap_list = [];

for i=1:len
    np_pairs = jstruct(i).np_pairs;
    for j=1:(size(np_pairs,1)-1);
        gap = np_pairs(j+1,2)-np_pairs(j,1);
        gap_list = [gap_list gap];
    end
end

dist = histc(gap_list,1:10:1000);
stairs(1:10:1000,dist);