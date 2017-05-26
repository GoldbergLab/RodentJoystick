dataPaths = {'X:\Node5\expt_SPLIT_02\data\Box_1_M_073116_VGAT_056\032217_63_100_030_000_360_000_360_00_CFA_contra\032217',...
    'X:\Node5\expt_SPLIT_02\data\Box_2_M_082116_VGAT_057\032217_63_100_030_000_360_000_360_00_CFA_contra\032217',...
    'X:\Node5\expt_SPLIT_02\data\Box_3_M_082116_VGAT_058\032217_63_100_030_000_360_000_360_00_CFA_contra\032217',...
    'X:\Node5\expt_SPLIT_02\data\Box_4_M_082116_VGAT_059\032217_63_100_030_000_360_000_360_00_CFA_contra\032217'};

dataInd = 3 ; 

savePath = ['F:\lucaDesktop\matlab_code\mouse code\temp\gmm_clustering\Box ' num2str(dataInd) '\'] ; 
saveFlag = true ;

varList = {'maxVel','pathLength', 'duration', 'avgCurvature', 'avgVel_r', 'avgVel_theta','numAccelPeaks', 'netDisp',...
    'avgVel'} ;

k_array = 2:10 ; 
BIC_array = nan(size(k_array)) ; BIC_array_pca = nan(size(k_array)) ;
AIC_array = nan(size(k_array)) ; AIC_array_pca = nan(size(k_array)) ;
gmfit_cell = cell(length(k_array),1) ; gmfit_cell_pca = cell(length(k_array),1) ; 
cluster_diff = nan(size(k_array)) ; 
%dataMat_reach = [] ;
%dataMat_hold = [] ; 
%N_trials_all = [] ; 
options = statset('MaxIter',2000);

pdf_plot_preferences ;

%d = 5 ; %number of principal components to take

featureVectorStruct = importdata([dataPaths{dataInd} '\featureVectorStruct.mat']) ;

%only take rewarded data for now:
%featureVectorStruct = get_tstruct_rw(featureVectorStruct) ;
featureVectorStruct = get_tstruct_laser(featureVectorStruct,0) ;

dataMat = nan(length(featureVectorStruct),length(varList)) ;
for j = 1:length(varList)
    dataMat(:,j) = [featureVectorStruct(:).(varList{j})] ;
end

trialNum = [featureVectorStruct(:).trialNum] ;
afterHold = [featureVectorStruct(:).afterHold] ;
rw = [featureVectorStruct(:).rw] ;

trialNum_diff = diff(trialNum) ;
afterHold_diff = diff(afterHold) ;

reachInd = find(afterHold_diff == 1) + 1 ;
firstSegInd = find(trialNum_diff >= 1 ) + 1;
firstSegInd = [1, firstSegInd] ;

X = dataMat ; 
X(:,4) = log(X(:,4)) ; 

[coeff,score,latent,tsquared,explained,mu] = pca(X,'Centered','on','VariableWeights','variance');
coefforth = inv(diag(std(X)))*coeff;

explain_sum = explained(1) ;
d = 1 ; 
while explain_sum < 95
    d = d+1 ; 
    explain_sum = explain_sum + explained(d) ; 
end

disp(['Percent variation explained by first ' num2str(d) ' principal components:'])
disp(sum(explained(1:d))) ; 

X_pca = score(:,1:d) ; 

cc = 1 ; 
for k = k_array  
    gmfit = fitgmdist(X,k,'CovarianceType','full','SharedCovariance',false,...
        'RegularizationValue',0.1,'Options',options) ; 
    gmfit_pca = fitgmdist(X_pca,k,'CovarianceType','full','SharedCovariance',false,...
        'RegularizationValue',0.1,'Options',options) ; 
    
    [clusterX, ~, P] = cluster(gmfit,X) ; 
    [clusterX_pca, ~, P_pca] = cluster(gmfit_pca,X_pca) ; 
    
    if k > 5 
        subplotRows = 2 ;
        subplotCols = 5 ;
        figPosition = [300   598   1800   650] ;
    else 
        subplotRows = 1 ; 
        subplotCols = k ; 
        figPosition = [300   598   360*k   324] ;
    end
    
    h_repSeg = figure('PaperPositionMode','auto','Position',figPosition) ;
    for m = 1:k
        subplot(subplotRows,subplotCols,m)
        hold on 
        [P_sorted, sortInd] = sort(P(:,m),'descend') ; 
        for mm = 1:20
            traj_x = featureVectorStruct(sortInd(mm)).traj_x ; 
            traj_y = featureVectorStruct(sortInd(mm)).traj_y ; 
            plot(traj_x - traj_x(1),traj_y - traj_y(1),'-','LineWidth',2)
        end
        set(gca, 'fontsize', axisFontSize)
        xlabel('X [mm]','interpreter','latex','fontsize',labelFontSize)
        ylabel('Y [mm]','interpreter','latex','fontsize',labelFontSize)
        title(['Component ' num2str(m) ' ex.'],'interpreter','latex','fontsize',titleFontSize)
        axis equal
        set(gca,'xlim',[-6.35,6.35],'ylim',[-6.35,6.35])
       
    end
    
    h_repSeg_pca = figure('PaperPositionMode','auto','Position',figPosition) ;
    for m = 1:k
        subplot(subplotRows,subplotCols,m)
        hold on 
        [P_pca_sorted, sortInd_pca] = sort(P_pca(:,m),'descend') ; 
        for mm = 1:20
            traj_x = featureVectorStruct(sortInd_pca(mm)).traj_x ; 
            traj_y = featureVectorStruct(sortInd_pca(mm)).traj_y ; 
            plot(traj_x - traj_x(1),traj_y - traj_y(1),'-','LineWidth',2)
        end
        set(gca, 'fontsize', axisFontSize)
        xlabel('X [mm]','interpreter','latex','fontsize',labelFontSize)
        ylabel('Y [mm]','interpreter','latex','fontsize',labelFontSize)
        title(['Component ' num2str(m) ' ex.'],'interpreter','latex','fontsize',titleFontSize)
        axis equal
        set(gca,'xlim',[-6.35,6.35],'ylim',[-6.35,6.35])
        
    end
    
    if saveFlag 
        savefig(h_repSeg, [savePath 'representativeSegs_' num2str(k) '_Comp.fig']) ; 
        savefig(h_repSeg_pca, [savePath 'representativeSegs_' num2str(k) '_Comp_PCA.fig']) ; 
    end
    
    gmfit_cell{cc} = gmfit ; 
    BIC_array(cc) = gmfit.BIC ; 
    AIC_array(cc) = gmfit.AIC ; 
    
    gmfit_cell_pca{cc} = gmfit_pca ; 
    BIC_array_pca(cc) = gmfit_pca.BIC ; 
    AIC_array_pca(cc) = gmfit_pca.AIC ; 
    
    [cluster_diff_temp, cluster_diff_norm_temp] = ...
        compare_gmm_clustering(X,gmfit,X_pca,gmfit_pca) ; 
    if cluster_diff_norm_temp > 1
        keyboard ; 
    end
    cluster_diff(cc) = cluster_diff_norm_temp ; 
    disp(k)
    cc = cc+1 ; 
end

%--------------------------------------------------------------------------

h_princomps = figure('PaperPositionMode','auto','Position',[49 263 1702 366]) ; 
for i = 1:d 
    subplot(1,d,i)
    barh(coefforth(:,i))
    set(gca, 'fontsize', axisFontSize)
    set(gca,'YTick',1:size(coeff,1),'YTickLabel',varList)
    title(['Explained = ' num2str(explained(i))],'interpreter','latex','fontsize',titleFontSize)
end

h_IC = figure('PaperPositionMode','auto') ;
hold on 
h_BIC = plot(k_array,BIC_array,'ko-','MarkerFaceColor','k','LineWidth',1) ; 
h_AIC = plot(k_array,AIC_array,'ko-','MarkerFaceColor','w','LineWidth',1) ;
h_BIC_pca = plot(k_array,BIC_array_pca,'ko--','MarkerFaceColor','k','LineWidth',1) ; 
h_AIC_pca = plot(k_array,AIC_array_pca,'ko--','MarkerFaceColor','w','LineWidth',1) ;
set(gca, 'fontsize', axisFontSize)
xlabel('Number of GMM Comp.','interpreter','latex','fontsize',labelFontSize)
ylabel('Information Criteria','interpreter','latex','fontsize',labelFontSize)
title('Varying Num Comp., All Features','interpreter','latex','fontsize',titleFontSize)
legend([h_BIC, h_BIC_pca, h_AIC, h_AIC_pca],{'BIC', ['BIC w/ PCA' num2str(d)],...
    'AIC', ['AIC w/ PCA' num2str(d)]},'interpreter','latex','location', 'northeast')
axis tight

h_clusterDiff = figure('PaperPositionMode','auto') ;

plot(k_array,cluster_diff,'ko-','MarkerFaceColor',myRed,'LineWidth',1)
set(gca, 'fontsize', axisFontSize)
xlabel('Number of GMM Comp.','interpreter','latex','fontsize',labelFontSize)
ylabel('Percent Diff. in Cluster Membership','interpreter','latex','fontsize',labelFontSize)
title('Comparing PCA vs All Features','interpreter','latex','fontsize',titleFontSize)
axis tight


if saveFlag
   savefig(h_IC, [savePath 'informationCriteria.fig']) ; 
   savefig(h_princomps, [savePath 'prinComps.fig']) ; 
   savefig(h_clusterDiff, [savePath 'clusterDiff.fig']) ; 
end