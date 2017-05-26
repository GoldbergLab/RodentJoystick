function [out] = gmm_segments(stats,gm)


stats = get_stats_with_len(stats,50);

stats_l = get_stats_with_trajid(stats,1);
stats_nl = get_stats_with_trajid(stats,2);

seg_mat_l = [stats_l.traj_struct.seginfo];
out = [seg_mat_l.start]<100;
seg_mat_l = seg_mat_l(out);
feat_vect_l = [[seg_mat_l.disp]' [seg_mat_l.dur]' [seg_mat_l.pathlen]' [seg_mat_l.quality]' [seg_mat_l.peakvel]' [seg_mat_l.avgvel]' [seg_mat_l.avgR]'];

[~, feat_vect_l_pca, ~] = pca(feat_vect_l,'Centered','on','VariableWeights','variance');

seg_mat_nl = [stats_nl.traj_struct.seginfo];
out = [seg_mat_nl.start]<100;
seg_mat_nl = seg_mat_nl(out);

feat_vect_nl = [[seg_mat_nl.disp]' [seg_mat_nl.dur]' [seg_mat_nl.pathlen]' [seg_mat_nl.quality]' [seg_mat_nl.peakvel]' [seg_mat_nl.avgvel]' [seg_mat_nl.avgR]'];
[~, feat_vect_nl_pca,~] = pca(feat_vect_nl,'Centered','on','VariableWeights','variance');

 options = statset('MaxIter',2000);
%  for j=1:50
%      for i=1:10
%          gm{i} = gmdistribution.fit(feat_vect_nl,i,'Replicates',1,'CovType','full','SharedCov',false,...
%              'Regularize',0.1,'Options',options);
%          score.aic(i,j) = gm{i}.AIC;
%          score.bic(i,j) = gm{i}.BIC;
%      end
%  end
 
  modelnum = 8;
%   gm = gm{modelnum};
%   gm = gmdistribution.fit(feat_vect_nl,modelnum,'Replicates',1,'CovType','full','SharedCov',false,...
%           'Regularize',0.1,'Options',options);


%      pca_segs = 4;
%   for i=1:10
%     gm_pca = gmdistribution.fit(feat_vect_nl_pca(:,1:4),i,'Replicates',10,'CovType','full','SharedCov',false,...
%         'Regularize',0.1,'Options',options);
%     score(i).aic = gm_pca.AIC;
%     score(i).bic = gm_pca.BIC;
%   end

%       gm_pca = gmdistribution.fit(feat_vect_nl_pca(:,1:4),3,'Replicates',10,'CovType','full','SharedCov',false,...
%         'Regularize',0.1,'Options',options);

  
[clusterL, ~, PL] = cluster(gm,feat_vect_l);
[clusterNL, ~, PNL] = cluster(gm,feat_vect_nl);

for i=1:modelnum
    ratio_vect.l(i) = sum(clusterL==i)/numel(clusterL);
    ratio_vect.nl(i) = sum(clusterNL==i)/numel(clusterNL);
end

% [clusterL, ~, PL] = cluster(gm_pca,feat_vect_l_pca(:,1:pca_segs));
% [clusterNL, ~, PNL] = cluster(gm_pca,feat_vect_nl_pca(:,1:pca_segs));
% 
% ratio_vect.l_pca = [sum(clusterL==1) sum(clusterL==2) sum(clusterL==3) sum(clusterL==4) sum(clusterL==5)]/numel(clusterL);
% ratio_vect.nl_pca = [sum(clusterNL==1) sum(clusterNL==2) sum(clusterNL==3) sum(clusterNL==4) sum(clusterNL==5)]/numel(clusterNL);
figure;
subplotRows = 2;
subplotCols = ceil(modelnum/subplotRows);

    for m = 1:modelnum
        %subplot(subplotRows,subplotCols,m)
        figure
        hold on 
        [P_sorted, sortInd] = sort(PNL(:,m),'descend') ; 
        for mm = 1:10
            traj_x = seg_mat_nl(sortInd(mm)).traj_x ; 
            traj_y = seg_mat_nl(sortInd(mm)).traj_y ; 
            plot(traj_x - traj_x(1),traj_y - traj_y(1),'-','LineWidth',2)
        end
        
        xlabel('X [mm]');
        ylabel('Y [mm]');
        title(['Component ' num2str(m) ' ex.' ' Ratio:' num2str(ratio_vect.l(m)/ratio_vect.nl(m))]);
        axis equal
        set(gca,'xlim',[-6.35,6.35],'ylim',[-6.35,6.35])
        
    end
    
 feat_vect_nl_plot = [feat_vect_nl(:,2) feat_vect_nl(:,3) feat_vect_nl(:,5)];   
 colors = 'rgbk';
 
 model_ind = [1 2 3 4];
 figure
 for i=1:numel(model_ind)
    feat_vect_nl_c = feat_vect_nl_plot((clusterNL==model_ind(i)),:);
    hold on;
    plot3(feat_vect_nl_c(:,1),feat_vect_nl_c(:,2),feat_vect_nl_c(:,3),strcat(colors(i),'x'));
 end
    
 
 out.gm = gm;
 out.feat_vect_l = feat_vect_l;
 out.PNL = PNL;
 out.feat_vect_nl = feat_vect_nl;
 out.PL = PL;
 out.seg_mat_nl = seg_mat_nl;
 out.seg_mat_l = seg_mat_l;
 out.rv = ratio_vect;