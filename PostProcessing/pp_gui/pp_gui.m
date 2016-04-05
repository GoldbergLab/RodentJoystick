function varargout = pp_gui(varargin)
% PP_GUI MATLAB code for pp_gui.fig
%      PP_GUI, by itself, creates a new PP_GUI or raises the existing
%      singleton*.
%
%      H = PP_GUI returns the handle to a new PP_GUI or the handle to
%      the existing singleton*.
%
%      PP_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PP_GUI.M with the given input arguments.
%
%      PP_GUI('Property','Value',...) creates a new PP_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before pp_gui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to pp_gui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help pp_gui

% Last Modified by GUIDE v2.5 31-Jan-2016 13:49:46

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @pp_gui_OpeningFcn, ...
                   'gui_OutputFcn',  @pp_gui_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT
end

% --- Executes just before pp_gui is made visible.
function pp_gui_OpeningFcn(hObject, eventdata, handles, varargin) %#ok<*INUSL>
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to pp_gui (see VARARGIN)

% Choose default command line output for pp_gui
handles.output = hObject;

axes(handles.axes1); zoom on
axes(handles.axes2); zoom on
axes(handles.axes3); zoom on
axes(handles.axes4); zoom on
axes(handles.axes5); zoom on
axes(handles.axes6); zoom on

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes pp_gui wait for user response (see UIRESUME)
% uiwait(handles.figure1);
end

% --- Outputs from this function are returned to the command line.
function varargout = pp_gui_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
end

%% Day selection buttons/tools
% --- Executes on button press in helpbutton.
function helpbutton_Callback(hObject, eventdata, handles)
% hObject    handle to helpbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
helptxt = {['For more detailed information on how to use the GUI and details about each function, see the wiki: ', ...
    'https://github.com/GoldbergLab/RodentJoystick/wiki, or the function documentation.'], ...
    '',...
    '1. Select directories representing days. "Combine days" combines all data into a single plot.', ...
    ['2. The global plotting parameters affect all (supported) plots.', ...
      ' Smoothing applies a box filter (moving average) to any plots that support smoothing.', ...
      ' Normalize generates a probability distribution instead of raw counts.'], ...
    ['3. If enabled, laser comparison combines data, then splits by laser/catch. ', ...
    'If possible, the resulting plot will be on the same set of axes, otherwise ',...
    'it will be put in the same column (activity heat map).',...
    ' Default is Off.'], ... 
    '4. Select a plot for an axes via the drop down menu.',...
    '5. Change the argument values, if desired.',...
    '',...
    '',...
    'Argument Info:',...
    '',...
    'Interv (Nosepoke Joystick Onset, Nosepoke Post Onset, Hold Length/Time Distributions, Joystick to Reward Onset): Histogram Interval (ms)', ...
    '',...
    'Interv (Nosepoke/Reward Activity Distribution): Histogram Interval (min)', ...
    '',...
    'End Time (Hold Time Distributions - including Rewarded, JS to Reward Onset, Reward Rate): end of time range plotted', ...
    '',...
    'Reward Rate (Angle Distribution): sets the desired reward rate for sector computation (and highlights) - 0 removes highlight', ...
    '',...
    'Thresh (Angle Distribution): only portions of the trajectory with magnitude above thresh will be used to compute angle distribution',...
    '',...
    'Trajectory Analysis: (Start, End) provide the two times marking a range used for Trajectory analysis', ...
    '',...
    ['JS Touch Dist: Traj_id - laser/catch/resampled catch (see get_stats_withtrajid for more info)', ...
    ' Targ HT - target hold time for js touch dist, Thresh - threshold for js touch dist'],...
    '',...
    'Save Plots:',...
    '',...
    'Select a layout: single plots all axes as is (temporarily rendering menus/toolbars invisible) - but requires the export_figs package, separate generates 6 individual figures',...
    'Select a format: .png, or .fig (only supported for saving separate figures)',...
    '',...
    ['If an attempt to save results in an error, you may need to edit the save_gui_plots function. ', ...
    'You only need to edit the line assigning the root directory. Change this to a valid directory if needed.']};

msgbox(helptxt, 'Help');
end

