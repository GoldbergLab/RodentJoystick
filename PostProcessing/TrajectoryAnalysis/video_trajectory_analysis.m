%multi_trajectory_analysis writes a video file with name fname to the
%current directory. The video is an animation of all the structs in jslist
%using the script trajectory_analysis to generate plots

function video_trajectory_analysis (jslist, fname, varargin)
default = {1, 10,[400 1400], [300 30 60]};
numvarargs = length(varargin);
if numvarargs > 5
    error('trajectory_analysis: too many arguments (> 3), only one required and two optional.');
end
[default{1:numvarargs}] = varargin{:};
[fr, PLOT_RANGE,TIME_RANGE, CONTL] = default{:};

close all;
writename = strcat( fname,'.avi');
vidobj = VideoWriter(writename, 'Motion JPEG AVI');
vidobj.FrameRate = fr;
open (vidobj);
opengl('software');
set(gcf, 'renderer', 'zbuffer');

for j = 1:length(jslist)
    load(jslist(j).name);
    stats = xy_getstats(jstruct, [0 inf]);
    day = datestr(floor(jstruct(1).real_time));
    [~, fh] = trajectory_analysis(stats,PLOT_RANGE, TIME_RANGE, CONTL, 'plot', day);
    frame = getframe(fh);
    writeVideo(vidobj, frame);
    close all;
    clear jstruct;
    clear stats;
end
disp(vidobj.FrameCount);
hold off;
close(vidobj);
end