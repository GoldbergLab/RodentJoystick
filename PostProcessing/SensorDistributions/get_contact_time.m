function [contact_time] =  get_contact_time(jstruct)

output = arrayfun(@(x) diff(x.js_pairs_r,1,2), jstruct, 'UniformOutput', false);
contact_time=[];
for i=1:length(output)
   contact_time = [contact_time;output{i}]; 
end
edges = 1:20:3000;
dist_ct = histc(contact_time,edges);
stairs(edges,dist_ct);
