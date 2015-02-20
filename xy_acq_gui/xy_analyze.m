function xy_analyze(src,event,hObject)
     handles = guidata(hObject);
     buff = handles.buff;
     buff_count = handles.buff_count;
     write_count = handles.write_count;
     frame_countdown = handles.frame_countdown;
     trig_mask =handles.trig_mask;
     
     data = event.Data;
     buff = [buff(:,1001:end) data'];
     a = var(data,0,1);
     for i=1:1
      diff_test(i)= (a((i-1)*5+1)>0.0005)||(a((i-1)*5+2)>0.0005)||(a((i-1)*5+3)>0.001)||(a((i-1)*5+5)>0.001);
     end
     buff_count = buff_count+1;
%      diff_dat = abs(data(:,[4 8 12 16])' - [0.001;0.001;0.001;0.001]*ones(size(data,1),1)'); 
%      %diff = abs(data' - [2.7;2.7;0.18;0.01;2.7;2.7;0.18;0.01;2.7;2.7;0.18;0.01;2.7;2.7;0.18;0.01]*ones(size(data,1),1)');
%      diff_sum = sum(diff_dat,2);
%      diff_test = diff_sum>10;
%    
     d = trig_mask(1:4)>0;
     frame_countdown(diff_test)=20;
     buff_count(diff_test&d)=11;
     trig_mask(diff_test)=0;
     frame_countdown(frame_countdown>0) = frame_countdown(frame_countdown>0) -1;
     dir_name = datestr(now,'mmdd');
     
      for id = 1:1
       if (buff_count(id)>10)
        if (frame_countdown(id)>0)
         write_count(id) = write_count(id)+1;
         foldername = strcat(handles.working_dir,'/data/box',num2str(id),'/',dir_name);
         if (~(exist(foldername,'file')))
             mkdir(foldername);
             restart_video(id,foldername,handles);          
         end
         
         filename = strcat(foldername,'/',handles.data_struct(id).name,'_',datestr(now,'yyyymmdd'),'_',num2str(sprintf('%05d',write_count(id))));
         fid = fopen(strcat(filename,'.dat'),'wb+');
         fwrite(fid,now,'double');
         fwrite(fid,buff(((id-1)*5+1):id*5,:),'double');
         %trigger(handles.vidobj(id));
         fclose(fid);
        end
         buff_count(id)=0;
      end
         
     end
     
     trig_mask(frame_countdown<1)=1;
     
     handles.buff = buff;
     handles.buff_count = buff_count;
     handles.write_count = write_count;
     handles.frame_countdown = frame_countdown;
     handles.trig_mask = trig_mask;
         
     guidata(hObject, handles);