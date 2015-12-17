function [nppost_pairscount] = multipcolor_np_post(boxdir, offset)
% nppost_pairscount = multipcolor_np_post(boxdir, offset)
%   
%   generates a p color plot showing the nosepoke-post onset
%   distribution for all days in boxdir. offset controls which directory
%   plotting the distribution starts.
%   Uses np_post_distribution
%
% OUTPUTS
%
%   nppost_pairscount :: returns a vector of counts of the number of
%       nosepoke-post pairs used in generating the distribution
%
% ARGUMENTS
%
%   boxdir :: the directory containing all data for a specific mouse
%       Currently can only be one entry (haven't handled cases of switched
%       boxes)
%
%   offset :: sometimes there isn't enough data for the first couple of
%       days to work without failing - in that case, an offset can be given
%       to plot `offset` day_directories after the start - not the same as
%       days - defines a subset of directories
%       To attempt plotting all days' data, set offset to 0.

tmpdirlist = rdir([boxdir, '\*\*']);
for i = 1:length(tmpdirlist)
    if ~tmpdirlist(i).isdir; break; end;
    dirlist(i) = tmpdirlist(i);
end
dirlist = dirlist(offset(1):offset(2));

statslist = load_stats(dirlist, 2, 'np_js_post');
for i = 1:length(statslist)
    nppost_pairscount(i) = length(statslist(i).np_js_post);
end

interv = 100;
norm = 1;
combineflag = 2;
smoothparam = 1;
plotflag = 0;
data = np_post_distribution(dirlist, interv, norm, combineflag, ...
    smoothparam, plotflag); 
accumdata = [];
for i = 1:length(data);
    tmpdata = data{i};
    np_js = tmpdata(:, 2);
    accumdata = [accumdata; np_js'];
end
accumdata = [accumdata; zeros(1, size(accumdata, 2))];
x = -1000:interv:1000;
y = (1:size(accumdata, 1))+offset(1);
figure; ax = gca;
pcolor(ax, x, y, accumdata);
shading flat;
title(ax, 'Nosepoke Aligned Post Contact Distribution');
xlabel(ax, 'Post Onset after Nosepoke (ms)');
ylabel(ax, 'Day');
line([0 0], [0 length(y)+offset(1)], 'LineWidth', 3, 'Color', [0 0 0]);
colorbar;
for i = 1:length(y)
    line([-1000 1000], [i+offset(1) i+offset(1)], 'LineWidth', 0.5, 'Color', [0 0 0]);
end
    
set(ax, 'XTick', -1000:250:1000);

