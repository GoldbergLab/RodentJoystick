function [] = posmagpdf_thresh(dirlist,maxtime,thresh,compare_flag)

thresh_c = ceil(((thresh/100)*6.35)/0.025);


stats = load_stats(dirlist, 1,1);
stats_l = get_stats_with_trajid(stats,1);
stats_nl = get_stats_with_trajid(stats,2);
[pos_mag_l,pos_hist_l] = posmag_pdf(stats_l,maxtime);
[pos_mag_nl,pos_hist_nl] = posmag_pdf(stats_nl,maxtime);

c = pos_hist_l(thresh_c:end,:);
d = pos_hist_nl(thresh_c:end,:);
pdf_thresh_l = sum(c);
pdf_thresh_nl = sum(d);

figure;plot(pdf_thresh_l,'r');
hold on;
plot(pdf_thresh_nl,'b');
hold off;
%cumsum(pdf_thresh);

