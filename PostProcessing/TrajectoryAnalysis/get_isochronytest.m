function [dur_list,pathlen_list] = get_isochronytest(tstruct,quality,plotflag)

dur_list = [];
pathlen_list =[];
for i=1:numel(tstruct)
  k=0;
  dur=[];
  pathlen=[];
  if numel(tstruct(i).seginfo)>0
      for j=1:numel(tstruct(i).seginfo)          
        if (tstruct(i).seginfo(j).quality==quality)
        k=k+1;
        dur(k) = [tstruct(i).seginfo(j).dur];
        pathlen(k) = [tstruct(i).seginfo(j).pathlen];
        end                
      end
  end
    dur_list = [dur_list dur];
    pathlen_list = [pathlen_list pathlen];
end

if plotflag
    figure;
    plot(dur_list,pathlen_list,'ro');
end