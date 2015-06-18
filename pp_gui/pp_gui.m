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

% Last Modified by GUIDE v2.5 15-Jun-2015 10:20:33

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


% --- Executes when selected object is changed in daytypeselect.
function daytypeselect_SelectionChangeFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in daytypeselect 
% eventdata  structure with the following fields (see UIBUTTONGROUP)
%	EventName: string 'SelectionChanged' (read only)
%	OldValue: handle of the previously selected object or empty if none was selected
%	NewValue: handle of the currently selected object
% handles    structure with handles and user data (see GUIDATA)
posfunctionarray = {'Nosepoke Joystick Distribution';
        'Nosepoke Post Distribution';
        'NP Joystick and NP Post Distr';
        'Activity Distribution';
        'Hold Time Distributions';
        'Find Sector';
        'Trajectory Analysis (4)';
        'Trajectory Analysis (6)'};
handles.assignedplots = {};
if eventdata.NewValue == handles.singledayselect
    handles.possiblefunctionarray =posfunctionarray;
    set(handles.addday, 'Visible', 'off');
elseif eventdata.NewValue == handles.twodayselect 
    handles.possiblefunctionarray = posfunctionarray(1:6);
    set(handles.addday, 'Visible', 'on');
else
    handles.possiblefunctionarray = posfunctionarray(1:4);
    set(handles.addday, 'Visible', 'on');
end
set(handles.plottingfunctions, 'String', handles.possiblefunctionarray);
%MATLAB doesn't reset listbox index to 1, so you have to manually change the
%selected value of the listbox, or there's an indexing error if value is
%out of range
set(handles.plottingfunctions, 'Value', 1);
guidata(hObject, handles);
end


