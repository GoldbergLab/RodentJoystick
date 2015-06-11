function [traj_pdf,traj_pdf_all,speedmean,speedmeanvar,speedmean_all,speedmeanvar_all] = xy_vel(jstruct)
stats=xy_getstats(jstruct);
    xcol = -120:2:120;
    ycol = -120:2:120;
    mat_size =[length(xcol)-1,length(ycol)-1]; 
vellist=cell(mat_size);
vellist_all=cell(mat_size);
traj_holdtimespeed=[];
traj_pdf = zeros(mat_size);
traj_pdf_all = zeros(mat_size);
windowSize =5;
all_traj_flag=1;
traj_struct = stats.traj_struct;

for i=1:length(traj_struct)
    stop = traj_struct(i).rw_or_stop;
    x = traj_struct(i).traj_x(1:stop);
    y = traj_struct(i).traj_y(1:stop);
    if (length(x)>10) %&& ((x(1)^2+y(1)^2)^(0.5))<20
          
    %filter
%     x = filter(ones(1,windowSize)/windowSize,1,x);
%     y = filter(ones(1,windowSize)/windowSize,1,y);
%     x = x(5:end-5);
%     y = y(5:end-5);
    
    magtraj = traj_struct(i).magtraj;
    speeddiff = ((diff(x)).^2 + diff(y).^2).^(0.5);
    traj_holdtimespeed = [traj_holdtimespeed;length(x) mean(speeddiff(1:5)) mean(speeddiff(1:10))];
    x = x(2:end);
    y = y(2:end);
    

    if length(x)>100
        traj_pdf = traj_pdf + hist2d([y',x'],xcol,ycol);
        traj_pdf_all = traj_pdf_all + hist2d([y',x'],xcol,ycol);
    else
        traj_pdf_all = traj_pdf_all + hist2d([y',x'],xcol,ycol);
    end
    
    for j = 1:(length(x)-1)
        [dist,xcol_det] = histc(x(j),xcol);
        [dist,ycol_det] = histc(y(j),ycol);
           if (length(x)>100)
            vellist{xcol_det,ycol_det} = [vellist{xcol_det,ycol_det} speeddiff(j)];
            vellist_all{xcol_det,ycol_det} = [vellist_all{xcol_det,ycol_det} speeddiff(j)];
         else
            vellist_all{xcol_det,ycol_det} = [vellist_all{xcol_det,ycol_det} speeddiff(j)]; 
         end    
    end
%     for j=1:100
%      for k=1:100
%          if (length(x)>100)
%             elements = speeddiff((y<((j-50)*2)&y>((j-51)*2))&(x<((k-50)*2)&x>((k-51)*2)));
%             vellist{k,j} = [vellist{k,j} elements];
%             vellist_all{k,j} = [vellist_all{k,j} elements];
%          else
%             vellist_all{k,j} = [vellist_all{k,j} speeddiff((y<((j-50)*2)&y>((j-51)*2))&(x<((k-50)*2)&x>((k-51)*2)))]; 
%          end    
%      end
%     end
    end
end

traj_pdf = traj_pdf./(sum(sum(traj_pdf)));
traj_pdf_all = traj_pdf_all./(sum(sum(traj_pdf_all)));

speedmean = zeros(mat_size);
speedvar25 = zeros(mat_size);
speedvar75 = zeros(mat_size);
speedmean_all = zeros(mat_size);
speedvar25_all = zeros(mat_size);
speedvar75_all = zeros(mat_size);


vecempty = cellfun('isempty',vellist);

for i=1:length(speedmean)
    for j=1:length(speedmean)
        if ~vecempty(i,j)
            speedmean(i,j) = median(vellist{i,j})*6.35/100;
            speedvar25(i,j) = prctile(vellist{i,j},25)*6.35/100;
            speedvar75(i,j) = prctile(vellist{i,j},75)*6.35/100;
        end
    end
end

vecempty = cellfun('isempty',vellist_all);
for i=1:length(speedmean)
    for j=1:length(speedmean)
        if ~vecempty(i,j)
            speedmean_all(i,j) = median(vellist_all{i,j})*6.35/100;
            speedvar25_all(i,j) = prctile(vellist_all{i,j},25)*6.35/100;
            speedvar75_all(i,j) = prctile(vellist_all{i,j},75)*6.35/100;
        end
    end
end

speedmeanvar_all = speedvar75_all-speedvar25_all;
speedmeanvar = speedvar75-speedvar25;

[dist,bin] = histc(traj_holdtimespeed(:,1),0:50:1600);
meansptime =[];
for i=1:length(0:50:1600);
    meansptime(i) = mean(traj_holdtimespeed(bin==i,2));
end

figure
plot(0:50:1600,meansptime,'rx');
xlabel('Time of trajectory');
ylabel('mean speed mm/ms');
