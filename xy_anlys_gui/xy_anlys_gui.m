function varargout = xy_anlys_gui(varargin)
%   This GUI is a tool to analyze individual trajectories. 
%   xy_anlys_gui displays raw data, and allows cycling through individual
%   trajectories.
%   Can be called as xy_anlys_gui
%   xy_anlys_gui('Verbose', 1) will display both error stack traces and
%       occasionally other text information
%
%   OVERVIEW:
%       axes1 - axes5 : have different buttons for selecting raw
%           data/sensor information
%       axes6 : the large center square for plotting a specific trajectory
%           plot_traj_xy is a helper function that handles this task (also
%           updates the trajectory information)
%       axes7 : the smaller bottom axes for plotting a single feature of a
%           specific trajectory.
%           indiv_trajectory_plot is a helper function that handles this
%           task
%
% xy_anlys_gui MATLAB code for xy_anlys_gui.fig
%      xy_anlys_gui, by itself, creates a new xy_anlys_gui or raises the existing
%      singleton*.
%
%      H = xy_anlys_gui returns the handle to a new xy_anlys_gui or the handle to
%      the existing singleton*.
%
%      xy_anlys_gui('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in xy_anlys_gui.M with the given input arguments.
%
%      xy_anlys_gui('Property','Value',...) creates a new xy_anlys_gui or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before xy_anlys_gui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to xy_anlys_gui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help xy_anlys_gui

% Last Modified by GUIDE v2.5 08-Sep-2015 10:35:32

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @xy_anlys_gui_OpeningFcn, ...
                   'gui_OutputFcn',  @xy_anlys_gui_OutputFcn, ...
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


% --- Executes just before xy_anlys_gui is made visible.
function xy_anlys_gui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to xy_anlys_gui (see VARARGIN)

% Choose default command line output for xy_anlys_gui
handles.output = hObject;
axes(handles.axes1); zoom on
axes(handles.axes2); zoom on
axes(handles.axes3); zoom on
axes(handles.axes4); zoom on
axes(handles.axes5); zoom on
linkaxes([handles.axes1 handles.axes2 handles.axes3 handles.axes4 handles.axes5],'x');

axes(handles.axes6); axis equal; 

if nargin<4
    handles.verbose = 0;
else
    handles.verbose = varargin{1, 2};
end

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes xy_anlys_gui wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = xy_anlys_gui_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% --- Executes on button press in selectdir_push.
% callback when a directory is selected
function selectdir_push_Callback(hObject, eventdata, handles)
% hObject    handle to selectdir_push (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
 working_dir = uigetdir;
 handles.working_dir = working_dir;
 set(handles.filelist_box,'Value',1);
 jsloc = [working_dir, '\jstruct.mat'];
 load(jsloc);
 
 handles.jstruct = jstruct;
 day = floor(jstruct(1).real_time);
 
 %populate listbox
 str_list = cell(size(jstruct, 2), 1);
 for i=1:size(jstruct,2)
     str_list{i} = jstruct(i).filename;
 end
 set(handles.filelist_box,'String',str_list);
 set(handles.working_dir_text,'String',working_dir);
 set(handles.date_text, 'String', datestr(day, 'mm/dd/yy'));
 guidata(hObject, handles);

% --- Executes on selection change in filelist_box.
% Callback when a specific .mat file is selected - plot all raw data from
% the jstruct
function filelist_box_Callback(hObject, eventdata, handles)
% hObject    handle to filelist_box (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
struct_index=get(hObject,'Value');
jstruct = handles.jstruct;

set(handles.time_text, 'String', datestr(jstruct(struct_index).real_time, 'HH:MM:SS'));
handles.start_time = jstruct(struct_index).real_time;
 
RADIUS = 6.35;
handles.RADIUS = RADIUS;

raw_x = (jstruct(struct_index).traj_x);
raw_y = (jstruct(struct_index).traj_y);
stats = xy_getstats(jstruct(struct_index));

traj_x = (raw_x)*(RADIUS/100);
traj_y = (raw_y)*(RADIUS/100);
magtraj = sqrt(raw_x.^2 + raw_y.^2).*RADIUS./100;
if(numel(stats.traj_struct))>0
    js_onset = stats.traj_struct(1).js_onset;
    off_time = js_onset + stats.traj_struct(1).rw_or_stop;
    handles.highlight_range = [js_onset off_time];
else
    handles.highlight_range = [0 0];
end

%raw sensor information
np_pairs = jstruct(struct_index).np_pairs;
rw_onset = jstruct(struct_index).reward_onset;
js_pairs_r = jstruct(struct_index).js_pairs_r;
js_pairs_l = jstruct(struct_index).js_pairs_l;
try
    laser_on = jstruct(struct_index).laser_on;
catch
end

samp_rate = 1000;
handles.SAMPLE_RATE = samp_rate;
%axes arguments;
xmin = 1/samp_rate; xmax = length(traj_x)/samp_rate;

np_vect = zeros(1,length(traj_x));
for i=1:size(np_pairs,1)
    np_vect(np_pairs(i,1):np_pairs(i,2))=1;
end

js_vect_l = zeros(1,length(traj_x));
for i=1:size(js_pairs_l,1)
   js_vect_l(js_pairs_l(i,1):js_pairs_l(i,2))=1;
end

js_vect_r = zeros(1,length(traj_x));
for i=1:size(js_pairs_r,1)
   js_vect_r(js_pairs_r(i,1):js_pairs_r(i,2))=1;
end

rw_vect = zeros(1,length(traj_x));
for i=1:size(rw_onset,2)
   rw_vect(rw_onset(i):(rw_onset(i)+50))=1;
end

laser_vect = zeros(1,length(traj_x));
try
    for i=1:size(laser_on,1)
       laser_vect(laser_on(i,1):laser_on(i,2)) = 1;
    end
catch
end

plotdata = [np_vect; js_vect_l; js_vect_r; rw_vect; laser_vect; ...
            magtraj; traj_x; traj_y];
        
handles.plotdata = plotdata;
handles.xaxis = [xmin xmax];

for i = 1:5
    handles = plot_raw_data(handles, i);
end

traj_struct=stats.traj_struct;
handles.traj_struct = traj_struct;
handles.pl_index = ~isempty(traj_struct);

try
    handles = plot_traj_xy(handles);
catch e
    if (handles.verbose); disp(getReport(e)); end    
end

try
    [handles] = indiv_trajectory_plot(handles);
catch e
    if (handles.verbose); disp(getReport(e)); end
end

guidata(hObject, handles);


 

function filelist_box_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
 
%% Individual Trajectory plotting functions
 % --- Executes on button press in prev_plot_button.
function prev_plot_button_Callback(hObject, eventdata, handles)
% hObject    handle to prev_plot_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.pl_index = max(handles.pl_index-1,1);
try
    handles = plot_traj_xy(handles);
catch e
    if (handles.verbose); disp(getReport(e)); end    
end

try
    [handles] = indiv_trajectory_plot(handles);
catch e
    if (handles.verbose); disp(getReport(e)); end
end

guidata(hObject, handles);



% --- Executes on button press in next_plot_button.
function next_plot_button_Callback(hObject, eventdata, handles)
% hObject    handle to next_plot_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.pl_index = min(handles.pl_index+1,numel(handles.traj_struct));
try
    handles = plot_traj_xy(handles);
catch e
    if (handles.verbose); disp(getReport(e)); end    
end

try
    [handles] = indiv_trajectory_plot(handles);
catch e
    if (handles.verbose); disp(getReport(e)); end
end

guidata(hObject, handles);


function selectdir_push_CreateFcn(hObject, eventdata, handles)
function offset_menu_Callback(hObject, eventdata, handles)
try
    handles = plot_traj_xy(handles);
catch e
    if (handles.verbose); disp(getReport(e)); end    
end

try
    [handles] = indiv_trajectory_plot(handles);
catch e
    if (handles.verbose); disp(getReport(e)); end
end


function offset_menu_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
% --- Executes on button press in time_info_checkbox.
function time_info_checkbox_Callback(hObject, eventdata, handles)

function timestep_edit_Callback(hObject, eventdata, handles)
try
    handles = plot_traj_xy(handles);
catch e
    if (handles.verbose); disp(getReport(e)); end    
end

try
    [handles] = indiv_trajectory_plot(handles);
catch e
    if (handles.verbose); disp(getReport(e)); end
end


function timestep_edit_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%% axes 1 callback buttons/functions
function np1_Callback(hObject, eventdata, handles)
    handles = plot_raw_data(handles, 1);
    guidata(hObject, handles);
function post1_Callback(hObject, eventdata, handles)
    handles = plot_raw_data(handles, 1);
    guidata(hObject, handles);
function js1_Callback(hObject, eventdata, handles)
    handles = plot_raw_data(handles, 1);
    guidata(hObject, handles);
function rew1_Callback(hObject, eventdata, handles)
    handles = plot_raw_data(handles, 1);
    guidata(hObject, handles);
function laser1_Callback(hObject, eventdata, handles)
    handles = plot_raw_data(handles, 1);
    guidata(hObject, handles);
function analogmenu1_Callback(hObject, eventdata, handles)
    handles = plot_raw_data(handles, 1);
    guidata(hObject, handles);
function analogmenu1_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function filter1_Callback(hObject, eventdata, handles)
    handles = plot_raw_data(handles, 1);
    guidata(hObject, handles);
% Hints: contents = cellstr(get(hObject,'String')) returns filter1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from filter1
function filter1_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%% axes 2 callback buttons/functions
function np2_Callback(hObject, eventdata, handles)
    handles = plot_raw_data(handles, 2);
    guidata(hObject, handles);
function post2_Callback(hObject, eventdata, handles)
    handles = plot_raw_data(handles, 2);
    guidata(hObject, handles);
function js2_Callback(hObject, eventdata, handles)
    handles = plot_raw_data(handles, 2);
    guidata(hObject, handles);
function rew2_Callback(hObject, eventdata, handles)
    handles = plot_raw_data(handles, 2);
    guidata(hObject, handles);
function laser2_Callback(hObject, eventdata, handles)
    handles = plot_raw_data(handles, 2);
    guidata(hObject, handles);
function analogmenu2_Callback(hObject, eventdata, handles)
    handles = plot_raw_data(handles, 2);
    guidata(hObject, handles);
function analogmenu2_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function filter2_Callback(hObject, eventdata, handles)
    handles = plot_raw_data(handles, 2);
    guidata(hObject, handles);
function filter2_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%% axes 3 callback buttons/functions
function np3_Callback(hObject, eventdata, handles)
    handles = plot_raw_data(handles, 3);
    guidata(hObject, handles);
function post3_Callback(hObject, eventdata, handles)
    handles = plot_raw_data(handles, 3);
    guidata(hObject, handles);
function js3_Callback(hObject, eventdata, handles)
    handles = plot_raw_data(handles, 3);
    guidata(hObject, handles);
function rew3_Callback(hObject, eventdata, handles)
    handles = plot_raw_data(handles, 3);
    guidata(hObject, handles);
function laser3_Callback(hObject, eventdata, handles)
    handles = plot_raw_data(handles, 3);
    guidata(hObject, handles);
function analogmenu3_Callback(hObject, eventdata, handles)
    handles = plot_raw_data(handles, 3);
    guidata(hObject, handles);
function analogmenu3_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function filter3_Callback(hObject, eventdata, handles)
    handles = plot_raw_data(handles, 3);
    guidata(hObject, handles);
function filter3_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%% axes 4 callback buttons/functions
function np4_Callback(hObject, eventdata, handles)
    handles = plot_raw_data(handles, 4);
    guidata(hObject, handles);
function post4_Callback(hObject, eventdata, handles)
    handles = plot_raw_data(handles, 4);
    guidata(hObject, handles);
function js4_Callback(hObject, eventdata, handles)
    handles = plot_raw_data(handles, 4);
    guidata(hObject, handles);
function rew4_Callback(hObject, eventdata, handles)
    handles = plot_raw_data(handles, 4);
    guidata(hObject, handles);
function laser4_Callback(hObject, eventdata, handles)
    handles = plot_raw_data(handles, 4);
    guidata(hObject, handles);
function analogmenu4_Callback(hObject, eventdata, handles)
    handles = plot_raw_data(handles, 4);
    guidata(hObject, handles);
function analogmenu4_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function filter4_Callback(hObject, eventdata, handles)
    handles = plot_raw_data(handles, 4);
    guidata(hObject, handles);
function filter4_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


%% axes5 callback functions
function np5_Callback(hObject, eventdata, handles)
    handles = plot_raw_data(handles, 5);
    guidata(hObject, handles);
function post5_Callback(hObject, eventdata, handles)
    handles = plot_raw_data(handles, 5);
    guidata(hObject, handles);
function js5_Callback(hObject, eventdata, handles)
    handles = plot_raw_data(handles, 5);
    guidata(hObject, handles);
function rew5_Callback(hObject, eventdata, handles)
    handles = plot_raw_data(handles, 5);
    guidata(hObject, handles);
function laser5_Callback(hObject, eventdata, handles)
    handles = plot_raw_data(handles, 5);
    guidata(hObject, handles);
function analogmenu5_Callback(hObject, eventdata, handles)
    handles = plot_raw_data(handles, 5);
    guidata(hObject, handles);
function analogmenu5_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function filter5_Callback(hObject, eventdata, handles)
    handles = plot_raw_data(handles, 5);
    guidata(hObject, handles);
function filter5_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function indivselectplot_Callback(hObject, eventdata, handles)

try
    [handles] = indiv_trajectory_plot(handles);
catch e
    if (handles.verbose); disp(getReport(e)); end
end
guidata(hObject, handles);

function indivselectplot_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

