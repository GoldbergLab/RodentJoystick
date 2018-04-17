function varargout = calib_gui(varargin)
%
% calib_gui('Verbose', 1) will have calib_gui print out any errors and
%   the corresponding full stack trace
%   
%   Calib_gui is used for calibrating our joysticks - currently, it is
%   dependent on ppscript, converting recorded data files to .mat files
%   that are loaded into a filelist box.
%   The user can then select the relevant .mat file and the appropriate
%   subsection of the data
%   
%   
% CALIB_GUI MATLAB code for calib_gui.fig
%      CALIB_GUI, by itself, creates a new CALIB_GUI or raises the existing
%      singleton*.
%
%      H = CALIB_GUI returns the handle to a new CALIB_GUI or the handle to
%      the existing singleton*.
%
%      CALIB_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in CALIB_GUI.M with the given input arguments.
%
%      CALIB_GUI('Property','Value',...) creates a new CALIB_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before calib_gui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to calib_gui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help calib_gui

% Last Modified by GUIDE v2.5 03-Dec-2015 12:20:15

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @calib_gui_OpeningFcn, ...
                   'gui_OutputFcn',  @calib_gui_OutputFcn, ...
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


% --- Executes just before calib_gui is made visible.
function calib_gui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to calib_gui (see VARARGIN)

% Choose default command line output for calib_gui
handles.output = hObject;
if nargin<4
    handles.verbose = 0;
else
    handles.verbose = varargin{1, 2};
end
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes calib_gui wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = calib_gui_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function starttime_Callback(hObject, eventdata, handles)
% hObject    handle to starttime (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of starttime as text
%        str2double(get(hObject,'String')) returns contents of starttime as a double


% --- Executes during object creation, after setting all properties.
function starttime_CreateFcn(hObject, eventdata, handles)
% hObject    handle to starttime (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function endtime_Callback(hObject, eventdata, handles)
% hObject    handle to endtime (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of endtime as text
%        str2double(get(hObject,'String')) returns contents of endtime as a double


% --- Executes during object creation, after setting all properties.
function endtime_CreateFcn(hObject, eventdata, handles)
% hObject    handle to endtime (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function handles = plot_data(handles)
working_buff = handles.working_buff;
x = working_buff(:, 1);
y = working_buff(:, 2);
start = str2num(get(handles.starttime, 'String'))*1000;
endtime = str2num(get(handles.endtime, 'String'))*1000;

endtime = min(endtime, length(x));
start = max(min(endtime, start), 1);
x = x(start:endtime);
y = y(start:endtime);
axes(handles.axes1);
plot(x, y, 'b');
axis([-100 100 -100 100]); axis square;
[xc, yc, R] = circfit(x, y);

hold on; 
plot(cos(0:0.02:2*pi)*R + xc, sin(0:0.02:2*pi)*R+yc, 'r');
line([-100 100], [0 0], 'Color', 'k');
line([0 0], [-100 100],'Color', 'k');
line([-100 100], [yc yc], 'Color', 'r');
line([xc xc], [-100 100],'Color', 'r');
hold off;

set(handles.xcenter, 'String', num2str(xc));
set(handles.ycenter, 'String', num2str(yc));
set(handles.radius, 'String', num2str(R));
xrad = max(x) - min(x); 
yrad = max(y) - min(y); 
rratio = min(xrad, yrad)/(max(xrad, yrad));
set(handles.xrad, 'String', num2str(xrad/2));
set(handles.yrad, 'String', num2str(yrad/2));
set(handles.rratio, 'String', num2str(rratio));

% --- Executes on button press in update.
function update_Callback(hObject, eventdata, handles)
% hObject    handle to update (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
try
    plot_data(handles);
catch e
    if handles.verbose; disp(getReport(e)); end;
end



% --- Executes on selection change in matflist.
function matflist_Callback(hObject, eventdata, handles)
% hObject    handle to matflist (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns matflist contents as cell array
%        contents{get(hObject,'Value')} returns selected item from matflist
try
    contents = cellstr(get(hObject, 'String'));
    matfile = contents{get(hObject, 'Value')};
    load([handles.working_dir, '\comb\', matfile]);
    working_buff(:, 1) = medfilt1(working_buff(:, 1)); 
    working_buff(:, 2) = medfilt1(working_buff(:, 2));
    handles.working_buff = working_buff;
    set(handles.working_buff_length, 'String', num2str(length(working_buff)/1000));
    guidata(hObject, handles);
catch e
    if handles.verbose; disp(getReport(e)); end
end

% --- Executes during object creation, after setting all properties.
function matflist_CreateFcn(hObject, eventdata, handles)
% hObject    handle to matflist (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in refresh.
function refresh_Callback(hObject, eventdata, handles)
% hObject    handle to refresh (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
try
    faillist = ppscript(handles.working_dir, '%f %f %s %s %s %s %s %s %s %s', 10);
    datadir = [handles.working_dir, '\comb'];
    dirlist = dir(datadir);
    populate = cell(length(dirlist), 1);
    for i = 1:length(dirlist)
        populate{i, 1} = dirlist(i).name;
    end
    populate = populate(3:end, 1);
    populate = flipud(populate);
    set(handles.matflist, 'Value', 1);
    set(handles.matflist, 'String', populate);
    guidata(hObject, handles);
catch e 
    if handles.verbose; disp(getReport(e)); end;
end


% --- Executes on button press in selectdir.
function selectdir_Callback(hObject, eventdata, handles)
% hObject    handle to selectdir (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.working_dir = uigetdir;
clcrefresh_Callback(hObject, eventdata, handles);
guidata(hObject, handles);


% --- Executes on button press in help.
function help_Callback(hObject, eventdata, handles)
% hObject    handle to help (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

helptxt = {...
    ['This help dialog only has information about how to use calib_gui. '...
    'For information about the overall calibration process.'...
    ' see the wiki at https://github.com/GoldbergLab/RodentJoystick/wiki/Building-a-Joystick-Unit#calibration.'], ...
    '',...
    ['1. To use the gui, first hit "Select Dir" and select the date-contingency folder ',...
    'containing the recorded .dat files. A list of combined .mat sequences will be displayed',...
    ' on the listbox.'], ...
    '',...
    '2. Hit "Refresh" to display newly recorded data in the same folder.'...
    '',...
    ['3. Select a combined .mat sequence from the listbox. Data will be ',...
    'plotted on the axis (axes scales are fixed to [-100, 100]).'],...
    '',...
    ['4. Select a time range (seconds) to plot only desired data.',...
    ' Hit "Update" to redisplay the data and refit the circle.'], ...
    '',...
    ['5. calib_gui automatically attempts to fit a circle, and plots red crosshairs',...
    ' indicating where the joystick needs to move to to be centered. The X ',...
    'and Y radii are the radii along the respective axes. R Ratio is ', ...
    'an approximate measure of the data`s resemblance to a circle, computed by ',...
    'finding the ratio of the X and Y radii (A ratio of 1 suggests a perfect circle).']
    };
msgbox(helptxt);