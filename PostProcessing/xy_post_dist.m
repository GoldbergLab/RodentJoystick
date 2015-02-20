function c = xy_post_dist()

working_dir = uigetdir(pwd);
filelist = dir(strcat(working_dir,'/*.mat'));

k=1;

for i=1:length(filelist)
load(strcat(working_dir,'/',filelist(i).name));
nose_poke = working_buff(3,:);
filelen = length(working_buff);
np_logical = (nose_poke>0.5);
   if sum(np_logical)>1 % check if there are any nose pokes in this file
       np_transition = diff(np_logical); %this will show the transitions 
       b=np_transition;
       flag=1;
       
       for j=1:length(b)        
          if b(j)==1 && flag==1
              c(k,1) = datenum_var - ((filelen-j)/10000)*(1/(24*3600));
              c(k,2) = 0;
              flag=0;
          elseif b(j)==-1 && flag==0        
              c(k,2) = datenum_var - ((filelen-j)/10000)*(1/(24*3600));
              flag=1;
              k=k+1;
          end  
       end     
   end  
end

