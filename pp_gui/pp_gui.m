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

% Last Modified by GUIDE v2.5 11-Jun-2015 14:56:35

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
handles.possiblefunctionarray = {};
handles.assignedplots = {};
if eventdata.NewValue == handles.singledayselect
    handles.possiblefunctionarray ={'Nosepoke Joystick Distribution';
        'Nosepoke Post Distribution';
        'Activity Distribution';
        'Hold Time Distributions';
        'Find Sector';
        'Trajectory Analysis (4)';
        'Trajectory Analysis (6)'};
elseif eventdata.NewValue == handles.twodayselect 
    handles.possiblefunctionarray ={'Nosepoke Joystick Distribution';
        'Nosepoke Post Distribution';
        'Activity Distribution';
        'Hold Time Distributions';
        'Find Sector'};
else
    handles.possiblefunctionarray ={'Nosepoke Joystick Distribution';
        'Nosepoke Post Distribution';
        'Activity Distribution'};    
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
function arg1_Callback(hObject, eventdata, handles)
% do nothing
end
% --- Executes during object creation, after setting all properties.
function arg1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to arg1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end
function arg2_Callback(hObject, eventdata, handles)
% do nothing
end
% --- Executes during object creation, after setting all properties.
function arg2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to arg2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end
function arg3_Callback(hObject, eventdata, handles)
% do nothing
end
% --- Executes during object creation, after setting all properties.
function arg3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to arg3 (see GCBO)
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
    daytype = 0;
elseif get(handles.twodayselect, 'Value') == 1
    daytype = 1;
elseif get(handles.twodayselect, 'Value') == 1
    daytype = 2;
end


if strcmp(plotname,'Nosepoke Joystick Distribution') || strcmp(plotname,'Nosepoke Post Distribution')
    set(handles.argname1, 'String', '-');
    set(handles.argname2, 'String', '-');
    set(handles.argname3, 'String', '-');
    if (daytype == 0)
        set(handles.axesused, 'String', '1');
    elseif(daytype == 1)
        set(handles.axesused, 'String', '2');
    else
        set(handles.axesused, 'String', '6');
    end    
elseif strcmp(plotname,'Activity Distribution')
    set(handles.argname1, 'String', 'Interval');
    set(handles.argname2, 'String', '-');
    set(handles.argname3, 'String', '-');
    if (daytype == 0)
        set(handles.axesused, 'String', '1');
    elseif(daytype == 1)
        set(handles.axesused, 'String', '2');
    else
        set(handles.axesused, 'String', '6');
    end
elseif strcmp(plotname, 'Hold Time Distributions')
    set(handles.argname1, 'String', 'Interval');
    set(handles.argname2, 'String', 'End Time');
    set(handles.argname3, 'String', '-');
    if (daytype == 0)
        set(handles.axesused, 'String', '3');
    elseif(daytype == 1)
        set(handles.axesused, 'String', '6');
    end
elseif strcmp(plotname, 'Find Sector')
    set(handles.argname1, 'String', 'Reward Rate');
    set(handles.argname2, 'String', 'Thresh.');
    set(handles.argname3, 'String', '-');
    if (daytype == 0)
        set(handles.axesused, 'String', '3');
    elseif(daytype == 1)
        set(handles.axesused, 'String', '6');
    end
elseif strcmp(plotname, 'Trajectory Analysis (4)')
    set(handles.argname1, 'String', 'Start');
    set(handles.argname2, 'String', 'End');
    set(handles.argname3, 'String', '-');
    if (daytype == 0)
        set(handles.axesused, 'String', '4');
    end
elseif strcmp (plotname, 'Trajectory Analysis (6)');
    set(handles.argname1, 'String', 'Start');
    set(handles.argname2, 'String', 'End');
    set(handles.argname3, 'String', '-');
    if (daytype == 0)
        set(handles.axesused, 'String', '6');
    end
else
    set(handles.argname1, 'String', '-');
    set(handles.argname2, 'String', '-');
    set(handles.argname3, 'String', '-');
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


% --- Executes on selection change in dateselection.
function dateselection_Callback(hObject, eventdata, handles)
% hObject    handle to dateselection (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns dateselection contents as cell array
%        contents{get(hObject,'Value')} returns selected item from dateselection
end

% --- Executes during object creation, after setting all properties.
function dateselection_CreateFcn(hObject, eventdata, handles)
% hObject    handle to dateselection (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
handles.working_dir = genpath('K:\DataSync\expt_opto_thal_var_2');
end


% --- Executes on button press in selectdir.
function selectdir_Callback(hObject, eventdata, handles)
% hObject    handle to selectdir (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA) working_dir = uigetdir;
working_dir = uigetdir(handles.working_dir);
handles.working_dir = working_dir;
set(handles.dateselection,'Value',1);
filelisting = dir(working_dir);
for i=1:size(filelisting,2)
     str_list{i} = filelisting(i).filename;
 end

end
