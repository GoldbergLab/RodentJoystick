function [np js]= xy_js_onset(working_dir)

filelist = dir(strcat(working_dir,'/*.mat'));

for i=1:length(filelist)   
load(strcat(working_dir,'/',filelist(i).name));
c=[];
    nose_poke = working_buff(3,:);
    np_logical = (nose_poke>0.5);
    l=1;
   if sum(np_logical)>1
       np_transition = diff(np_logical); %this will show the transitions 
       b=np_transition;
       flag=1;
       
       for j=1:length(b)        
          if b(j)==1 && flag==1
              c(i,l,1) = j;
              c(i,l,2) = 0;
              flag=0;
          elseif b(j)==-1 && flag==0        
              c(i,l,2) = j;
              flag=1;
              l=l+1;
          end  
       end
   end

    
   
    js_touch = working_buff(5,:);
    jt_logical = (js_touch>0.5);
    l=1;
    d=[];
   if sum(jt_logical)>1
       jt_transition = diff(jt_logical); %this will show the transitions 
       b=jt_transition;
       flag=1;
       
       for j=1:length(b)        
          if b(j)==1 && flag==1
              d(i,l,1) = j;
              d(i,l,2) = 0;
              flag=0;
          elseif b(j)==-1 && flag==0        
              d(i,l,2) = j;
              flag=1;
              l=l+1;
          end  
       end
   end

end
% minlen = min(size(d,1),size(c,1));
% js = d(1:minlen);
% np = c(1:minlen);
js =d;
np =c;

