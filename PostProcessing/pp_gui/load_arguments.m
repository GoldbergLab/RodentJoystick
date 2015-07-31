function [handles] = load_arguments(hObject, handles, axnum)
%load_arguments alters all relevant labels/default arguments for the axes
%axnum with plotname selected.
contents = cellstr(get(hObject,'String'));
plotname = contents{get(hObject, 'Value')};
function_list = {'Nosepoke Joystick Onset Distribution';
                    'Nosepoke Post Onset Distribution';
                    'Hold Length Distribution (Max)';
                    'Hold Length Distribution (Threshold)';
                    'Hold Time Distribution (Trajectories)';
                    'Rewarded Hold Time Distribution';
                    'Reward Rate by Hold Time Distribution';
                    'Joystick Onset to Reward Distribution';
                    'Nosepoke/Reward Activity Distribution';
                    'Activity Heat Map';
                    'Velocity Heat Map';
                    'Velocity Variation Heat Map';
                    'Acceleration Heat Map';
                    'Acceleration Variation Heat Map';
                    'Angle Distribution (Linear)';
                    'Trajectory Analysis (4)';
                    'Trajectory Analysis (6)'};
arg1 = []; arg2 = []; arg3 = [];
arg1label = '-'; arg2label = '-'; arg3label = '-';
%% MODIFY THIS SECTION TO CHANGE DEFAULT ARGUMENTS/ADD NEW ANALYSIS SCRIPTS
%Labels will be truncated > 8 characters - use the help function to add
%more information.
if strcmp(plotname, 'Nosepoke Joystick Onset Distribution')
    arg1 = '20';
    arg1label = 'Interv'; %Histogram interval (ms)
    arg2 = '1';
    arg2label = 'Normalize'; % normalize plot 
elseif strcmp(plotname, 'Nosepoke Post Onset Distribution')
    arg1 = '20';
    arg1label = 'Interv'; %Histogram interval (ms)
elseif strcmp(plotname, 'Hold Length Distribution (Max)')
    arg1 = '20';
    arg1label = 'Interv'; %Histogram interval (ms)
    arg2 = '0'; 
    arg2label = 'Normalize'; %whether to normalize distributions
elseif strcmp(plotname, 'Hold Length Distribution (Threshold)')
    arg1 = '20'; 
    arg1label = 'Interv'; %Histogram interval (ms)
    arg3 = '50'; 
    arg3label = 'Thresh'; %Distance threshold
    arg2 = '0'; 
    arg2label = 'Normalize'; %whether to normalize distributions
elseif strcmp(plotname, 'Hold Time Distribution (Trajectories)')
    arg1 = '20'; 
    arg1label = 'Interv'; %Histogram interval (ms)
    arg2 = '2000'; 
    arg2label = 'End Time'; %what time range to plot
elseif strcmp(plotname, 'Rewarded Hold Time Distribution')
    arg1 = '50'; 
    arg1label = 'Interv'; %Histogram interval (ms)
    arg2 = '1500'; 
    arg2label = 'End Time'; %what time range to plot
elseif strcmp(plotname, 'Reward Rate by Hold Time Distribution')
    arg1 = '100'; 
    arg1label = 'Interv'; %Histogram interval (ms)
    arg2 = '1200'; 
    arg2label = 'End Time'; %what time range to plot
elseif strcmp(plotname, 'Joystick Onset to Reward Distribution')
    arg1 = '10'; 
    arg1label = 'Interv'; %Histogram interval (ms)
    arg2 = '1200'; 
    arg2label = 'End Time'; %what time range to plot
elseif strcmp(plotname, 'Nosepoke/Reward Activity Distribution')
    arg1 = '20'; 
    arg1label = 'Interv'; %Histogram interval (min)
    arg2 = '0';
    arg2label = 'Normalize';
    arg3 = '0';
    arg3label = 'Rew Only';
elseif strcmp(plotname, 'JS Touch Dist')
    arg1 = '0.25';
    arg1label = 'Rew Rate';
    arg2 = '200';
    arg2label = 'Targ HT';
    arg3 = '50';
    arg3label = 'Thresh';
elseif strcmp(plotname, 'XY Hold Dist')
    arg1 = '0.25';
    arg1label = 'Rew Rate';
    arg2 = '20';
    arg2label = 'Targ. CHT';
elseif strcmp(plotname, 'Activity Heat Map')
    arg1 = '2'; 
    arg1label = 'Bin'; %Bin Size (min)
elseif strcmp(plotname, 'Velocity Heat Map')
    arg1 = '2'; 
    arg1label = 'Bin'; %Bin Size (min)
elseif strcmp(plotname, 'Acceleration Heat Map')
    arg1 = '2'; 
    arg1label = 'Bin'; %Bin Size (min)
elseif strcmp(plotname, 'Acceleration Variation Heat Map')
    arg1 = '2'; 
    arg1label = 'Bin'; %Bin Size (min)
elseif strcmp(plotname, 'Angle Distribution (Linear)')
    arg1 = '25'; 
    arg1label = 'Rew Rate'; %Desired reward rate
    arg2 = '75'; 
    arg2label = 'Thresh'; %Histogram interval (ms)
elseif strcmp(plotname, 'Trajectory Analysis (4)')
    arg1 = '300'; 
    arg1label = 'Start'; %start time;
    arg2 = '900'; 
    arg2label = 'End'; %end time;
elseif strcmp(plotname, 'Trajectory Analysis (6)')
    arg1 = '200'; 
    arg1label = 'Start'; %start time;
    arg2 = '1400'; 
    arg2label = 'End'; %end time;
end

%% GUI Handling/Data manipulation;
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
set(arg1slots(axnum), 'String', arg1);
set(arg2slots(axnum), 'String', arg2);
set(arg3slots(axnum), 'String', arg3);
set(arg1labels(axnum), 'String', arg1label);
set(arg2labels(axnum), 'String', arg2label);
set(arg3labels(axnum), 'String', arg3label);

end


