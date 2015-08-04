function [dist] = gaps(jstruct,index)
len = length(jstruct);
gap_list = [];
interv =10;

for i=1:len
    pairs = jstruct(i).js_pairs_l;
    for j=1:(size(pairs,1)-1);
        gap = pairs(j+1,2)-pairs(j,1);
        gap_list = [gap_list gap];
    end
end

dist = histc(gap_list,1:interv:1000);
stairs(1:interv:1000,dist);