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

% Last Modified by GUIDE v2.5 24-Jun-2015 18:03:56

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
function pp_gui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to pp_gui (see VARARGIN)

% Choose default command line output for pp_gui
handles.output = hObject;

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
end

% --- Executes on button press in selectdays.
function selectdays_Callback(hObject, eventdata, handles)
% hObject    handle to selectdays (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
tempdirlist = uipickfiles('filter','K:\DataSync\expt_opto_thal_var_2\', 'output', 'struct');
if ~isempty(tempdirlist)
    [~, ind] = sort({tempdirlist.name});
    handles.dirlist = tempdirlist(ind);
else
try
    %update label of days being plotted;
    labeltxt = '';
    dirlist = handles.dirlist;
    for i = 1:length(dirlist)
        namestr = dirlist(i).name;
        labeltxt = [labeltxt, namestr(end-15:end), ','];
    end
    labeltxt = labeltxt(1:end-2);
    set(handles.daystoplotlabel, 'String', labeltxt);
    
    [statslist, dates] = load_stats(dirlist, 0);
    disp(length(statslist));
    pellets = 0; trialnum = 0;
    for i = 1:length(statslist);
        stats = statslist(i);
        pc = [dates{i},' pellets: ', num2str(stats.pellet_count)];
        sr = [dates{i},' success rate: ', num2str(stats.srate)];
        text = {pc; sr};
        pellets = pellets + stats.pellet_count;
        trialnum = trialnum + stats.trialnum;
        handles = update_console(handles, text);
    end
    if length(statslist > 1)
        pc = ['Total pellets: ', num2str(pellets)];
        sr = ['Overall success rate: ', num2str(pellets/trialnum)];
        text = {pc; sr};
        handles = update_console(handles, text);
    end
catch e
end
guidata(hObject, handles);
end
end

% --- Executes on button press in combinedays.
function combinedays_Callback(hObject, eventdata, handles)
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
