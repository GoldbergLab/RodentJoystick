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

% Last Modified by GUIDE v2.5 13-Jul-2015 16:37:40

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
exptdir = uipickfiles('output', 'char', 'numFiles', 1);
if ~isempty(exptdir)
    set(handles.exptdirlabel, 'String', exptdir);
    try
        oldtimer = handles.automated_ppanalysis_timer;
        stop(oldtimer);
        delete(oldtimer);
        oldtimer = [];
    catch
    end;
end
guidata(hObject, handles);

function ppschedtime_Callback(hObject, eventdata, handles)
% hObject    handle to ppschedtime (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

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

onoff = get(hObject, 'String');
if strcmp(onoff, 'Start')
    starttime = get(handles.ppschedtime, 'String');
    try
        starttime = strsplit(starttime, ':');
        hours = str2num(starttime{1});
        min = str2num(starttime{2}); %#ok<*ST2NM>
        if length(starttime) ~= 2; 
            error('Bad Time format'); 
        end;
    catch e
        msgbox(getReport(e));
        msgbox('Bad time format in automated analysis start time box. Must be HH:MM (24 hr format)',...
            'Error','error');
        hours = 01; min = 00;
    end
    
    exptdir = get(handles.exptdirlabel, 'String');
    if length(exptdir)<3
        msgbox(['Select an experiment data directory before attempting to ',...
                'start automated analysis.'], 'Error', 'error');
        error('No experiment directory selected.');
    else
        handles.automated_ppanalysis_timer = init_automated_analysis(exptdir, [hours min]);  
        set(hObject, 'String', 'Stop');
    end

elseif strcmp(onoff, 'Stop')
    oldtimer = handles.automated_ppanalysis_timer;
    stop(oldtimer);
    delete(oldtimer);
    handles.automated_ppanalysis_timer = [];
    set(hObject, 'String', 'Start');

else
    error('timer nonexistent, despite having started');
end
guidata(hObject, handles);

%helper to be called for each base directory name
function handles = update_box(handles, boxnum)
contents = get(handles.contdayselect, 'String');
NumDaysCompare = str2num(contents{get(handles.contdayselect, 'Value')});
exptdir = get(handles.exptdirlabel, 'String');
basepath = [exptdir, '\Box_', num2str(boxnum)];
today = floor(now);
dayscompare = [];
for i = 1:30 %how far we're willing to look back for contingency information
    day = rdir([basepath,'\',datestr(today-i, 'mm_dd_yyyy'),'*']);
    if length(day)>0
        dayscompare = [dayscompare; day];
    end
    if length(dayscompare) >= NumDaysCompare; break; end;
end
if length(dayscompare)<1
    error(['Not enough days recently to update contigency automatically',...
            '- must be done manually']);
end

%deal with old contigency info (get right boxes);
thresholds = [handles.oldthresh1, handles.oldthresh2, handles.oldthresh3, ...
                handles.oldthresh4, handles.oldthresh5, handles.oldthresh6,...
                handles.oldthresh7, handles.oldthresh8];
holdtimes = [handles.oldht1, handles.oldht2, handles.oldht3, handles.oldht4, ...
                handles.oldht5, handles.oldht6, handles.oldht7, handles.oldht8];
holdthresh = [handles.oldholdthresh1, handles.oldholdthresh2, handles.oldholdthresh3, ...
                handles.oldholdthresh4, handles.oldholdthresh5, ...
                handles.oldholdthresh6, handles.oldholdthresh7, handles.oldholdthresh8];
minangle = [handles.oldminangle1, handles.oldminangle2, handles.oldminangle3, ...
                handles.oldminangle4, handles.oldminangle5, handles.oldminangle6, ...
                handles.oldminangle7, handles.oldminangle8];
maxangle = [handles.oldmaxangle1, handles.oldmaxangle2, handles.oldmaxangle3, ...
                handles.oldmaxangle4, handles.oldmaxangle5, handles.oldmaxangle6, ...
                handles.oldmaxangle7, handles.oldmaxangle8];
pelletcounts = [handles.pelletcount1, handles.pelletcount2, handles.pelletcount3,...
                    handles.pelletcount4, handles.pelletcount5, handles.pelletcount6, ...
                    handles.pelletcount7, handles.pelletcount8];
srates = [handles.successrate1, handles.successrate2, handles.successrate3,...
            handles.successrate4, handles.successrate5, handles.successrate6,...
            handles.successrate7, handles.successrate8];
npokes = [handles.nosepokecount1, handles.nosepokecount2, handles.nosepokecount3, ...
            handles.nosepokecount4, handles.nosepokecount5, handles.nosepokecount6, ...
            handles.nosepokecount7, handles.nosepokecount8];
trialcount = [handles.trialcount1, handles.trialcount2, handles.trialcount3, ...
                handles.trialcount4, handles.trialcount5, handles.trialcount6, ...
                handles.trialcount7, handles.trialcount8];
thresholdsrec = [handles.newthresh1, handles.newthresh2, handles.newthresh3,...
                    handles.newthresh4, handles.newthresh5, handles.newthresh6,...
                    handles.newthresh7, handles.newthresh8];
holdtimesrec = [handles.newht1, handles.newht2, handles.newht3, handles.newht4, ...
                    handles.newht5, handles.newht6, handles.newht7,...
                    handles.newht8];
holdthreshrec = [handles.newholdthresh1, handles.newholdthresh2,...
                    handles.newholdthresh3, handles.newholdthresh4,...
                    handles.newholdthresh5, handles.newholdthresh6,...
                    handles.newholdthresh7, handles.newholdthresh8];
minanglerec = [handles.newminangle1, handles.newminangle2, handles.newminangle3,...
                handles.newminangle4, handles.newminangle5, handles.newminangle6,...
                handles.newminangle7, handles.newminangle8];
maxanglerec = [handles.newmaxangle1, handles.newmaxangle2, handles.newmaxangle3,...
                handles.newmaxangle4, handles.newmaxangle5, handles.newmaxangle6,...
                handles.newmaxangle7, handles.newmaxangle8];
            
stats = load_stats(dayscompare, 1);
set(pelletcounts(boxnum), 'String', num2str(stats.pellet_count));
set(srates(boxnum), 'String', num2str(stats.srate));
set(npokes(boxnum), 'String', num2str(stats.np_count));
set(trialcount(boxnum), 'String', num2str(stats.trialnum));
[dist, holdtime, centerhold, sector] = recommend_contigencies(handles, dayscompare);
set(thresholdsrec(boxnum), 'String', num2str(dist));
set(holdtimesrec(boxnum), 'String', num2str(holdtime));
set(holdthreshrec(boxnum), 'String', num2str(centerhold));
set(minanglerec(boxnum), 'String', num2str(sector(1)));
set(maxanglerec(boxnum), 'String', num2str(sector(2)));



% --- Executes on button press in contstartstop.
function contstartstop_Callback(hObject, eventdata, handles)
% hObject    handle to contstartstop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
try; handles = update_box(handles, 1); 
catch e
    disp(getReport(e))
end
try; handles = update_box(handles, 2); 
catch e
    disp(getReport(e))
end
try; handles = update_box(handles, 3); end
try; handles = update_box(handles, 4); end
try; handles = update_box(handles, 4); end
guidata(hObject, handles);




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


% --- Executes on button press in contautoenable.
function contautoenable_Callback(hObject, eventdata, handles)
% hObject    handle to contautoenable (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hint: get(hObject,'Value') returns toggle state of contautoenable
if get(hObject, 'Value')
   set(handles.updatecont, 'Visible', 'off');
   set(handles.text4, 'Visible', 'on');
   set(handles.contigencyschedtime, 'Visible', 'on');
   set(handles.contstartstop, 'String', 'Start');
else
   set(handles.updatecont, 'Visible', 'on');
   set(handles.text4, 'Visible', 'off');
   set(handles.contigencyschedtime, 'Visible', 'off');
   set(handles.contstartstop, 'String', 'Recommend');
end


% --- Executes on selection change in contdayselect.
function contdayselect_Callback(hObject, eventdata, handles)
% hObject    handle to contdayselect (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns contdayselect contents as cell array
%        contents{get(hObject,'Value')} returns selected item from contdayselect


% --- Executes during object creation, after setting all properties.
function contdayselect_CreateFcn(hObject, eventdata, handles)
% hObject    handle to contdayselect (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function rewardrate_Callback(hObject, eventdata, handles)
% hObject    handle to rewardrate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of rewardrate as text
%        str2double(get(hObject,'String')) returns contents of rewardrate as a double


% --- Executes during object creation, after setting all properties.
function rewardrate_CreateFcn(hObject, eventdata, handles)
% hObject    handle to rewardrate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in updatecont.
function updatecont_Callback(hObject, eventdata, handles)
% hObject    handle to updatecont (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --- Executes on button press in helpbutton.
function helpbutton_Callback(hObject, eventdata, handles)
% hObject    handle to helpbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

function newthresh1_Callback(hObject, eventdata, handles)
% hObject    handle to newthresh1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of newthresh1 as text
%        str2double(get(hObject,'String')) returns contents of newthresh1 as a double


% --- Executes during object creation, after setting all properties.
function newthresh1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to newthresh1 (see GCBO)
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
function newmaxangle8_CreateFcn(hObject, eventdata, handles) %#ok<*INUSD>
% hObject    handle to newmaxangle8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function oldthresh1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to oldthresh1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
