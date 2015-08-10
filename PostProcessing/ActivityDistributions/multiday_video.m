function multiday_video(boxdir, varargin)
%multiday_video writes a video file with name fname to the
%current directory. The video is an animation of all data from dirlist
%Currently runs activity_heat_map, but can be used for any kind of
%analysis.


default = {1, ...
    ['J:\Users\Administrator\Documents\PostProcessingGUIFigures\video',...
    datestr(now, 'mmddyyHHMMSS')]};

tmpdirlist = rdir([boxdir, '\*\*']);
k = 0;
for i = 1:length(tmpdirlist)
    if ~tmpdirlist(i).isdir; break; end;
    dirlist(i) = tmpdirlist(i);
    day = strsplit(dirlist(i).name, '\');
    day = day{end};
    if ~(exist('prevday', 'var') && strcmp(prevday, day))
        k = k+1;
    end
    [thresh2, ~, thresh] ...
            = extract_contingency_info(dirlist(i).name);
    prevday = day;
    if thresh2==30; thresh2 = 33; end;
    radii(k, 1) = thresh2; radii(k, 2) = thresh;

end
offset = 2; %for removing earlier days w/ no data - 0 starts at first day
dirlist = dirlist(1+offset:end);

numvarargs = length(varargin);
if numvarargs > 5
    error('multiday_video: too many arguments (> 3), only one required and two optional.');
end
[default{1:numvarargs}] = varargin{:};
[fr, fname] = default{:};


close all;
writename = strcat( fname,'.avi');
vidobj = VideoWriter(writename, 'Motion JPEG AVI');
vidobj.FrameRate = fr;
open (vidobj);
opengl('software');
set(gcf, 'renderer', 'zbuffer');
fh = figure; 
ax = gca();

statslist = load_stats(dirlist, 2, 'traj_pdf_jstrial');

for i = 1:length(statslist)
    activity_heat_map(statslist(i), 1, [], ax, radii(i, :));
    title(ax, ['Day ', num2str(i+offset)]);
    frame = getframe(fh);
    writeVideo(vidobj, frame);
    clear frame;
    clear stats;
    axes(ax);
    cla;
end
disp(vidobj.FrameCount);
close(vidobj);

end



