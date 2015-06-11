function [speedmean,speedmeanvar,speedmean_all,speedmeanvar_all] = xy_vel(boxnum,strdate)
list = rdir([pwd,strcat('\*\Box',str2num(boxnum),'\',strdate,'\jstruct.mat')]);
load(list{1}.name);stats=xy_getstats(jstruct);

vellist=cell(100,100);
vellist_all=cell(100,100);
traj_holdtimespeed=[];
windowSize =5;
all_traj_flag=1;
traj_struct = stats.traj_struct;
for i=1:length(traj_struct)
    x = traj_struct(i).traj_x;
    y = traj_struct(i).traj_y;
    if length(x)>10
          
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
 
    for j=1:100
     for k=1:100
         if (length(x)>100)
            vellist{k,j} = [vellist{k,j} speeddiff((y<((j-50)*2)&y>((j-51)*2))&(x<((k-50)*2)&x>((k-51)*2)))];
            vellist_all{k,j} = [vellist_all{k,j} speeddiff((y<((j-50)*2)&y>((j-51)*2))&(x<((k-50)*2)&x>((k-51)*2)))];
         else
            vellist_all{k,j} = [vellist_all{k,j} speeddiff((y<((j-50)*2)&y>((j-51)*2))&(x<((k-50)*2)&x>((k-51)*2)))]; 
         end    
     end
    end
    end
end
speedmean = zeros(100,100);
speedvar25 = zeros(100,100);
speedvar75 = zeros(100,100);
speedmean_all = zeros(100,100);
speedvar25_all = zeros(100,100);
speedvar75_all = zeros(100,100);


vecempty = cellfun('isempty',vellist);

for i=1:100
    for j=1:100
        if ~vecempty(i,j)
            speedmean(i,j) = median(vellist{i,j})*6.35/100;
            speedvar25(i,j) = prctile(vellist{i,j},25)*6.35/100;
            speedvar75(i,j) = prctile(vellist{i,j},75)*6.35/100;
        end
    end
end

for i=1:100
    for j=1:100
        if ~vecempty(i,j)
            speedmean_all(i,j) = median(vellist_all{i,j})*6.35/100;
            speedvar25_all(i,j) = prctile(vellist{i,j},25)*6.35/100;
            speedvar75_all(i,j) = prctile(vellist{i,j},75)*6.35/100;
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
plot(meansptime,'rx');