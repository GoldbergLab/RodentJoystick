function varargout = xy_calib_gui(varargin)
% XY_CALIB_GUI MATLAB code for xy_calib_gui.fig
%      XY_CALIB_GUI, by itself, creates a new XY_CALIB_GUI or raises the existing
%      singleton*.
%
%      H = XY_CALIB_GUI returns the handle to a new XY_CALIB_GUI or the handle to
%      the existing singleton*.
%
%      XY_CALIB_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in XY_CALIB_GUI.M with the given input arguments.
%
%      XY_CALIB_GUI('Property','Value',...) creates a new XY_CALIB_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before xy_calib_gui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to xy_calib_gui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help xy_calib_gui

% Last Modified by GUIDE v2.5 07-May-2014 17:59:14

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @xy_calib_gui_OpeningFcn, ...
                   'gui_OutputFcn',  @xy_calib_gui_OutputFcn, ...
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


% --- Executes just before xy_calib_gui is made visible.
function xy_calib_gui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to xy_calib_gui (see VARARGIN)

samprate = 10000;
s=daq.createSession('ni');
s.DurationInSeconds = 0.1;
s.Rate = samprate;

s.addAnalogInputChannel('Dev2','ai0','Voltage');
s.addAnalogInputChannel('Dev2','ai8','Voltage');

for i=1:2
s.Channels(i).InputType = 'SingleEnded';
end

handles.daq_s = s;
handles.data_struct=[];

% Choose default command line output for xy_calib_gui
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes xy_calib_gui wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = xy_calib_gui_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
s = handles.daq_s;
if s.IsRunning==1
    s.stop;
else
   data = s.startForeground;
end

handles.data_struct = [handles.data_struct data];
axes(handles.axes1)
hold on
plot(mean(data(:,1)),mean(data(:,2)),'rx');
axis square
axis equal
guidata(hObject, handles);

% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
axes(handles.axes1);
cla
handles.data_struct=[];
guidata(hObject, handles);


function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double


% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in checkbox1.
function checkbox1_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox1


% --- Executes on button press in pushbutton_save.
function pushbutton_save_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_save (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
save('calibdata.mat','handles.data_struct');


function edit_chanstr_Callback(hObject, eventdata, handles)
% hObject    handle to edit_chanstr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_chanstr as text
%        str2double(get(hObject,'String')) returns contents of edit_chanstr as a double


% --- Executes during object creation, after setting all properties.
function edit_chanstr_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_chanstr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
s=handles.daq_s;
chan_str=str2num(get(handles.edit_chanstr,'String'));

s.removeChannel(1);s.removeChannel(2);

for i=1:2;
    s.addAnalogInputChannel('Dev2',strcat('ai',num2str(chan_str(i))),'Voltage');   
end

for i=1:2
    s.Channels(i).InputType = 'SingleEnded';
end

guidata(hObject, handles);
