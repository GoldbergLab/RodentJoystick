function [edges,dist] = get_segmentfitdist(tstruct,plotflag)

qual_list = [];
for i=1:numel(tstruct)
  if numel(tstruct(i).seginfo)>0 
    qual = [tstruct(i).seginfo.quality];
    qual_list = [qual_list qual];
  end
end
edges = 0:8;
dist = histc(qual_list,edges);

if plotflag
    figure;
    stairs(edges,dist);
end