% --- Executes on button press in selectdays.
function selectdays_Callback(hObject, eventdata, handles)
% hObject    handle to selectdays (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
try
    startdir = handles.startdir;
catch
    startdir = 'Z:\data\expt1';
end
tempdirlist = uipickfiles('filter',startdir, 'output', 'struct');
if ~isempty(tempdirlist)
    handles.dirlist = tempdirlist;
try
    %update label of days being plotted;
    labeltxt = '';
    dirlist = handles.dirlist;
    for i = 1:length(dirlist)
        namestr = dirlist(i).name;
        namestr = strsplit(namestr, '\');
        newname = [namestr{end-2},' - ',namestr{end}];
        labeltxt = [labeltxt, newname, ','];
    end
    labeltxt = labeltxt(1:end-1);
    set(handles.daystoplotlabel, 'String', labeltxt);
    startdir = dirlist(end).name; startdir = strsplit(startdir, '\'); 
    startdir = startdir(1:end-1); startdir = strjoin(startdir, '\');
    handles.startdir = startdir;
    to_stop = get(handles.checkbox_ts,'Value');
    
    [statslist, dates] = load_stats(dirlist, 0, to_stop,'pellet_count', ...
        'srate', 'numtraj');
    disp(length(statslist));
    pellets = 0; trialnum = 0;
    text = {};
    for i = 1:length(statslist);
        stats = statslist(i);
        try
        pc = [dates{i},' pellets: ', num2str(stats.pellet_count)];
        sr = [dates{i},' success rate: ', num2str(stats.srate.total)];
        sr_l = [dates{i},' success rate_l: ', num2str(stats.srate.laser_succ)];
        sr_nl = [dates{i},' success rate_nl: ', num2str(stats.srate.catch_succ)];
        nt = [dates{i},' num trials: ', num2str(stats.numtraj)];
        tmptext = {pc; sr; sr_l; sr_nl; nt};
        text = [text; tmptext];
        pellets = pellets + stats.pellet_count;
        trialnum = trialnum + stats.trialnum;
        end
    end
    handles = update_console(handles, text);
    if length(statslist) > 1
        pc = ['Total pellets: ', num2str(pellets)];
        sr = ['Overall success rate: ', num2str(pellets/trialnum)];
        text = {pc; sr};
        handles = update_console(handles, text);
    end
catch e
    disp(getReport(e));
end
guidata(hObject, handles);
end
end

% --- Executes on button press in combinedays.
function combinedays_Callback(hObject, eventdata, handles) %#ok<*INUSD>
% hObject    handle to combinedays (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of combinedays
end


%% General Helper Plotting Functions (loading arguments, plotting routines)
%to just add new analysis functions, change these helper functions (separate files)

%This function handles the entire plotting routine
%function [handles] = plot_all_days(handles, axnum);

%loads arguments
%function [handles] = load_arguments(plotname, handles, axnum)

%general function that will populate the listboxes with functions
%function [obj] = populate_function_list(obj)

%% Specific plotting routines
% these functions should never have code related to performing specific
% plots. Call the general helper functions listed above to avoid copying
% and pasting code/redundancies.
% Each axes i (axes[i]) has several items associated:
%   ax[i]plotselect :: populated by analysis function list on creation,
%       loads arguments on callback
%   ax[i]arg1, ax[i]arg2, ax[i]arg3 :: space for arguments, not affected by
%       callback/change functions of self. changed on callback by
%       ax[i]plotselect to load default arguments
%   ax[i]arg1label, ax[i]arg2label, ax[i]arg3label :: gui text labels for
%       argument spaces. not affected by self callback/create functions -
%       only change on callback to ax[i]plotselect

%Argument Handling - nothing happens here, exist solely to not crash gui
function ax1arg1_Callback(hObject, eventdata, handles)
% do nothing
end
% --- Executes during object creation, after setting all properties.
function ax1arg1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ax1arg1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end
function ax1arg2_Callback(hObject, eventdata, handles)
% do nothing
end
% --- Executes during object creation, after setting all properties.
function ax1arg2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ax1arg2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end
function ax1arg3_Callback(hObject, eventdata, handles)
% do nothing
end
% --- Executes during object creation, after setting all properties.
function ax1arg3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ax1arg3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end

% --- Executes on selection change in ax1plotselect.
function ax1plotselect_Callback(hObject, eventdata, handles)
% hObject    handle to ax1plotselect (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns ax1plotselect contents as cell array
%        contents{get(hObject,'Value')} returns selected item from ax1plotselect
handles = load_arguments(hObject, handles, 1);
guidata(hObject, handles);
end

% --- Executes during object creation, after setting all properties.
function ax1plotselect_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ax1plotselect (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
populate_function_list(hObject);
end


% --- Executes on button press in plotax1.
function plotax1_Callback(hObject, eventdata, handles)
% hObject    handle to plotax1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = plot_all_days(handles, 1);
guidata(hObject, handles);
end


% --- Executes on selection change in ax2plotselect.
function ax2plotselect_Callback(hObject, eventdata, handles)
% hObject    handle to ax2plotselect (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns ax2plotselect contents as cell array
%        contents{get(hObject,'Value')} returns selected item from ax2plotselect
handles = load_arguments(hObject, handles, 2);
guidata(hObject, handles);
end

% --- Executes during object creation, after setting all properties.
function ax2plotselect_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ax2plotselect (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
populate_function_list(hObject);
end


function ax2arg1_Callback(hObject, eventdata, handles)
% hObject    handle to ax2arg1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ax2arg1 as text
%        str2double(get(hObject,'String')) returns contents of ax2arg1 as a double
end

% --- Executes during object creation, after setting all properties.
function ax2arg1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ax2arg1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end


function ax2arg2_Callback(hObject, eventdata, handles)
% hObject    handle to ax2arg2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ax2arg2 as text
%        str2double(get(hObject,'String')) returns contents of ax2arg2 as a double
end

% --- Executes during object creation, after setting all properties.
function ax2arg2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ax2arg2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end


function ax2arg3_Callback(hObject, eventdata, handles)
% hObject    handle to ax2arg3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ax2arg3 as text
%        str2double(get(hObject,'String')) returns contents of ax2arg3 as a double
end

% --- Executes during object creation, after setting all properties.
function ax2arg3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ax2arg3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end

% --- Executes on button press in plotax2.
function plotax2_Callback(hObject, eventdata, handles)
% hObject    handle to plotax2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = plot_all_days(handles, 2);
guidata(hObject, handles);
end

% --- Executes on selection change in ax3plotselect.
function ax3plotselect_Callback(hObject, eventdata, handles)
% hObject    handle to ax3plotselect (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns ax3plotselect contents as cell array
%        contents{get(hObject,'Value')} returns selected item from ax3plotselect
handles = load_arguments(hObject, handles, 3);
guidata(hObject, handles);
end

% --- Executes during object creation, after setting all properties.
function ax3plotselect_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ax3plotselect (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
populate_function_list(hObject);
end


function ax3arg1_Callback(hObject, eventdata, handles)
% hObject    handle to ax3arg1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ax3arg1 as text
%        str2double(get(hObject,'String')) returns contents of ax3arg1 as a double
end

% --- Executes during object creation, after setting all properties.
function ax3arg1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ax3arg1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end


function ax3arg2_Callback(hObject, eventdata, handles)
% hObject    handle to ax3arg2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ax3arg2 as text
%        str2double(get(hObject,'String')) returns contents of ax3arg2 as a double
end

% --- Executes during object creation, after setting all properties.
function ax3arg2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ax3arg2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end


function ax3arg3_Callback(hObject, eventdata, handles)
% hObject    handle to ax3arg3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ax3arg3 as text
%        str2double(get(hObject,'String')) returns contents of ax3arg3 as a double
end

% --- Executes during object creation, after setting all properties.
function ax3arg3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ax3arg3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end

% --- Executes on button press in plotax3.
function plotax3_Callback(hObject, eventdata, handles)
% hObject    handle to plotax3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = plot_all_days(handles, 3);
guidata(hObject, handles);
end

% --- Executes on selection change in ax4plotselect.
function ax4plotselect_Callback(hObject, eventdata, handles)
% hObject    handle to ax4plotselect (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns ax4plotselect contents as cell array
%        contents{get(hObject,'Value')} returns selected item from ax4plotselect
handles = load_arguments(hObject, handles, 4);
guidata(hObject, handles);
end

% --- Executes during object creation, after setting all properties.
function ax4plotselect_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ax4plotselect (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
populate_function_list(hObject);

end


function ax4arg1_Callback(hObject, eventdata, handles)
% hObject    handle to ax4arg1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ax4arg1 as text
%        str2double(get(hObject,'String')) returns contents of ax4arg1 as a double
end

% --- Executes during object creation, after setting all properties.
function ax4arg1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ax4arg1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end


function ax4arg2_Callback(hObject, eventdata, handles)
% hObject    handle to ax4arg2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ax4arg2 as text
%        str2double(get(hObject,'String')) returns contents of ax4arg2 as a double
end

% --- Executes during object creation, after setting all properties.
function ax4arg2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ax4arg2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end


function ax4arg3_Callback(hObject, eventdata, handles)
% hObject    handle to ax4arg3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ax4arg3 as text
%        str2double(get(hObject,'String')) returns contents of ax4arg3 as a double
end

% --- Executes during object creation, after setting all properties.
function ax4arg3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ax4arg3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end

% --- Executes on button press in plotax4.
function plotax4_Callback(hObject, eventdata, handles)
% hObject    handle to plotax4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = plot_all_days(handles, 4);
guidata(hObject, handles);
end

% --- Executes on selection change in ax5plotselect.
function ax5plotselect_Callback(hObject, eventdata, handles)
% hObject    handle to ax5plotselect (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns ax5plotselect contents as cell array
%        contents{get(hObject,'Value')} returns selected item from ax5plotselect
handles = load_arguments(hObject, handles, 5);
guidata(hObject, handles);
end

% --- Executes during object creation, after setting all properties.
function ax5plotselect_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ax5plotselect (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
populate_function_list(hObject);
end


function ax5arg1_Callback(hObject, eventdata, handles)
% hObject    handle to ax5arg1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ax5arg1 as text
%        str2double(get(hObject,'String')) returns contents of ax5arg1 as a double
end

% --- Executes during object creation, after setting all properties.
function ax5arg1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ax5arg1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end


function ax5arg2_Callback(hObject, eventdata, handles)
% hObject    handle to ax5arg2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ax5arg2 as text
%        str2double(get(hObject,'String')) returns contents of ax5arg2 as a double
end

% --- Executes during object creation, after setting all properties.
function ax5arg2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ax5arg2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end


function ax5arg3_Callback(hObject, eventdata, handles)
% hObject    handle to ax5arg3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ax5arg3 as text
%        str2double(get(hObject,'String')) returns contents of ax5arg3 as a double
end

% --- Executes during object creation, after setting all properties.
function ax5arg3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ax5arg3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end

% --- Executes on button press in plotax5.
function plotax5_Callback(hObject, eventdata, handles)
% hObject    handle to plotax5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = plot_all_days(handles, 5);
guidata(hObject, handles);
end

% --- Executes on selection change in ax6plotselect.
function ax6plotselect_Callback(hObject, eventdata, handles)
% hObject    handle to ax6plotselect (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns ax6plotselect contents as cell array
%        contents{get(hObject,'Value')} returns selected item from ax6plotselect
handles = load_arguments(hObject, handles, 6);
guidata(hObject, handles);
end

% --- Executes during object creation, after setting all properties.
function ax6plotselect_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ax6plotselect (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
populate_function_list(hObject);

end
function ax6arg1_Callback(hObject, eventdata, handles)
% hObject    handle to ax6arg1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ax6arg1 as text
%        str2double(get(hObject,'String')) returns contents of ax6arg1 as a double
end
% --- Executes during object creation, after setting all properties.
function ax6arg1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ax6arg1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end
function ax6arg2_Callback(hObject, eventdata, handles)
% hObject    handle to ax6arg2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ax6arg2 as text
%        str2double(get(hObject,'String')) returns contents of ax6arg2 as a double
end
% --- Executes during object creation, after setting all properties.
function ax6arg2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ax6arg2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end
function ax6arg3_Callback(hObject, eventdata, handles)
% hObject    handle to ax6arg3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ax6arg3 as text
%        str2double(get(hObject,'String')) returns contents of ax6arg3 as a double
end
% --- Executes during object creation, after setting all properties.
function ax6arg3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ax6arg3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end

% --- Executes on button press in plotax6.
function plotax6_Callback(hObject, eventdata, handles)
% hObject    handle to plotax6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = plot_all_days(handles, 6);
guidata(hObject, handles);
end

%% Useful utilities for saving and running automated analysis
% --- Executes on button press in saveplotspush.
function saveplotspush_Callback(hObject, eventdata, handles)
% hObject    handle to saveplotspush (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
save_gui_plots(handles);
end


% --- Executes when selected object is changed in saveplotsformat.
function saveplotsformat_SelectionChangeFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in saveplotsformat 
% eventdata  structure with the following fields (see UIBUTTONGROUP)
%	EventName: string 'SelectionChanged' (read only)
%	OldValue: handle of the previously selected object or empty if none was selected
%	NewValue: handle of the currently selected object
% handles    structure with handles and user data (see GUIDATA)

end


% --- Executes during object creation, after setting all properties.
function saveplotsformat_CreateFcn(hObject, eventdata, handles)
% hObject    handle to saveplotsformat (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
end


% --- Executes during object creation, after setting all properties.
function saveplotsseparate_CreateFcn(hObject, eventdata, handles)
% hObject    handle to saveplotsseparate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
end


% --- Executes when selected object is changed in saveplotslayout.
function saveplotslayout_SelectionChangeFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in saveplotslayout 
% eventdata  structure with the following fields (see UIBUTTONGROUP)
%	EventName: string 'SelectionChanged' (read only)
%	OldValue: handle of the previously selected object or empty if none was selected
%	NewValue: handle of the currently selected object
% handles    structure with handles and user data (see GUIDATA)

if get(handles.saveplotssingle, 'Value') == 1
    set(handles.saveplotsfig, 'Visible', 'off');
    set(handles.saveplotsfig, 'Value', 0.0);
    set(handles.saveplotspng, 'Value', 1.0);
elseif get(handles.saveplotsseparate, 'Value')==1
    set(handles.saveplotsfig, 'Visible', 'on');
end

end


% --- Executes on selection change in console.
function console_Callback(hObject, eventdata, handles)
% hObject    handle to console (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns console contents as cell array
%        contents{get(hObject,'Value')} returns selected item from console
end

% --- Executes during object creation, after setting all properties.
function console_CreateFcn(hObject, eventdata, handles)
% hObject    handle to console (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end


% --- Executes on selection change in smoothparam.
function smoothparam_Callback(hObject, eventdata, handles)
% hObject    handle to smoothparam (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns smoothparam contents as cell array
%        contents{get(hObject,'Value')} returns selected item from smoothparam
end

% --- Executes during object creation, after setting all properties.
function smoothparam_CreateFcn(hObject, eventdata, handles)
% hObject    handle to smoothparam (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end


% --- Executes on button press in normalizecheck.
function normalizecheck_Callback(hObject, eventdata, handles)
% hObject    handle to normalizecheck (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of normalizecheck
end


% --- Executes on selection change in lasercomparemenu.
function lasercomparemenu_Callback(hObject, eventdata, handles)
% hObject    handle to lasercomparemenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns lasercomparemenu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from lasercomparemenu
end

% --- Executes during object creation, after setting all properties.
function lasercomparemenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to lasercomparemenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end


% --- Executes on button press in saveguidirloc.
function saveguidirloc_Callback(hObject, eventdata, handles)
% hObject    handle to saveguidirloc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
try
    root = uigetdir(pwd);
catch e
    if (handles.report); disp(getReport(e)); end;
end
if root == 0 
    root = 'C:\Users\GolderbergLab\Documents\PostProcessingGUIFigures';
end
set(handles.saveguidirlabel, 'String', root);
handles.guisavedirloc = root;
guidata(hObject, handles);
end

function rwtrial_check_Callback(hObject, eventdata, handles)
% hObject    handle to lasercomparemenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns lasercomparemenu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from lasercomparemenu
end



% --- Executes on button press in checkbox_ts.
function checkbox_ts_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_ts (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_ts
end