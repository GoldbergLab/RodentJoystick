
function [hold_len]=make_plots(list,dist_thresh_ip)
k=1;

figure(1); ax1 = gca();
%np_js_distribution/np_post_distribution(jslist [interv, combineflag, plotflag, ax])
disp('Nosepoke Joystick Touch Distribution');
np_js_distribution(list, 30, 0, 1, ax1);
disp('Nosepoke Post Distribution');
figure(2); ax2 = gca();
np_post_distribution(list, 30, 0, 1, ax2);

clrstr = 'rgbkmcyrgbkmcyrgbkmcy';

for i=1:1:length(list)
load(list(i).name);
holddist_mederror = zeros(5, 4);
if length(jstruct)>25
    disp(list(i).name)
    s{k} = datestr(jstruct(3).real_time, 'mm/dd/yyyy');
  
    %% Less than 15%
    [~,hold_dist]=xy_holddist(jstruct,dist_thresh_ip,0.75);
    
    holddist_mederror(k,1:3) = prctile(hold_dist,[25 50 75]);
    holddist_mederror(k,4) = mean(hold_dist);
    dist_time_hld = 0:10:600;
    holddist_vect = histc(hold_dist,dist_time_hld);
    figure(3)
    stairs(dist_time_hld, holddist_vect,clrstr(k),'LineWidth',2);
    xlabel('Time (ms)'); ylabel('# of trials');
    title('JS first contact hold time at thresh');
    s1{k} = strcat(s{k},' (',num2str(numel(hold_dist)), ')');
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
%     for ll=1:100
%         [~,hold_dist] = xy_holddist(jstruct,ll,75);
%         hold_totaldist(ll,:) = histc(hold_dist,dist_time_hld);
%     end
    k=k+1;
end
end
    %figure(1)
    %saveas(gcf,'fig1');
    %figure(2)
    %saveas(gcf,'fig2');
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