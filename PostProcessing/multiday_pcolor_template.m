function multiday_pcolor(dirlist)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

interv = 100;
data = np_js_distribution(dirlist, interv, 1, 2, 1, 0);
accumdata = [];
for i = 1:length(data);
    tmpdata = data{i};
    np_js = tmpdata(:, 2);
    accumdata = [accumdata; np_js'];
end
x = -1000:interv:1000;
y = 1:size(accumdata, 1);
pcolor(x, y, accumdata);
shading flat;
line([0 0], [0 20], 'LineWidth', 3, 'Color', [0 0 0]);

