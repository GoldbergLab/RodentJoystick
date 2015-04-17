
function [hold_len]=make_plots(list,dist_thresh_ip)
k=1;
for i=1:1:length(list)
load(list(i).name);
if length(jstruct)>25
    disp(list(i).name)
    jstruct_stats = xy_getstats(jstruct,[1 inf]);
    clrstr = 'rgbcmykrgbcmykrgbcmykrgbcmyk';
    
    %%np_js dist
    dist_time = -1000:40:1000;
    np_js_plot = histc(jstruct_stats.np_js,dist_time);
    np_js_plot = np_js_plot./(sum(np_js_plot));
    figure(1)
    xlabel('Time (ms)'); ylabel('Probability'); title('JS NP distribution');
    stairs(dist_time,np_js_plot,clrstr(k),'LineWidth',2);
    s{k} = datestr(jstruct(3).real_time, 'mm/dd/yyyy');
    legend(s,'Interpreter','none');
    hold on
    
    %%np_post dist
    dist_time = -1000:20:1000;
    np_post_plot = histc(jstruct_stats.np_js_post,dist_time);
    np_post_plot = np_post_plot./(sum(np_post_plot));
    %np_js_fit = fit(dist_time',np_js_plot,'cubicinterp');
    figure(2); xlabel('Time (ms)'); ylabel('Probability');
    title('Post NP distribution');
    stairs(dist_time,np_post_plot,clrstr(k),'LineWidth',2);
    legend(s,'Interpreter','none');
    hold on
    
    
    %% Less than 15%
    [~,hold_dist]=xy_holddist(jstruct,dist_thresh_ip,0.75);
    
    holddist_mederror(k,1:3) = prctile(hold_dist,[25 50 75]);
    holddist_mederror(k,4) = mean(hold_dist);
    dist_time_hld = 0:10:600;
    holddist_vect = histc(hold_dist,dist_time_hld);
    figure(3)
    xlabel('Time (ms)'); ylabel('# of trials');
    title('JS first contact hold time at thresh');
    stairs(dist_time_hld, holddist_vect,clrstr(k),'LineWidth',2);
    s1{k} = strcat(s{k},' ',num2str(numel(hold_dist)));
    legend(s1,'Interpreter','none');
    hold on
    
    %% everthing
    [hold_len,hold_dist]=xy_holddist(jstruct,150,0.75);
    holddist_hist = histc(hold_dist,dist_time_hld); 
    figure(4)
    try
        xlabel('Time (ms)'); ylabel('# of trials'); 
        title('JS first contact hold time');
        stairs(dist_time_hld,holddist_hist,clrstr(k),'LineWidth',2);
        legend(s,'Interpreter','none');
        hold on
    catch
    end 
    for ll=1:100
        [~,hold_dist] = xy_holddist(jstruct,ll,75);
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
end

%     figure(5)
%     plot(holddist_mederror(:,2),'rx');
%     hold on
%     plot(holddist_mederror(:,3),'ko');
%     plot(holddist_mederror(:,1),'ko');
%     plot(holddist_mederror(:,4),'r');
%     saveas(gcf,'fig5');