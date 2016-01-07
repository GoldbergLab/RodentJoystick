function [edges,dist] = get_segmentspeeddist(tstruct,quality,plotflag)

peakvel_list = [];
for i=1:numel(tstruct)
  k=0;
  peakvel=[];
  if numel(tstruct(i).seginfo)>0
      for j=1:numel(tstruct(i).seginfo)          
        if (tstruct(i).seginfo(j).quality==quality)
        k=k+1;
        peakvel(k) = [tstruct(i).seginfo(j).peakvel];
        end                
      end
  end
    peakvel_list = [peakvel_list peakvel];
end
edges = 0:0.001:0.05;
dist = histc(peakvel_list,edges);

if plotflag
    figure;
    stairs(edges,dist);
end