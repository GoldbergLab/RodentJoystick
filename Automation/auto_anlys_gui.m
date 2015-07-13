function varargout = auto_anlys_gui(varargin)
% AUTO_ANLYS_GUI MATLAB code for auto_anlys_gui.fig
%      AUTO_ANLYS_GUI, by itself, creates a new AUTO_ANLYS_GUI or raises the existing
%      singleton*.
%
%      H = AUTO_ANLYS_GUI returns the handle to a new AUTO_ANLYS_GUI or the handle to
%      the existing singleton*.
%
%      AUTO_ANLYS_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in AUTO_ANLYS_GUI.M with the given input arguments.
%
%      AUTO_ANLYS_GUI('Property','Value',...) creates a new AUTO_ANLYS_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before auto_anlys_gui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to auto_anlys_gui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help auto_anlys_gui

% Last Modified by GUIDE v2.5 13-Jul-2015 12:31:22

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @auto_anlys_gui_OpeningFcn, ...
                   'gui_OutputFcn',  @auto_anlys_gui_OutputFcn, ...
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


% --- Executes just before auto_anlys_gui is made visible.
function auto_anlys_gui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to auto_anlys_gui (see VARARGIN)

% Choose default command line output for auto_anlys_gui
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes auto_anlys_gui wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = auto_anlys_gui_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in setexptdir.
function setexptdir_Callback(hObject, eventdata, handles)
% hObject    handle to setexptdir (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function ppschedtime_Callback(hObject, eventdata, handles)
% hObject    handle to ppschedtime (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ppschedtime as text
%        str2double(get(hObject,'String')) returns contents of ppschedtime as a double


% --- Executes during object creation, after setting all properties.
function ppschedtime_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ppschedtime (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in ppstartstop.
function ppstartstop_Callback(hObject, eventdata, handles)
% hObject    handle to ppstartstop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in contstartstop.
function contstartstop_Callback(hObject, eventdata, handles)
% hObject    handle to contstartstop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function contigencyschedtime_Callback(hObject, eventdata, handles)
% hObject    handle to contigencyschedtime (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of contigencyschedtime as text
%        str2double(get(hObject,'String')) returns contents of contigencyschedtime as a double


% --- Executes during object creation, after setting all properties.
function contigencyschedtime_CreateFcn(hObject, eventdata, handles)
% hObject    handle to contigencyschedtime (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit2_Callback(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as a double


% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function newthresh2_Callback(hObject, eventdata, handles)
% hObject    handle to newthresh2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of newthresh2 as text
%        str2double(get(hObject,'String')) returns contents of newthresh2 as a double


% --- Executes during object creation, after setting all properties.
function newthresh2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to newthresh2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function newht1_Callback(hObject, eventdata, handles)
% hObject    handle to newht1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of newht1 as text
%        str2double(get(hObject,'String')) returns contents of newht1 as a double


% --- Executes during object creation, after setting all properties.
function newht1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to newht1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function newminangle1_Callback(hObject, eventdata, handles)
% hObject    handle to newminangle1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of newminangle1 as text
%        str2double(get(hObject,'String')) returns contents of newminangle1 as a double


% --- Executes during object creation, after setting all properties.
function newminangle1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to newminangle1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function newholdthresh1_Callback(hObject, eventdata, handles)
% hObject    handle to newholdthresh1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of newholdthresh1 as text
%        str2double(get(hObject,'String')) returns contents of newholdthresh1 as a double


% --- Executes during object creation, after setting all properties.
function newholdthresh1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to newholdthresh1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function newmaxangle1_Callback(hObject, eventdata, handles)
% hObject    handle to newmaxangle1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of newmaxangle1 as text
%        str2double(get(hObject,'String')) returns contents of newmaxangle1 as a double


% --- Executes during object creation, after setting all properties.
function newmaxangle1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to newmaxangle1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in contautoenable.
function contautoenable_Callback(hObject, eventdata, handles)
% hObject    handle to contautoenable (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of contautoenable





function newht2_Callback(hObject, eventdata, handles)
% hObject    handle to newht2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of newht2 as text
%        str2double(get(hObject,'String')) returns contents of newht2 as a double


% --- Executes during object creation, after setting all properties.
function newht2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to newht2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function newminangle2_Callback(hObject, eventdata, handles)
% hObject    handle to newminangle2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of newminangle2 as text
%        str2double(get(hObject,'String')) returns contents of newminangle2 as a double


% --- Executes during object creation, after setting all properties.
function newminangle2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to newminangle2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function newholdthresh2_Callback(hObject, eventdata, handles)
% hObject    handle to newholdthresh2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of newholdthresh2 as text
%        str2double(get(hObject,'String')) returns contents of newholdthresh2 as a double


% --- Executes during object creation, after setting all properties.
function newholdthresh2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to newholdthresh2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function newmaxangle2_Callback(hObject, eventdata, handles)
% hObject    handle to newmaxangle2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of newmaxangle2 as text
%        str2double(get(hObject,'String')) returns contents of newmaxangle2 as a double


% --- Executes during object creation, after setting all properties.
function newmaxangle2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to newmaxangle2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function newthresh3_Callback(hObject, eventdata, handles)
% hObject    handle to newthresh3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of newthresh3 as text
%        str2double(get(hObject,'String')) returns contents of newthresh3 as a double


% --- Executes during object creation, after setting all properties.
function newthresh3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to newthresh3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function newht3_Callback(hObject, eventdata, handles)
% hObject    handle to newht3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of newht3 as text
%        str2double(get(hObject,'String')) returns contents of newht3 as a double


% --- Executes during object creation, after setting all properties.
function newht3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to newht3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function newminangle3_Callback(hObject, eventdata, handles)
% hObject    handle to newminangle3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of newminangle3 as text
%        str2double(get(hObject,'String')) returns contents of newminangle3 as a double


% --- Executes during object creation, after setting all properties.
function newminangle3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to newminangle3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function newholdthresh3_Callback(hObject, eventdata, handles)
% hObject    handle to newholdthresh3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of newholdthresh3 as text
%        str2double(get(hObject,'String')) returns contents of newholdthresh3 as a double


% --- Executes during object creation, after setting all properties.
function newholdthresh3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to newholdthresh3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function newmaxangle3_Callback(hObject, eventdata, handles)
% hObject    handle to newmaxangle3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of newmaxangle3 as text
%        str2double(get(hObject,'String')) returns contents of newmaxangle3 as a double


% --- Executes during object creation, after setting all properties.
function newmaxangle3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to newmaxangle3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function newthresh4_Callback(hObject, eventdata, handles)
% hObject    handle to newthresh4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of newthresh4 as text
%        str2double(get(hObject,'String')) returns contents of newthresh4 as a double


% --- Executes during object creation, after setting all properties.
function newthresh4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to newthresh4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function newht4_Callback(hObject, eventdata, handles)
% hObject    handle to newht4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of newht4 as text
%        str2double(get(hObject,'String')) returns contents of newht4 as a double


% --- Executes during object creation, after setting all properties.
function newht4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to newht4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function newminangle4_Callback(hObject, eventdata, handles)
% hObject    handle to newminangle4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of newminangle4 as text
%        str2double(get(hObject,'String')) returns contents of newminangle4 as a double


% --- Executes during object creation, after setting all properties.
function newminangle4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to newminangle4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function newholdthresh4_Callback(hObject, eventdata, handles)
% hObject    handle to newholdthresh4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of newholdthresh4 as text
%        str2double(get(hObject,'String')) returns contents of newholdthresh4 as a double


% --- Executes during object creation, after setting all properties.
function newholdthresh4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to newholdthresh4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function newmaxangle4_Callback(hObject, eventdata, handles)
% hObject    handle to newmaxangle4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of newmaxangle4 as text
%        str2double(get(hObject,'String')) returns contents of newmaxangle4 as a double


% --- Executes during object creation, after setting all properties.
function newmaxangle4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to newmaxangle4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function newthresh5_Callback(hObject, eventdata, handles)
% hObject    handle to newthresh5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of newthresh5 as text
%        str2double(get(hObject,'String')) returns contents of newthresh5 as a double


% --- Executes during object creation, after setting all properties.
function newthresh5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to newthresh5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function newht5_Callback(hObject, eventdata, handles)
% hObject    handle to newht5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of newht5 as text
%        str2double(get(hObject,'String')) returns contents of newht5 as a double


% --- Executes during object creation, after setting all properties.
function newht5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to newht5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function newminangle5_Callback(hObject, eventdata, handles)
% hObject    handle to newminangle5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of newminangle5 as text
%        str2double(get(hObject,'String')) returns contents of newminangle5 as a double


% --- Executes during object creation, after setting all properties.
function newminangle5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to newminangle5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function newholdthresh5_Callback(hObject, eventdata, handles)
% hObject    handle to newholdthresh5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of newholdthresh5 as text
%        str2double(get(hObject,'String')) returns contents of newholdthresh5 as a double


% --- Executes during object creation, after setting all properties.
function newholdthresh5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to newholdthresh5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function newmaxangle5_Callback(hObject, eventdata, handles)
% hObject    handle to newmaxangle5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of newmaxangle5 as text
%        str2double(get(hObject,'String')) returns contents of newmaxangle5 as a double


% --- Executes during object creation, after setting all properties.
function newmaxangle5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to newmaxangle5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function newthresh6_Callback(hObject, eventdata, handles)
% hObject    handle to newthresh6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of newthresh6 as text
%        str2double(get(hObject,'String')) returns contents of newthresh6 as a double


% --- Executes during object creation, after setting all properties.
function newthresh6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to newthresh6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function newht6_Callback(hObject, eventdata, handles)
% hObject    handle to newht6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of newht6 as text
%        str2double(get(hObject,'String')) returns contents of newht6 as a double


% --- Executes during object creation, after setting all properties.
function newht6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to newht6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function newminangle6_Callback(hObject, eventdata, handles)
% hObject    handle to newminangle6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of newminangle6 as text
%        str2double(get(hObject,'String')) returns contents of newminangle6 as a double

% --- Executes during object creation, after setting all properties.
function newminangle6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to newminangle6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function newholdthresh6_Callback(hObject, eventdata, handles)
% hObject    handle to newholdthresh6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of newholdthresh6 as text
%        str2double(get(hObject,'String')) returns contents of newholdthresh6 as a double

% --- Executes during object creation, after setting all properties.
function newholdthresh6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to newholdthresh6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function newmaxangle6_Callback(hObject, eventdata, handles)
% hObject    handle to newmaxangle6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of newmaxangle6 as text
%        str2double(get(hObject,'String')) returns contents of newmaxangle6 as a double

% --- Executes during object creation, after setting all properties.
function newmaxangle6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to newmaxangle6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function newthresh7_Callback(hObject, eventdata, handles)
% hObject    handle to newthresh7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of newthresh7 as text
%        str2double(get(hObject,'String')) returns contents of newthresh7 as a double

% --- Executes during object creation, after setting all properties.
function newthresh7_CreateFcn(hObject, eventdata, handles)
% hObject    handle to newthresh7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function newht7_Callback(hObject, eventdata, handles)
% hObject    handle to newht7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of newht7 as text
%        str2double(get(hObject,'String')) returns contents of newht7 as a double

% --- Executes during object creation, after setting all properties.
function newht7_CreateFcn(hObject, eventdata, handles)
% hObject    handle to newht7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function newminangle7_Callback(hObject, eventdata, handles)
% hObject    handle to newminangle7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of newminangle7 as text
%        str2double(get(hObject,'String')) returns contents of newminangle7 as a double

% --- Executes during object creation, after setting all properties.
function newminangle7_CreateFcn(hObject, eventdata, handles)
% hObject    handle to newminangle7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function newholdthresh7_Callback(hObject, eventdata, handles)
% hObject    handle to newholdthresh7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of newholdthresh7 as text
%        str2double(get(hObject,'String')) returns contents of newholdthresh7 as a double

% --- Executes during object creation, after setting all properties.
function newholdthresh7_CreateFcn(hObject, eventdata, handles)
% hObject    handle to newholdthresh7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function newmaxangle7_Callback(hObject, eventdata, handles)
% hObject    handle to newmaxangle7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of newmaxangle7 as text
%        str2double(get(hObject,'String')) returns contents of newmaxangle7 as a double

% --- Executes during object creation, after setting all properties.
function newmaxangle7_CreateFcn(hObject, eventdata, handles)
% hObject    handle to newmaxangle7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function newthresh8_Callback(hObject, eventdata, handles)
% hObject    handle to newthresh8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of newthresh8 as text
%        str2double(get(hObject,'String')) returns contents of newthresh8 as a double

% --- Executes during object creation, after setting all properties.
function newthresh8_CreateFcn(hObject, eventdata, handles)
% hObject    handle to newthresh8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function newht8_Callback(hObject, eventdata, handles)
% hObject    handle to newht8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of newht8 as text
%        str2double(get(hObject,'String')) returns contents of newht8 as a double


% --- Executes during object creation, after setting all properties.
function newht8_CreateFcn(hObject, eventdata, handles)
% hObject    handle to newht8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function newminangle8_Callback(hObject, eventdata, handles)
% hObject    handle to newminangle8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of newminangle8 as text
%        str2double(get(hObject,'String')) returns contents of newminangle8 as a double

% --- Executes during object creation, after setting all properties.
function newminangle8_CreateFcn(hObject, eventdata, handles)
% hObject    handle to newminangle8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function newholdthresh8_Callback(hObject, eventdata, handles)
% hObject    handle to newholdthresh8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of newholdthresh8 as text
%        str2double(get(hObject,'String')) returns contents of newholdthresh8 as a double


% --- Executes during object creation, after setting all properties.
function newholdthresh8_CreateFcn(hObject, eventdata, handles)
% hObject    handle to newholdthresh8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function newmaxangle8_Callback(hObject, eventdata, handles)
% hObject    handle to newmaxangle8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of newmaxangle8 as text
%        str2double(get(hObject,'String')) returns contents of newmaxangle8 as a double


% --- Executes during object creation, after setting all properties.
function newmaxangle8_CreateFcn(hObject, eventdata, handles)
% hObject    handle to newmaxangle8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu1


% --- Executes during object creation, after setting all properties.
function popupmenu1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function oldthresh1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to oldthresh1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
