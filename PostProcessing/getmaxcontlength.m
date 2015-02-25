function max_cont_len = getmaxcontlength(magtraj,thresh)

               thresh_ind = magtraj<thresh;
               m=1;
               %% Get the max length
               if sum(thresh_ind)>1
                   tch_transition = diff([0 thresh_ind 0]); %this will show the transitions
                   b=tch_transition;
                   flag=1;
                   
                   for j=1:length(b)
                       if b(j)==1 && flag==1
                           d(m,1) = j;
                           d(m,2) = 0;
                           flag=0;
                       elseif b(j)==-1 && flag==0
                           d(m,2) = j;
                           flag=1;
                           m=m+1;
                       end                                          
                   end
                   try
                        max_cont_len = max((d(:,2)-d(:,1)))-1;
                   catch
                       max_cont_len=0;
                   end
                   d =[];
               else
                   max_cont_len=0;
               end

