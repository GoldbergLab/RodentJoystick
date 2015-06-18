function [hold_time_sug,max_cont_len,hold_len]=xy_holddist(jstruct,holdthresh,pccorrect)

rec_len = length(jstruct);
np_js=0;
k=0;
max_cont_len = [];
%hold_len = [];
for ii=1:rec_len
    %get the joystick, post, and nosepoke pairs for the file
    js = jstruct(ii).js_pairs_r;
    fp = jstruct(ii).js_pairs_l;
    np = jstruct(ii).np_js_start;
    %if not zero nosepokes
    if numel(np)>0 
       %get x and y trajectory information to find magnitude
       x =  jstruct(ii).traj_x;
       y =  jstruct(ii).traj_y;
       mag= (x.^2+y.^2).^(0.5);
       %iterate through each joystick touch pair
       for jj=1:size(js,1)
           np_js_prev = np_js;
           np_js = np(jj);
           if js(jj,2)>0
               %hold_len(k) = js(jj,2)-js(jj,1);
               thresh_ind = mag(js(jj,1):js(jj,2))<holdthresh;
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
                    if (np_js == np_js_prev)
                        max_cont_len(k) = max(max((d(:,2)-d(:,1)))-1,max_cont_len(k));
                    else
                        k=k+1;
                        max_cont_len(k) = max((d(:,2)-d(:,1)))-1;
                    end
                   end
                   d =[];
               end
               
           end
       end
       end
end
if length(max_cont_len)<k
 max_cont_len(k) = 0;
end
if length(max_cont_len>1)
    l = histc(max_cont_len,0:5:1000);
    success_prob = cumsum(l)./sum(l);
    c = find(success_prob>pccorrect);
    if numel(c)==0
        c(1) = 200;
    end    
    hold_time_sug = c(1)*5;
    
    % figure
    % hist_dist = histc(max_cont_len,[0:5:1000 inf]);
    % bar(0:5:1005,hist_dist);
else
    hold_time_sug =0;
end

