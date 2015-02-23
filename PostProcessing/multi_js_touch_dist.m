function [] = multi_js_touch_dist(jslist, hist_int, fignum)
%multi_js_touch_dist generates distance distributions and js_touch_dist
%for multiple days
%   Detailed explanation goes here
%plot = figure(fignum);
%hold on; 
plot_size = length(jslist);
set_distances = zeros(1, plot_size);
for i = 1:plot_size
    clear jstruct;
    load(jslist(i).name);
    date = jstruct(2).filename(end-12:end-4);
    disp(strcat('Date: ', date));
    stats = xy_getstats(jstruct, [0 inf]); js_touch_dist;
    titlestr = strcat(date, ', js_touch_dist: ', set_dist);
    set_distances(i)=set_dist;
end

end

