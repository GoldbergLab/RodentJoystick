function [handles] = save_gui_plots(handles)
%helper function that handles all saving routines
axeslst =[handles.axes1; handles.axes2; handles.axes3; handles.axes4; ...
            handles.axes5; handles.axes6];
root = 'J:\Users\GLab\Documents\PostProcessingGUIFigures';
t = now; date = datestr(t, 'mm_dd_yyyy'); time = datestr(t, 'HH_MM_SS');
if ~exist([root,'\',date], 'dir')
    mkdir(root, date);
end
mkdir([root, '\', date], time);
fullpath = [root, '\', date, '\', time];

ext = '.pdf';
if get(handles.saveplotspng, 'Value') == 1
    ext = '.png';
elseif get(handles.saveplotsfig, 'Value')==1
    ext = '.fig';
end

separate = 0;
if separate == 1
    for i = 1:6
    fh = figure;
    copyobj(axeslst(i), fh);
    ax = gca();
    %bunch of random crap you have to do so that figure doesn't display funny
    set(fh, 'Position', [50, 50, 600, 600]);
    set(ax, 'Units', 'normalized');
    set(ax, 'Position', [0.1, 0.1, 0.8, 0.8]);
    
    fname = [fullpath, '\',num2str(i),ext];
    saveas(fh, fname);
    close(fh);
    end
else
    render_visible_items(handles, 'off');
    fname = [fullpath, '\all.pdf'];
    export_fig(handles.figure1, fname);
    render_visible_items(handles, 'on');

end

end

function render_visible_items(handles, state)
    set(handles.uipanel, 'Visible', state);
end
