function [result] = comp_explo(stat)
k=1;
for i=1:length(stat)
    for j=1:length(stat(i).traj_struct)
       if stat(i).traj_struct(j).max_value>20 
        a(k) = length(stat(i).traj_struct(j).traj_x);
        traj_x = stat(i).traj_struct(j).traj_x;
        traj_y = stat(i).traj_struct(j).traj_y;
        mX_jsoffset = [traj_y' traj_x'];
        
        vYEdge = -100:2:100;
        vXEdge = -100:2:100;
        
        explore(k) = sum(sum(double(hist2d (mX_jsoffset, vYEdge, vXEdge)>0)));           
        k=k+1;
       end
    end
%      figure
%      hist(a,0:10:10000);
    
    ex_means(i) = mean(explore);
    ex_std(i) = std(explore);
    mean_len(i) = mean(a);
    std_len(i) = std(a);
    
    explore=[];
    a = [];
    k=1;
end

result.ex_means = ex_means;
result.ex_std = ex_std;
result.mean_len = mean_len;
result.std_len = std_len;
