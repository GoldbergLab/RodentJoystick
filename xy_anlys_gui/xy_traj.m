function traj = xy_traj(data)

x_cen = data(1,end);
y_cen = data(2,end);
traj ={};
index = 1;
a = (data(3,:)>0.5); 
   if sum(a)>1 % check if there are any nose pokes in this file
       b = diff(a); %this will show the transitions 
       k=1;
       flag=1;
       
       for j=1:length(b)        
          if b(j)==1 && flag==1
              c(k,1) = j;
              c(k,2) = 0;
              flag=0;
          elseif b(j)==-1 && flag==0        
              c(k,2) = j;
              flag=1;
              k=k+1;
          end  
       end
       c(c==0)=length(data);
   
   for k=1:(length(data)/50-2)
       traj_varx(k)=var(data(1,(((k-1)*50+1):(k*50+100))))>0.0002;
       traj_vary(k)=var(data(2,(((k-1)*50+1):(k*50+100))))>0.0002;
   end
       
       traj_var = traj_varx | traj_vary;
   
   %Nose pokes are Segmented into vector c
   
   
%    axes(h2)
%    plot(data(1,end),(data(2,end)),'rx');
%    hold on
   %Deterimine if there was a pellet dispensed within the nose poke period
   for j=1:size(c,1)
       if c(j,1)>1000
       pell_disp = find(diff(data(4,c(j,1):c(j,2))>0.5)==1);
       pell_dist = find(diff(((data(2,c(j,1):c(j,2))-x_cen).^2+(data(1,c(j,1):c(j,2))-y_cen).^2)>((40*5/1024)^2))==1);
       center_list = (data(1,(c(j,1)-10):(c(j,1)+10))-x_cen).^2 + (data(2,(c(j,1)-10):(c(j,1)+10))-y_cen).^2;
       windowSize=20;      
        
       if numel(pell_disp)>0
          traj_x =  data(1,(c(j,1)-20):(c(j,2)))-x_cen;%+pell_dist(1)))-2.83;median(data(1,(c(j,1)-10):c(j,1)));%
          traj_y =  data(2,(c(j,1)-20):(c(j,2)))-y_cen;%median(data(2,(c(j,1)-10):c(j,1)));%-2.62;%+pell_dist(1)));%
          traj_x = filter(ones(1,windowSize)/windowSize,1,traj_x);
          traj_y = filter(ones(1,windowSize)/windowSize,1,traj_y);
          
          traj_x = traj_x(20:end-20);
          traj_y = traj_y(20:end-20);
          traj_disp = (traj_x.^2 + traj_y.^2);            
          
          traj{index,1} = traj_x;
          traj{index,2} = traj_y;
          traj{index,3} = max(traj_disp(20:end-20).^(0.5));
          traj{index,4} = c(j,1)-20;
          
          pl_len = min(length(traj_x)-20,500);
          index=index+1;
          
%           axes(h1)
%            plot(traj_x(20:pl_len),traj_y(20:pl_len));
%            plot(traj_x(21),traj_y(21),'rx');
%           hold on
%            axes(h2)
%            plot(1:(length(traj_x)-39),);
%            hold on;
       elseif ((mean(center_list)<(15*5/1024)^2) && (c(j,2)-c(j,1))>800) %&& (c(j,2)-c(j,1))<7000)
          if numel(pell_dist)<1
              pell_dist = c(j,2);
          else
              pell_dist(1) = pell_dist(1)+c(j,1);
          end
          traj_x = data(1,(c(j,1)-20):c(j,2))-x_cen;%-mean(data(1,(c(j,1)-10):c(j,1)));%-2.83;%pell_dist(1))-2.83;%
          traj_y = data(2,(c(j,1)-20):c(j,2))-y_cen;%-mean(data(2,(c(j,1)-10):c(j,1)));%-2.62;%pell_dist(1))-2.62;%
          traj_x = filter(ones(1,windowSize)/windowSize,1,traj_x);
          traj_y = filter(ones(1,windowSize)/windowSize,1,traj_y);
          
          traj_x = traj_x(20:end-20);
          traj_y = traj_y(20:end-20);          
          
          traj_disp = (traj_x.^2 + traj_y.^2);
         
          traj{index,1} = traj_x;
          traj{index,2} = traj_y;
          traj{index,3} = max(traj_disp(20:end-20).^(0.5));
          traj{index,4} = c(j,1)-20;
          
          index=index+1;
          
          pl_len = min(length(traj_x)-20,500);
          
%           axes(h1)
%             plot(traj_x(20:pl_len),traj_y(20:pl_len));
%             plot(traj_x(21),traj_y(21),'rx');
%           hold on
      
       end  
       end
   end
   end  