% --- Executes during object creation, after setting all properties.
function plottingfunctions_CreateFcn(hObject, eventdata, handles)
% hObject    handle to plottingfunctions (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end


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


% --- Executes on selection change in plottingfunctions, updates argument text
function plottingfunctions_Callback(hObject, eventdata, handles)
% hObject    handle to plottingfunctions (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns plottingfunctions contents as cell array
%        contents{get(hObject,'Value')} returns selected item from plottingfunctions
contents = cellstr(get(hObject, 'String'));
plotname = contents{get(hObject, 'Value')};

%0, 1, 2 for single, two, multi day respectively
daytype = 0;
if get(handles.singledayselect, 'Value') == 1
    daytype = 1;
elseif get(handles.twodayselect, 'Value') == 1
    daytype = 2;
elseif get(handles.twodayselect, 'Value') == 1
    daytype = 3;
end


if strcmp(plotname,'Nosepoke Joystick Distribution') || strcmp(plotname,'Nosepoke Post Distribution')
    set(handles.ax1arg1label, 'String', '-');
    set(handles.ax1arg2label, 'String', '-');
    set(handles.ax1arg3label, 'String', '-');
    if (daytype == 1)
        set(handles.axesused, 'String', '1');
    elseif(daytype == 2)
        set(handles.axesused, 'String', '2');
    else
        set(handles.axesused, 'String', '6');
    end    
elseif strcmp(plotname,'Activity Distribution')
    set(handles.ax1arg1label, 'String', 'Interval');
    set(handles.ax1arg2label, 'String', '-');
    set(handles.ax1arg3label, 'String', '-');
    if (daytype == 1)
        set(handles.axesused, 'String', '1');
    elseif(daytype == 2)
        set(handles.axesused, 'String', '2');
    else
        set(handles.axesused, 'String', '6');
    end
elseif strcmp(plotname, 'Hold Time Distributions')
    set(handles.ax1arg1label, 'String', 'Interval');
    set(handles.ax1arg2label, 'String', 'End Time');
    set(handles.ax1arg3label, 'String', '-');
    if (daytype == 1)
        set(handles.axesused, 'String', '3');
    elseif(daytype == 2)
        set(handles.axesused, 'String', '6');
    end
elseif strcmp(plotname, 'Find Sector')
    set(handles.ax1arg1label, 'String', 'Reward Rate');
    set(handles.ax1arg2label, 'String', 'Thresh.');
    set(handles.ax1arg3label, 'String', '-');
    if (daytype == 1)
        set(handles.axesused, 'String', '3');
    elseif(daytype == 2)
        set(handles.axesused, 'String', '6');
    end
elseif strcmp(plotname, 'Trajectory Analysis (4)')
    set(handles.ax1arg1label, 'String', 'Start');
    set(handles.ax1arg2label, 'String', 'End');
    set(handles.ax1arg3label, 'String', '-');
    if (daytype == 1)
        set(handles.axesused, 'String', '4');
    end
elseif strcmp (plotname, 'Trajectory Analysis (6)');
    set(handles.ax1arg1label, 'String', 'Start');
    set(handles.ax1arg2label, 'String', 'End');
    set(handles.ax1arg3label, 'String', '-');
    if (daytype == 1)
        set(handles.axesused, 'String', '6');
    end
else
    set(handles.ax1arg1label, 'String', '-');
    set(handles.ax1arg2label, 'String', '-');
    set(handles.ax1arg3label, 'String', '-');
end
end


% --- Executes on button press in argumentshelp.
function argumentshelp_Callback(hObject, eventdata, handles)
% hObject    handle to argumentshelp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
end

% --- Executes on button press in addfunction.
function addfunction_Callback(hObject, eventdata, handles)
% hObject    handle to addfunction (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
end


% --- Executes on selection change in dateselectionbox.
function dateselectionbox_Callback(hObject, eventdata, handles)
% hObject    handle to dateselectionbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns dateselectionbox contents as cell array
%        contents{get(hObject,'Value')} returns selected item from dateselectionbox
%Only replot if adding a single day - then you can plot immediately;
if get(handles.singledayselect, 'Value') == 1
    contents = cellstr(get(hObject, 'String'));
    datedir = contents{get(hObject, 'Value')};
    set(handles.daystoplotlabel, 'String', datedir);
end
end

% --- Executes during object creation, after setting all properties.
function dateselectionbox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to dateselectionbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
handles.workingdirstring = 'K:\DataSync\expt_opto_thal_var_2';
handles.daystoplotlabel = {};
guidata(hObject, handles);
end


% --- Executes on button press in selectdirbutton.
function selectdirbutton_Callback(hObject, eventdata, handles)
% hObject    handle to selectdirbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
workingdirtemp = uigetdir(handles.workingdirstring);
if workingdirtemp == 0
    workingdirtemp = handles.workingdirstring;
end
set(handles.workingdirlabel, 'String', workingdirtemp);
handles.workingdirstring = workingdirtemp;
filelisting = dir(workingdirtemp);
j = 1;
for i = 1:length(filelisting)
    matcheshidden = length(regexp(filelisting(i).name, '[.].*'));
    if filelisting(i).isdir && ~matcheshidden
        str_list{j} = filelisting(i).name; j=j+1;
    end
end

set(handles.dateselectionbox, 'String', str_list);
set(handles.dateselectionbox, 'Value', 1);
guidata(hObject, handles);
end


% --- Executes on button press in addday.
function addday_Callback(hObject, eventdata, handles)
% hObject    handle to addday (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles structure with handles and user data (see GUIDATA)
contents = cellstr(get(handles.dateselectionbox, 'String'));
datedir = contents{get(handles.dateselectionbox, 'Value')};
set(handles.daystoplotlabel, 'String', datedir);

maxlen = 2;
numdaysadded = length(handles.daystoplotlabel);
daysadded = handles.daystoplotlabel;
if numdaysadded<maxlen
    handles.daystoplotlabel{numdaysadded+1}=datedir;
else
    daysadded = daysadded(2:end);
    
end
end

%This function handles the entire plotting routine
function plot_all_days(handles)


end


% --- Executes on selection change in ax1plotselect.
function ax1plotselect_Callback(hObject, eventdata, handles)
% hObject    handle to ax1plotselect (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns ax1plotselect contents as cell array
%        contents{get(hObject,'Value')} returns selected item from ax1plotselect
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
end


% --- Executes on button press in plotax1.
function plotax1_Callback(hObject, eventdata, handles)
% hObject    handle to plotax1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
end


% --- Executes on selection change in ax2plotselect.
function ax2plotselect_Callback(hObject, eventdata, handles)
% hObject    handle to ax2plotselect (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns ax2plotselect contents as cell array
%        contents{get(hObject,'Value')} returns selected item from ax2plotselect
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
end

% --- Executes on selection change in ax3plotselect.
function ax3plotselect_Callback(hObject, eventdata, handles)
% hObject    handle to ax3plotselect (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns ax3plotselect contents as cell array
%        contents{get(hObject,'Value')} returns selected item from ax3plotselect
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
end

% --- Executes on selection change in ax4plotselect.
function ax4plotselect_Callback(hObject, eventdata, handles)
% hObject    handle to ax4plotselect (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns ax4plotselect contents as cell array
%        contents{get(hObject,'Value')} returns selected item from ax4plotselect
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
end

% --- Executes on selection change in ax5plotselect.
function ax5plotselect_Callback(hObject, eventdata, handles)
% hObject    handle to ax5plotselect (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns ax5plotselect contents as cell array
%        contents{get(hObject,'Value')} returns selected item from ax5plotselect
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
end

% --- Executes on selection change in ax6plotselect.
function ax6plotselect_Callback(hObject, eventdata, handles)
% hObject    handle to ax6plotselect (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns ax6plotselect contents as cell array
%        contents{get(hObject,'Value')} returns selected item from ax6plotselect
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
end