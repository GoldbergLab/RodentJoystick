function varargout = traj_comp(varargin)
% TRAJ_COMP MATLAB code for traj_comp.fig
%      TRAJ_COMP, by itself, creates a new TRAJ_COMP or raises the existing
%      singleton*.
%
%      H = TRAJ_COMP returns the handle to a new TRAJ_COMP or the handle to
%      the existing singleton*.
%
%      TRAJ_COMP('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in TRAJ_COMP.M with the given input arguments.
%
%      TRAJ_COMP('Property','Value',...) creates a new TRAJ_COMP or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before traj_comp_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to traj_comp_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help traj_comp

% Last Modified by GUIDE v2.5 12-Jun-2014 15:24:12

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @traj_comp_OpeningFcn, ...
                   'gui_OutputFcn',  @traj_comp_OutputFcn, ...
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

% --- Executes just before traj_comp is made visible.
function traj_comp_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to traj_comp (see VARARGIN)

% initialize things
handles.curr_rec_num = 1;
handles.curr_trial_num = 1;
handles.curr_path = -1;
handles.curr_jstruct = -1;
handles.curr_subsamp_ratio = 10;

% setup axes
axes(handles.axes1);
zoom on

% Choose default command line output for traj_comp
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes traj_comp wait for user response (see UIRESUME)
% uiwait(handles.figure1);

% --- Outputs from this function are returned to the command line.
function varargout = traj_comp_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

function path_Callback(hObject, eventdata, handles)
% hObject    handle to path (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of path as text
%        str2double(get(hObject,'String')) returns contents of path as a double
handles.curr_path = get(hObject, 'String');
jstruct_holder = load(handles.curr_path);
handles.curr_jstruct = jstruct_holder.jstruct;
if ~isnumeric(handles.curr_jstruct)
    axes(handles.axes1)
    cla
    axis manual
    axis square
    axis([-100 100 -100 100])
    hold on
    xy_traj_var_samp_rate(handles.curr_jstruct, handles.curr_rec_num, handles.curr_trial_num, 1);
    xy_traj_var_samp_rate(handles.curr_jstruct, handles.curr_rec_num, handles.curr_trial_num, handles.curr_subsamp_ratio);
    hold off
end
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function path_CreateFcn(hObject, eventdata, handles)
% hObject    handle to path (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in trial_incr.
function trial_incr_Callback(hObject, eventdata, handles)
% hObject    handle to trial_incr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.curr_trial_num = handles.curr_trial_num + 1;
set(handles.trial_num, 'String', num2str(handles.curr_trial_num))
if ~isnumeric(handles.curr_jstruct)
    axes(handles.axes1)
    cla
    axis manual
    axis square
    axis([-100 100 -100 100])
    hold on
    xy_traj_var_samp_rate(handles.curr_jstruct, handles.curr_rec_num, handles.curr_trial_num, 1);
    xy_traj_var_samp_rate(handles.curr_jstruct, handles.curr_rec_num, handles.curr_trial_num, handles.curr_subsamp_ratio);
    hold off
end
guidata(hObject, handles);

% --- Executes on button press in trial_decr.
function trial_decr_Callback(hObject, eventdata, handles)
% hObject    handle to trial_decr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.curr_trial_num = max(1, handles.curr_trial_num - 1);
set(handles.trial_num, 'String', num2str(handles.curr_trial_num))
if ~isnumeric(handles.curr_jstruct)
    axes(handles.axes1)
    cla
    axis manual
    axis square
    axis([-100 100 -100 100])
    hold on
    xy_traj_var_samp_rate(handles.curr_jstruct, handles.curr_rec_num, handles.curr_trial_num, 1);
    xy_traj_var_samp_rate(handles.curr_jstruct, handles.curr_rec_num, handles.curr_trial_num, handles.curr_subsamp_ratio);
    hold off
end
guidata(hObject, handles);

function trial_num_Callback(hObject, eventdata, handles)
% hObject    handle to trial_num (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of trial_num as text
%        str2double(get(hObject,'String')) returns contents of trial_num as a double

% --- Executes during object creation, after setting all properties.
function trial_num_CreateFcn(hObject, eventdata, handles)
% hObject    handle to trial_num (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in rec_incr.
function rec_incr_Callback(hObject, eventdata, handles)
% hObject    handle to rec_incr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.curr_rec_num = handles.curr_rec_num + 1;
set(handles.rec_num, 'String', num2str(handles.curr_rec_num))
if ~isnumeric(handles.curr_jstruct)
    axes(handles.axes1)
    cla
    axis manual
    axis square
    axis([-100 100 -100 100])
    hold on
    xy_traj_var_samp_rate(handles.curr_jstruct, handles.curr_rec_num, handles.curr_trial_num, 1);
    xy_traj_var_samp_rate(handles.curr_jstruct, handles.curr_rec_num, handles.curr_trial_num, handles.curr_subsamp_ratio);
    hold off
end
guidata(hObject, handles);

% --- Executes on button press in rec_decr.
function rec_decr_Callback(hObject, eventdata, handles)
% hObject    handle to rec_decr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.curr_rec_num = max(1, handles.curr_rec_num - 1);
set(handles.rec_num, 'String', num2str(handles.curr_rec_num))
if ~isnumeric(handles.curr_jstruct)
    axes(handles.axes1)
    cla
    axis manual
    axis square
    axis([-100 100 -100 100])
    hold on
    xy_traj_var_samp_rate(handles.curr_jstruct, handles.curr_rec_num, handles.curr_trial_num, 1);
    xy_traj_var_samp_rate(handles.curr_jstruct, handles.curr_rec_num, handles.curr_trial_num, handles.curr_subsamp_ratio);
    hold off
end
guidata(hObject, handles);

function rec_num_Callback(hObject, eventdata, handles)
% hObject    handle to rec_num (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of rec_num as text
%        str2double(get(hObject,'String')) returns contents of rec_num as a double


% --- Executes during object creation, after setting all properties.
function rec_num_CreateFcn(hObject, eventdata, handles)
% hObject    handle to rec_num (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function subsamp_ratio_Callback(hObject, eventdata, handles)
% hObject    handle to subsamp_ratio (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of subsamp_ratio as text
%        str2double(get(hObject,'String')) returns contents of subsamp_ratio
%        as a double
handles.curr_subsamp_ratio = max(1, round(str2double(get(hObject, 'String'))));
if ~isnumeric(handles.curr_jstruct)
    axes(handles.axes1)
    cla
    axis manual
    axis square
    axis([-100 100 -100 100])
    hold on
    xy_traj_var_samp_rate(handles.curr_jstruct, handles.curr_rec_num, handles.curr_trial_num, 1);
    xy_traj_var_samp_rate(handles.curr_jstruct, handles.curr_rec_num, handles.curr_trial_num, handles.curr_subsamp_ratio);
    hold off
end
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function subsamp_ratio_CreateFcn(hObject, eventdata, handles)
% hObject    handle to subsamp_ratio (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
