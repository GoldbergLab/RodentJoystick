function [cluster_diff, cluster_diff_norm] = compare_gmm_clustering(X1, gmfit1, X2, gmfit2)

k = gmfit1.NumComponents ; 
[clusterX1, ~, ~] = cluster(gmfit1, X1) ; 
[clusterX2, ~, ~] = cluster(gmfit2, X2) ; 

clusterX1_new = nan(size(clusterX1)) ; 
clusterX2_new = nan(size(clusterX2)) ;

%mahalDist1 = mahal(gmfit1,X1) ; 
%mahalDist2 = mahal(gmfit2,X2) ; 

clusterX1_counts = histcounts(clusterX1) ;
clusterX2_counts = histcounts(clusterX2) ;

[~,I1] = sort(clusterX1_counts) ;
[~,I2] = sort(clusterX2_counts) ;

for i = 1:k
   %mean1 = gmfit1.mu(i,:) ; 
   %mean2 = gmfit2.mu(i,:) ; 
   %[mahalDist_sort, I] = sort(mahalDist1(:,i)) ;
   %clusterVal = median(clusterX1(I(1:100))) ; 
   %[~,ind1] = min(mahalDist1(:,i)) ; 
   %[~,ind2] = min(mahalDist2(:,i)) ; 
   %P1_temp = P1(:,i) ; 
   %P1_temp(~(clusterX1 == i)) = -Inf ; 
   %[~,ind1] = max(P1_temp) ; 
   %ind1 = (clusterX1 == i) & (P1(:,i) > 0.9) ; 
   %[~, clusterVal] = max(mean(P2(ind1,:))) ;
   %new_cluster_ind_1 = find(clusterX1 == clusterX1(ind1)) ; 
   %new_cluster_ind_2 = find(clusterX2 == clusterVal) ; 
   
   
   clusterX1_new(clusterX1 == I1(i)) = i ; 
   clusterX2_new(clusterX2 == I2(i)) = i ; 
   
end

%temp = abs(clusterX1_new - clusterX2_new) ; 
cluster_diff = sum(abs(clusterX1_new-clusterX2_new)>0) ; 
cluster_diff_norm = cluster_diff/length(clusterX1) ; 

end