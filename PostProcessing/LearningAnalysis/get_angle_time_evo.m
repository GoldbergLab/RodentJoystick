function [f1,f2,out] = get_angle_time_evo(stats)
f1=[];f2=[];out=[];

stats_l = get_stats_with_trajid(stats,1);
stats_l = get_stats_with_len(stats_l,50);
stats_l = get_stats_startatzero(stats_l);


stats_nl = get_stats_with_trajid(stats,2);
stats_nl = get_stats_with_len(stats_nl,50);
stats_nl = get_stats_startatzero(stats_nl);

tstruct = stats_l.traj_struct;
output = arrayfun(@(x) cart2pol(x.vel_x(2:min(200,numel(x.vel_x))),x.vel_y(2:min(200,numel(x.vel_x)))),tstruct,'UniformOutput',false);
try
for i = 1:length(output)    
    temp = output{i};
    output_mat(i,1:201) = NaN;
    output_mat(i,1:numel(temp)) = temp;
    output_mat(i,:) = wrapToPi(output_mat(i,:)+(pi/2));
end

edges = -pi:(pi/30):pi;
for i=1:200
    output_hist(i,:) = histc(output_mat(:,i),edges);
    output_hist(i,:) = smooth(output_hist(i,:)./sum(output_hist(i,:)),5);
    entropy_l(i,:) = -1*output_hist(i,:).*log(output_hist(i,:));
end
angle_evo_l = output_mat;
angle_evo_l_hist = output_hist;
angle_evo_l_entropy = entropy_l;
f1 = figure;
pcolor(output_hist');
set(gca, 'YTick', [1 30 60])
set(gca, 'YTicklabel', {'-180', '   0', ' 180'})
title('Inactivated');
shading flat;
caxis([0 0.1]);
catch
end
clear output_hist output_mat

tstruct = stats_nl.traj_struct;
output = arrayfun(@(x) cart2pol(x.vel_x(2:min(200,numel(x.vel_x))),x.vel_y(2:min(200,numel(x.vel_x)))),tstruct,'UniformOutput',false);

for i = 1:length(output)    
    temp = output{i};
    output_mat(i,1:400) = NaN;
    output_mat(i,1:numel(temp)) = temp;
    output_mat(i,:) = wrapToPi(output_mat(i,:)+(pi/2));
end

edges = -pi:(pi/30):pi;
for i=1:200
    output_hist(i,:) = histc(output_mat(:,i),edges);
    output_hist(i,:) = smooth(output_hist(i,:)./sum(output_hist(i,:)),5);
    entropy_nl(i,:) = -1*output_hist(i,:).*log(output_hist(i,:));
end
angle_evo_nl = output_mat;
angle_evo_nl_hist = output_hist;
angle_evo_nl_entropy = entropy_nl;

f2 = figure;
pcolor(output_hist');
set(gca, 'YTick', [1 30 60])
set(gca, 'YTicklabel', {'-180', '   0', ' 180'})
title('Intact');
shading flat;
caxis([0 0.1]);
try
out.angle_evo_nl = angle_evo_nl;
out.angle_evo_nl_hist = angle_evo_nl_hist;
out.angle_evo_nl_entropy = angle_evo_nl_entropy;
catch
end

try
out.angle_evo_l = angle_evo_l;
out.angle_evo_l_hist = angle_evo_l_hist;
out.angle_evo_l_entropy = angle_evo_l_entropy;
catch
end