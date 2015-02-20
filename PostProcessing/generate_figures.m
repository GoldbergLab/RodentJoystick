function [] = generate_figures(js_stat)
n = length(js_stat);
edges = [-1:0.025:1];
for i=1:length(js_stat)
    np_js(i,:)=histc(js_stat(i).np_js/10000,edges);
    num_pts(i) = sum(np_js(i,:));
    np_js(i,:) = np_js(i,:)./sum(np_js(i,:));    
end

figure;
char_str = 'brgkcmbrgkcy';
subplot(1,2,1);
hold on
title('js');
for i=1:length(js_stat)
    a = smooth(np_js(i,:),5);
    plot(edges(1:end-1),a(1:end-1),char_str(i),'LineWidth',2);
    legend_text{i} = strcat('Day =',num2str(i),',n=',num2str(num_pts(i)));
end

legend(legend_text);

for i=1:length(js_stat)
    np_js(i,:)=histc(js_stat(i).np_js_post/10000,edges);
    np_js(i,:) = np_js(i,:)./sum(np_js(i,:));
end

subplot(1,2,2);
hold on
title('js post');
for i=1:length(js_stat)
    a = smooth(np_js(i,:),5);
    plot(edges(1:end-1),a(1:end-1),char_str(i),'LineWidth',2);
    legend_text{i} = strcat('Day =',num2str(i),',n=',num2str(num_pts(i)));
end

legend(legend_text);
figure;
for i=1:length(js_stat)
    subplot(1,n,i);
    
    pcolor(log(1+js_stat(i).traj_pdf_thindex));
    
    shading interp
%     caxis([0 0.1])
    axis square
    title(strcat('n=',num2str(js_stat(i).numtraj)));
end
figure;
for i=1:length(js_stat)
    subplot(1,n,i);
    
    pcolor(log(1+js_stat(i).traj_pdf_jsoffset));
    shading flat
    caxis([0 0.00001])
    axis square
    title(strcat('n=',num2str(js_stat(i).numtraj)));
end