
for i=1:length(dirlist)
maxtime = 400;
if exist(strcat(dirlist(i).name,'/stats_ts.mat'))
    stats = load_stats(dirlist(i),1,1);
else
    stats = load_stats(dirlist(i),1,0);
end    

stats = get_stats_with_len(stats,50);
stats = get_stats_startatzero(stats);
stats_l = get_stats_with_trajid(stats,1);
stats_nl = get_stats_with_trajid(stats,2);
[pos_l,pos_pdf_l] = posthreshcross_pdf(stats_l,maxtime);
[pos_nl,pos_pdf_nl] = posthreshcross_pdf(stats_nl,maxtime);

edge = ceil(255*0.3);

pos_vect_l(i,:) = sum(pos_pdf_l(77:end,:));
pos_vect_nl(i,:) = sum(pos_pdf_nl(77:end,:));

pos_med_l(i,:) = nanmedian(pos_l,1);
pos_med_nl(i,:) = nanmedian(pos_nl,1);

pos_prc_l = prctile(pos_l,[25 75],1);
pos_prc_nl = prctile(pos_nl,[25 75],1);

pos_diff_l = abs(diff(pos_prc_l,1));
pos_diff_nl = abs(diff(pos_prc_nl,1));

% h(1) = figure;
% plot(pos_med_l,'r');
% hold on;
% plot(pos_med_nl,'b');
% axis([0 maxtime 0 6.35]);
% title('median displacement from center');
% 
% h(2) = figure;
% plot(pos_diff_l,'r');
% hold on;
% plot(pos_diff_nl,'b');
% axis([0 maxtime 0 6.35]);
% title('75-25 prctile displacement from center');
% 
% h(3) = figure;
% plot(pos_vect_l,'r');
% hold on;
% plot(pos_vect_nl,'b');
% axis([0 maxtime 0 1]);
% title('Probability of leaving inner radius of ~2mm');
% 
% exportfigpptx('I:\box4_atmoveout.pptx',h,[1,3]);
% close(h);
end