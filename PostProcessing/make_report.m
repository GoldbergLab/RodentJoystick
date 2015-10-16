function [] = make_report(dirlist)
%generates a grid of figures as a report summary - takes a dirlist as an
%argument
%can be modified in the future, not intended to be a robust script, just to
%make some analysis presentation easier
saveloc = 'J:\Users\Administrator\Documents\PostProcessingGUIFigures';
figure;
for i = 1:9
    axlst(i) = subplot(3, 3, i);
end
combineflag = 0;
plotflag = 1;
np_js_distribution(dirlist, 20, 1, 0, 3, 1, axlst(1));
np_post_distribution(dirlist, 20, 1, 0, 3, 1, axlst(4));
multi_trajectory_analysis(dirlist, 0, 4, [150 600], 0, 5, axlst([2, 3, 5, 6]));

hold_time_distr(dirlist, 20, 1500, combineflag, 3, axlst(7));
multi_js_touch_dist(dirlist, 0.25, 150, 300, combineflag, plotflag, axlst(8));
multi_js_touch_dist(dirlist, 0.25, 30, 300, combineflag, plotflag, axlst(9));



end

