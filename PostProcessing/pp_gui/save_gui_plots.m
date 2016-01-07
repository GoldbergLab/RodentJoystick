function [handles] = save_gui_plots(handles)
%helper function that handles all saving routines
axeslst =[handles.axes1; handles.axes2; handles.axes3; handles.axes4; ...
            handles.axes5; handles.axes6];

root = handles.guisavedirloc;

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

if get(handles.saveplotsseparate, 'Value') == 1
    separate = 1;
elseif get(handles.saveplotssingle, 'Value')==1
    separate = 0;
end

if separate
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
    try
        fname = [fullpath, '\all.png'];
        export_fig(handles.figure1, fname, '-m2');
    catch
    end %don't want failed rendering to prevent restoring visibility
    render_visible_items(handles, 'on');
    if get(handles.saveplotssingle, 'Value') == 1
        set(handles.saveplotsfig, 'Visible', 'off');
        set(handles.saveplotspng, 'Value', 1);
    end

end

end

function render_visible_items(handles, state)
arg1slots = [handles.ax1arg1; handles.ax2arg1; handles.ax3arg1; 
                handles.ax4arg1; handles.ax5arg1; handles.ax6arg1];
arg2slots = [handles.ax1arg2; handles.ax2arg2; handles.ax3arg2; 
                handles.ax4arg2; handles.ax5arg2; handles.ax6arg2];
arg3slots = [handles.ax1arg3; handles.ax2arg3; handles.ax3arg3; 
                handles.ax4arg3; handles.ax5arg3; handles.ax6arg3];
arg1labels = [handles.ax1arg1label; handles.ax2arg1label; handles.ax3arg1label; 
                handles.ax4arg1label; handles.ax5arg1label; handles.ax6arg1label];
arg2labels = [handles.ax1arg2label; handles.ax2arg2label; handles.ax3arg2label; 
                handles.ax4arg2label; handles.ax5arg2label; handles.ax6arg2label];
arg3labels = [handles.ax1arg3label; handles.ax2arg3label; handles.ax3arg3label; 
                handles.ax4arg3label; handles.ax5arg3label; handles.ax6arg3label];
plotselectors = [handles.ax1plotselect; handles.ax2plotselect; handles.ax3plotselect;
                handles.ax4plotselect; handles.ax5plotselect;
                handles.ax6plotselect];
plotbuttons = [handles.plotax1; handles.plotax2; handles.plotax3; handles.plotax4; ...
                handles.plotax5; handles.plotax6];
uiobjects = [handles.uipanel; handles.helpbutton; handles.selectdays; handles.text35; ...
                handles.combinedays; handles.saveplotspanel; ...
                handles.saveplotsformat; handles.saveplotspng; handles.saveplotsfig; ...
                handles.saveplotslayout; handles.saveplotsseparate; ...
                handles.saveplotssingle; handles.saveplotspush];
allobj = [arg1slots; arg2slots;arg3slots; arg1labels; arg2labels; arg3labels;
            plotselectors;uiobjects; plotbuttons];
for i = 1:length(allobj)
    set(allobj(i), 'Visible', state);
end
end
