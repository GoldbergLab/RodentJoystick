function varargout = motor_primitives(varargin)
% MOTOR_PRIMITIVES MATLAB code for motor_primitives.fig
%      MOTOR_PRIMITIVES, by itself, creates a new MOTOR_PRIMITIVES or raises the existing
%      singleton*.
%
%      H = MOTOR_PRIMITIVES returns the handle to a new MOTOR_PRIMITIVES or the handle to
%      the existing singleton*.
%
%      MOTOR_PRIMITIVES('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MOTOR_PRIMITIVES.M with the given input arguments.
%
%      MOTOR_PRIMITIVES('Property','Value',...) creates a new MOTOR_PRIMITIVES or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before motor_primitives_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to motor_primitives_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help motor_primitives

% Last Modified by GUIDE v2.5 05-Nov-2015 11:37:23

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @motor_primitives_OpeningFcn, ...
                   'gui_OutputFcn',  @motor_primitives_OutputFcn, ...
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


% --- Executes just before motor_primitives is made visible.
function motor_primitives_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to motor_primitives (see VARARGIN)

% Choose default command line output for motor_primitives
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes motor_primitives wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = motor_primitives_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function timestepinput_Callback(hObject, eventdata, handles)
% hObject    handle to timestepinput (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of timestepinput as text
%        str2double(get(hObject,'String')) returns contents of timestepinput as a double


% --- Executes during object creation, after setting all properties.
function timestepinput_CreateFcn(hObject, eventdata, handles)
% hObject    handle to timestepinput (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in trajectoryselect.
function trajectoryselect_Callback(hObject, eventdata, handles)
% hObject    handle to trajectoryselect (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns trajectoryselect contents as cell array
%        contents{get(hObject,'Value')} returns selected item from trajectoryselect


% --- Executes during object creation, after setting all properties.
function trajectoryselect_CreateFcn(hObject, eventdata, handles)
% hObject    handle to trajectoryselect (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in selectstats.
function selectstats_Callback(hObject, eventdata, handles)
% hObject    handle to selectstats (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
statsloc = uigetdir(pwd);

guidata(hObject, handles);

function populate_plot_selector(hObject)
    plotlist = {'Radius of Curvature'; ...
                'Speed'; ...
                'Tangential Acceleration'; ...
                'Normal Acceleration'; ...
                'Tangential/Normal Accel'};
    set(hObject, 'String', plotlist);


% --- Executes on selection change in ax4select.
function ax4select_Callback(hObject, eventdata, handles)
% hObject    handle to ax4select (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns ax4select contents as cell array
%        contents{get(hObject,'Value')} returns selected item from ax4select


% --- Executes during object creation, after setting all properties.
function ax4select_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ax4select (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
populate_plot_selector(hObject);
set(hObject, 'Value', 1);

% --- Executes on selection change in ax5select.
function ax5select_Callback(hObject, eventdata, handles)
% hObject    handle to ax5select (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns ax5select contents as cell array
%        contents{get(hObject,'Value')} returns selected item from ax5select


% --- Executes during object creation, after setting all properties.
function ax5select_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ax5select (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
populate_plot_selector(hObject);
set(hObject, 'Value', 2);


% --- Executes on selection change in ax6select.
function ax6select_Callback(hObject, eventdata, handles)
% hObject    handle to ax6select (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns ax6select contents as cell array
%        contents{get(hObject,'Value')} returns selected item from ax6select


% --- Executes during object creation, after setting all properties.
function ax6select_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ax6select (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
populate_plot_selector(hObject);
set(hObject, 'Value', 5);


% --- Executes on selection change in ax8select.
function ax8select_Callback(hObject, eventdata, handles)
% hObject    handle to ax8select (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns ax8select contents as cell array
%        contents{get(hObject,'Value')} returns selected item from ax8select


% --- Executes during object creation, after setting all properties.
function ax8select_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ax8select (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
populate_plot_selector(hObject);
set(hObject, 'Value', 1);


% --- Executes on selection change in ax9select.
function ax9select_Callback(hObject, eventdata, handles)
% hObject    handle to ax9select (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns ax9select contents as cell array
%        contents{get(hObject,'Value')} returns selected item from ax9select


% --- Executes during object creation, after setting all properties.
function ax9select_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ax9select (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
populate_plot_selector(hObject);
set(hObject, 'Value', 2);



% --- Executes on selection change in ax10select.
function ax10select_Callback(hObject, eventdata, handles)
% hObject    handle to ax10select (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns ax10select contents as cell array
%        contents{get(hObject,'Value')} returns selected item from ax10select


% --- Executes during object creation, after setting all properties.
function ax10select_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ax10select (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
populate_plot_selector(hObject);
set(hObject, 'Value', 5);


% --- Executes on button press in prevsegment.
function prevsegment_Callback(hObject, eventdata, handles)
% hObject    handle to prevsegment (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in nextsegment.
function nextsegment_Callback(hObject, eventdata, handles)
% hObject    handle to nextsegment (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
