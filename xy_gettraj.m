function traj = xy_gettraj(working_dir)

working_dir = uigetdir(pwd);
filelist=dir(strcat(working_dir,'/*.mat'));
figure
h1=axes;

   index=1;

   c(1,1) = 1;
   c(1,2) = 1;
 figure
 h2=axes;
for i=1:length(filelist)
    
  data = load(strcat(working_dir,'\',filelist(i).name));
  working_buff = data.working_buff;
  
  
  %Segment the nose pokes
   a = (working_buff(3,:)>0.5); 
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
       c(c==0)=length(working_buff);
   
   for k=1:(length(working_buff)/50-2)
       traj_varx(k)=var(working_buff(1,(((k-1)*50+1):(k*50+100))))>0.0001;
       traj_vary(k)=var(working_buff(2,(((k-1)*50+1):(k*50+100))))>0.0001;
   end
       
       traj_var = traj_varx | traj_vary;
   
   %Nose pokes are Segmented into vector c
   
   
   axes(h2)
   plot(working_buff(1,end),(working_buff(2,end)),'rx');
   hold on
   %Deterimine if there was a pellet dispensed within the nose poke period
   for j=1:size(c,1)
       if c(j,1)>1000
       pell_disp = find(diff(working_buff(4,c(j,1):c(j,2))>0.5)==1);
       pell_dist = find(diff(((working_buff(2,c(j,1):c(j,2))-2.62).^2+(working_buff(1,c(j,1):c(j,2))-2.83).^2)>((40*5/1024)^2))==1);
       center_list = (working_buff(1,(c(j,1)-10):(c(j,1)+10))-2.81).^2 + (working_buff(2,(c(j,1)-10):(c(j,1)+10))-2.61).^2;
       windowSize=20;
       js_var_ind = find(traj_var((fix(c(j,1)/50-150):fix(c(j,2)/50))));
       if numel(js_var_ind)>0
        js_onset = min(js_var_ind)-150;
       else
        js_onset=[];
       end
       
        
       if numel(pell_disp)>0
          traj_x =  working_buff(1,(c(j,1)-20):(c(j,2)))-2.52;%+pell_dist(1)))-2.83;median(working_buff(1,(c(j,1)-10):c(j,1)));%
          traj_y =  working_buff(2,(c(j,1)-20):(c(j,2)))-2.49;%median(working_buff(2,(c(j,1)-10):c(j,1)));%-2.62;%+pell_dist(1)));%
          traj_x = filter(ones(1,windowSize)/windowSize,1,traj_x);
          traj_y = filter(ones(1,windowSize)/windowSize,1,traj_y);
          
          traj_x = traj_x(20:end-20);
          traj_y = traj_y(20:end-20);
          traj_disp = (traj_x.^2 + traj_y.^2);            
          
          traj{index,1} = traj_x;
          traj{index,2} = traj_y;
          traj{index,3} = max(traj_disp(20:end-20).^(0.5));
          traj{index,4} = js_onset;
          
          pl_len = min(length(traj_x)-20,500);
          index=index+1;
          
          axes(h1)
           plot(traj_x(20:pl_len),traj_y(20:pl_len));
           plot(traj_x(21),traj_y(21),'rx');
          hold on
%            axes(h2)
%            plot(1:(length(traj_x)-39),);
%            hold on;
       elseif ((mean(center_list)<(15*5/1024)^2) && (c(j,2)-c(j,1))>800) %&& (c(j,2)-c(j,1))<7000)
          if numel(pell_dist)<1
              pell_dist = c(j,2);
          else
              pell_dist(1) = pell_dist(1)+c(j,1);
          end
          traj_x = working_buff(1,(c(j,1)-20):c(j,2))-2.76;%-mean(working_buff(1,(c(j,1)-10):c(j,1)));%-2.83;%pell_dist(1))-2.83;%
          traj_y = working_buff(2,(c(j,1)-20):c(j,2))-2.69;%-mean(working_buff(2,(c(j,1)-10):c(j,1)));%-2.62;%pell_dist(1))-2.62;%
          traj_x = filter(ones(1,windowSize)/windowSize,1,traj_x);
          traj_y = filter(ones(1,windowSize)/windowSize,1,traj_y);
          
          traj_x = traj_x(20:end-20);
          traj_y = traj_y(20:end-20);          
          
          traj_disp = (traj_x.^2 + traj_y.^2);
         
          traj{index,1} = traj_x;
          traj{index,2} = traj_y;
          traj{index,3} = max(traj_disp(20:end-20).^(0.5));
          traj{index,4} = js_onset;
          
          index=index+1;
          
          pl_len = min(length(traj_x)-20,500);
          
          axes(h1)
            plot(traj_x(20:pl_len),traj_y(20:pl_len));
            plot(traj_x(21),traj_y(21),'rx');
          hold on
      
       end  
       end
   end
   
   
%    axes(h1)
   
      t = 0:0.01:1;
   
%    x = 0.07*cos(2*pi*t);
%    y = 0.07*sin(2*pi*t);
%    plot(x,y,'k','LineWidth',2);
%    hold on
%    
%    x = 0.12*cos(2*pi*t);
%    y = 0.12*sin(2*pi*t);
%    plot(x,y,'k');
   
   ylim([-0.5 0.5])
   xlim([-0.5 0.5])
   
   
   
%    axes(h2)
%    ylim([2 3])
    c=[];
   end     
   
   
   
end

