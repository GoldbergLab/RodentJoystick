function [edges,dist] = get_segmentdurdist(tstruct,quality,plotflag)

dur_list = [];
for i=1:numel(tstruct)
  k=0;
  dur=[];
  if numel(tstruct(i).seginfo)>0
      for j=1:numel(tstruct(i).seginfo)          
        if (tstruct(i).seginfo(j).quality>quality)
        k=k+1;
        dur(k) = [tstruct(i).seginfo(j).dur];
        end                
      end
  end
    dur_list = [dur_list dur];
end
edges = 1:1:100;
dist = histc(dur_list,edges);

if plotflag
    figure;
    stairs(edges,dist);
end