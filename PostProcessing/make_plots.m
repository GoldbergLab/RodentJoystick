
function [hold_len]=make_plots(list,dist_thresh_ip)
k=1;
np_js_plot = [];
holddist_hist =[];
for i=1:1:length(list)
    load(list(i).name);
    if length(jstruct)>25
        list(i).name
    jstruct_stats = xy_getstats(jstruct,[1 inf]);
    clrstr = 'rgbcmykrgbcmykrgbcmykrgbcmyk';
    
    %%np_js dist
    dist_time = [-1000:40:1000];
    dist_time_p = [-1000:1:1000];
%     if numel(np_js_plot)>0
%         np_js_plot = np_js_plot + histc(jstruct_stats.np_js,dist_time);
%     else
        np_js_plot = histc(jstruct_stats.np_js,dist_time);
%     end
    np_js_plot = np_js_plot./(sum(np_js_plot));
    %np_js_fit = fit(dist_time',np_js_plot,'cubicinterp');
    figure(1)
    xlabel('Time (ms)')
    ylabel('Probability');
    title('JS np distribution');
    stairs(dist_time,np_js_plot,clrstr(k),'LineWidth',2);
    [upperPath, deepestFolder, ~] = fileparts(list(i).name);
    [upperPath, deepestFolder, ~] = fileparts(upperPath);
    s{k} = deepestFolder;
    legend(s,'Interpreter','none');
    hold on
    
    %%np_post dist
    dist_time = [-1000:20:1000];
    dist_time_p = [-1000:5:1000];
    np_post_plot = histc(jstruct_stats.np_js_post,dist_time);
    
    np_post_plot = np_post_plot./(sum(np_post_plot));
    %np_js_fit = fit(dist_time',np_js_plot,'cubicinterp');
    figure(2)
    xlabel('Time (ms)')
    ylabel('Probability');
    title('post NP distribution');
    stairs(dist_time,np_post_plot,clrstr(k),'LineWidth',2);
    legend(s,'Interpreter','none');
    hold on
    
    
    %% Less than 15%
    [hold_len,hold_dist]=xy_holddist(jstruct,dist_thresh_ip,0.75);
    
     holddist_mederror(k,1:3) = prctile(hold_dist,[25 50 75]);
     holddist_mederror(k,4) = mean(hold_dist);

    
    dist_time_hld = 0:10:600;
    holddist_vect = histc(hold_dist,dist_time_hld);
    holddist_vect = holddist_vect; %./(sum(holddist_vect));
%     hold_dist_fit = fit(dist_time_hld',holddist_vect','cubicinterp');
    figure(3)
    xlabel('Time (ms)')
    ylabel('# of trials');
    title('JS first contact hold time at thresh');
    stairs(dist_time_hld, holddist_vect,clrstr(k),'LineWidth',2);
    [upperPath, deepestFolder, ~] = fileparts(list(i).name);
    [upperPath, deepestFolder, ~] = fileparts(upperPath);
    s1{k} = strcat(deepestFolder,' ',num2str(numel(hold_dist)));
    legend(s1,'Interpreter','none');
    hold on
    
    %% everthing
    [hold_len,hold_dist]=xy_holddist(jstruct,150,0.75);
    
%      if numel(holddist_hist)>0
%         holddist_hist = holddist_hist + histc(hold_dist,dist_time_hld);
%      else
     holddist_hist = histc(hold_dist,dist_time_hld); 
%      end
     figure(4)
     
     %holddist_hist = holddist_hist./(sum(holddist_hist));
%     hold_dist_fit = fit(dist_time_hld',holddist_vect','cubicinterp');       
%     
   try
    xlabel('Time (ms)')
    ylabel('# of trials');
    title('JS first contact hold time');
    %stairs(dist_time_hld,holddist_hist);
    stairs(dist_time_hld,holddist_hist,clrstr(k),'LineWidth',2);
    legend(s,'Interpreter','none');
    hold on
   end 
   for ll=1:100
    [dummy_var,hold_dist] = xy_holddist(jstruct,ll,75);
    hold_totaldist(ll,:) = histc(hold_dist,dist_time_hld);
   end
   
    k=k+1;
    end
    
end
    figure(1)
    saveas(gcf,'fig1');
    figure(2)
    saveas(gcf,'fig2');
    figure(3)
    saveas(gcf,'fig3');
    figure(4)
    saveas(gcf,'fig4');
    
%     figure(5)
%     plot(holddist_mederror(:,2),'rx');
%     hold on
%     plot(holddist_mederror(:,3),'ko');
%     plot(holddist_mederror(:,1),'ko');
%     plot(holddist_mederror(:,4),'r');
%     saveas(gcf,'fig5');