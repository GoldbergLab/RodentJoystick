function [trial_len,rate,max_dist,theta_list,hist_mat_total,traj_struct]=pp_traj_anly(jstruct,cen)
figure;

% axis1 = subplot(1,2,1);
% axis2 = subplot(1,2,2);
% axes(axis1)
x = 0.2*cosd(0:0.1:360);
y = 0.2*sind(0:0.1:360);
% plot(x,y,'k','LineWidth',2));
% axis([-0.8 0.8 -0.8 0.8])
% 
% axes(axis2)
% plot(x,y,'k');
% axis([-0.8 0.8 -0.8 0.8])
hist_mat_total = zeros(length(121));
num = 0;
windowSize=20;
k=0;
fail=0;
succ=0;
trial_len = 0;
theta_list = [];
 start_p=[];

for i=1:size(jstruct,2)
    if numel(jstruct(i).js_pairs)>0 && numel(jstruct(i).np_pairs)>0
        np_pairs = jstruct(i).np_pairs;
        js_pairs = jstruct(i).js_pairs;
        rw_onset = jstruct(i).reward_onset;
        js_reward = jstruct(i).js_reward;
        for j=1:size(jstruct(i).js_pairs,1)
            
            %check if js movement happens in between nosepokes
            
            if(sum(((np_pairs(:,1)-js_pairs(j,1))<0)&((np_pairs(:,2)-js_pairs(j,1))>0))>0)
            
            c = (np_pairs(:,1)-js_pairs(j,1))<0;
             start_p_temp = start_p;
             start_p = max(np_pairs(c,1));

             if (numel(start_p)>0 && ~isequaln(start_p_temp,start_p))                

%                 traj_x = jstruct(i).traj_x(start_p:rw_onset(js_reward(j)))-2.531;
%                 traj_y = jstruct(i).traj_y(start_p:rw_onset(js_reward(j)))-2.52;
                traj_x = jstruct(i).traj_x((start_p):(js_pairs(j,2)))-cen(1);
                traj_y = jstruct(i).traj_y((start_p):(js_pairs(j,2)))-cen(2);
                traj_x = filter(ones(1,windowSize)/windowSize,1,traj_x);
                traj_y = filter(ones(1,windowSize)/windowSize,1,traj_y);
                traj_x = traj_x(20:end-20);
                traj_y = traj_y(20:end-20);
                
                if ((traj_x(1)^2+traj_y(1)^2)^(0.5))<0.05
                    k=k+1;
                    
                    above_thresh=((traj_x.^2+traj_y.^2).^(0.5))>0.205;
                    one_length=0;
                    best_length=0;
                    for kk=1:length(above_thresh)
                      if above_thresh(kk)==1
                         one_length = one_length+1;
                         if one_length>best_length
                             best_length = one_length;
                         end
                      else
                          one_length=0;
                      end   
                    end
                    
                    a=find(above_thresh);
                    
                    
                    %trial_len(k) = sum(((traj_x.^2+traj_y.^2).^(0.5))>0.2);
                    %trial_len(k) = best_length;
                    if (js_reward(j))                                                                      
                        
%                         hold on
                          plot(traj_x,-1*traj_y,'b');
                        
%                         hist_mat = hist2d([traj_x' -1*traj_y'],(-0.6:0.01:0.6),(-0.6:0.01:0.6));
%                         hist_mat_total = hist_mat + hist_mat_total;
%                         num = num + length(traj_x);
                        if numel(a)>0
                          %plot(traj_x(a(1)),-1*traj_y(a(1)),'rx');
%                         plot(axis1,traj_x(1:200:a(1)),-1*traj_y(1:200:a(1)),'ro');
                          theta_list(k) = atan2d(-1*traj_y(a(1)),traj_x(a(1)));
                        end
%                         plot(axis1,traj_x,-1*traj_y,'r');
%                         plot(axis1,traj_x(1:200:end),-1*traj_y(1:200:end),'ro');
                        
                        succ = succ+1;
                        max_dist(k) = max((traj_x.^2+traj_y.^2).^(0.5));
                    else
%                         hist_mat = hist2d([traj_x' -1*traj_y'],(-0.6:0.01:0.6),(-0.6:0.01:0.6));
%                         hist_mat_total = hist_mat + hist_mat_total;
%                         num = num + length(traj_x);
%                         hold on
%                          plot(traj_x,-1*traj_y,'b');
% %                         plot(axis2,traj_x(1:200:end),traj_y(1:200:end),'bo');
%                         
                        
                        if numel(a)>0
                            %plot(traj_x(a(1)),-1*traj_y(a(1)),'bx');
                            theta_list(k) = atan2d(-1*traj_y(a(1)),traj_x(a(1)));
                        end
                        fail = fail+1;
                        
                    end                  
                            traj_struct{1,k} = traj_x;
                            traj_struct{2,k} = traj_y;
                    plot(traj_x(1),traj_y(1),'rx');
                     axis([-0.8 0.8 -0.8 0.8])
                    hold off
                end
            end
            end
        end
    end
end
hist_mat_total = hist_mat_total/num;
hold on
plot(x,y,'k','LineWidth',2);
axis([-0.8 0.8 -0.8 0.8])
rate = [succ fail];