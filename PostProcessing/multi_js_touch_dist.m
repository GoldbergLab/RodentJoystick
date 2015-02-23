function [set_distances] = multi_js_touch_dist(jslist, hist_int, fignum)
%multi_js_touch_dist generates distance distributions and js_touch_dist
%for multiple days
%   Detailed explanation goes here
plot = figure(fignum);
hold on; 
plot_size = length(jslist);
set_distances = zeros(plot_size, 1);
for i = 1:plot_size
    clear jstruct; clear c; clear dist_distri; clear date; clear set_dist; clear titlestr;
    load(jslist(i).name);
    date = jstruct(2).filename(end-12:end-4);
    stats = xy_getstats(jstruct, [0 inf]); js_touch_dist;
    titlestr = strcat(date, ', js_touch_dist: ', set_dist);
    set_distances(i)=set_dist;
    
    subplot(plot_size,1,i); hold on;
    c = histc(dist_distri,0:hist_int:100);
    stairs(0:hist_int:100, c);
    axis([0, 100, 0]);
    title(titlestr);
    %minor formatting
    if i == plot_size
        xlabel('Joystick Deviation');
    end
    ylabel('Count');
    hold on;
end

end

