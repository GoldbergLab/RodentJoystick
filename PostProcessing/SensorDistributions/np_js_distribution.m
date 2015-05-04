function [fh] = np_js_distribution(jstruct, varargin)
%np_js_distribution(jstruct) plots the nose poke joy stick touch
%distribution for the data from a given jstruct

jstruct_stats = xy_getstats(jstruct);
dist_time = -1000:40:1000;
np_js_plot = histc(jstruct_stats.np_js,dist_time);
np_js_plot = np_js_plot./(sum(np_js_plot));
fh = figure;  hold on;
xlabel('Time (ms)'); ylabel('Probability'); title('JS NP distribution');
stairs(dist_time,np_js_plot,'LineWidth',2);
legend(datestr(jstruct(3).real_time, 'mm/dd/yyyy'));
hold on
end

