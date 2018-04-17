function [] = get_calibration_curves(dirlist)

color = 'rbkmyk';
for ii=1:numel(dirlist)
    
    dirlist_axis = rdir(strcat(dirlist(ii).name,'\*'),'isdir');
    grpvect = [];
    for jj =1:numel(dirlist_axis)
        
        [path,foldname,ext] = fileparts(dirlist_axis(jj).name);
        cont_info = strsplit(foldname,'_');
        dist = str2num(cont_info{2});
        
        data_file_path = rdir(strcat(dirlist_axis(jj).name,'\comb\*.mat'));
        data = load(data_file_path(1).name,'working_buff');
        data = data.working_buff;
        
        x = data(:,1); y = data(:,2);
        disp = (x.^2 + y.^2).^(0.5);
        mean_disp = mean(disp); std_disp = std(disp);
        
        disp_vect(ii,jj).dist = dist;
        disp_vect(ii,jj).disp = disp';
        disp_vect(ii,jj).numsamples = numel(disp);
        disp_vect(ii,jj).mean_disp = mean_disp;
        disp_vect(ii,jj).std_disp = std_disp;
        grpvect = [grpvect (jj-1)*ones(1,numel(disp))];
    end
    
    mean_disp_vect = [disp_vect(ii,:).mean_disp];    
    std_disp_vect = [disp_vect(ii,:).std_disp];
    
    disp_cum = [disp_vect(ii,:).disp]- mean_disp_vect(1);
    %grpvect = grpvect(grpvect~=0);
    
     p = fitlm(grpvect,disp_cum*10)
     figure
     h = boxplot(disp_cum*10,grpvect,'plotstyle','compact');
     hold on;
     h=findobj(gca,'tag','Outliers');
     xdata = 0:1:6;
     pred_disp = predict(p,xdata');
     plot(xdata+1,pred_disp,'r','linewidth',2);
     
     ylabel('Voltage (mV)');
     xlabel('Distance (mm)');
     %legend('axis 1','axis 2');
     axis square
     
     delete(h);
     hold on
%      plot([0 1 2 3 4 5 6],(mean_disp_vect - mean_disp_vect(1))*10,strcat(color(ii)),'MarkerSize',10);    
end

