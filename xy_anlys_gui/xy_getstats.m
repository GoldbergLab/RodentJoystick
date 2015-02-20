function event_struc = xy_getstats(working_dir,filelist)
event_struc = [];
 figure_handle=figure;
%  h1=subplot(3,1,1);
%  h2=subplot(3,1,2);
h3=subplot(1,1,1);
count=0;
mkdir(strcat(working_dir,'/pellet_only'));
for i=1:length(filelist)
%     fid = fopen(strcat(working_dir,'/',filelist{i}));
%     datenum_var = fread(fid,1,'double');
%     working_buff= fread(fid,[4 11000],'double');
%     fclose(fid);
    
    data = load(strcat(working_dir,'/',filelist{i}));
    working_buff=data.working_buff;
    %detect changes in any of the four channels, mark the date num
    nose_poke = sum(working_buff(3,:)>0.5);
    pellet_dispense = sum(working_buff(4,:)>0.5);
    if nose_poke>0
        a = find(working_buff(3,:)>0.5);
        time_1=datenum_var+((11000-a(1))/10000)/(24*3600);
        event_struc = [event_struc;time_1 1];
    end
    if pellet_dispense>0
        a = find(working_buff(4,:)>0.5); 
        if a(1)>1
         copyfile((strcat(working_dir,'/',filelist{i})),strcat(working_dir,'/pellet_only/',filelist{i}));   
         time_1=datenum_var+((11000-a(1))/10000)/(24*3600);
         event_struc = [event_struc;time_1 2];
        end
        if (((a(1)-3500)>0))
          count=count+1;
          windowSize=20;
          traj_x = working_buff(1,a-199:(a-5)); %-mean(working_buff(1,(a-2500):(a-2000)));
          traj_y = working_buff(2,a-199:(a-5)); %-mean(working_buff(2,(a-2500):(a-2000)));
          traj_x = filter(ones(1,windowSize)/windowSize,1,traj_x);
          traj_y = filter(ones(1,windowSize)/windowSize,1,traj_y);
%           subplot(3,1,1)
%           set(figure_handle,'CurrentAxes',h1)
%           plot((1/10000)*(1:length(traj_x(20:(end-20)))),(traj_x(20:(end-20))),'b');
%           hold on
%           subplot(3,1,2)
%           set(figure_handle,'CurrentAxes',h2)
%           plot((1/10000)*(1:length(traj_x(20:(end-20)))),(traj_y(20:(end-20))),'b');
%           hold on
          subplot(1,1,1)
          set(figure_handle,'CurrentAxes',h3)
          plot(traj_x(20:(end-20)),traj_y(20:(end-20)),'b');
          axis([2.2 2.8 2.2 2.8]);
          axis square          
          hold on
        end
    end  
end

x = 0.1*sin(0:0.01:2*pi)+2.42;
y = 0.1*cos(0:0.01:2*pi)+2.65;
set(figure_handle,'CurrentAxes',h3)
plot(x,y,'k','LineWidth',2);
plot(0,0,'kx','MarkerSize',4,'Linewidth',2)
axis([2.0 3.0 2.0 3.0]);
axis square

set(figure_handle,'CurrentAxes',h1)
axis([0 0.15 2.4 3.4]);
axis square
title('Left(-) and right(+) (x axis)');
xlabel('Time (s)')
ylabel('Voltage (V)');
set(figure_handle,'CurrentAxes',h2)
title('Towards(+) and Away(-) (y axis)')
xlabel('Time (s)')
ylabel('Voltage (V)');
axis([0 0.15 2.0 3.0]);
axis square
