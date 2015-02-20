function varargout = xy_anlys_gui(varargin)
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

% Last Modified by GUIDE v2.5 26-Mar-2014 14:26:27

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
axes(handles.axes1);
zoom on
axes(handles.axes2);
zoom on
axes(handles.axes3);
zoom on
axes(handles.axes4);
zoom on
axes(handles.axes5);
zoom on
linkaxes([handles.axes1 handles.axes2 handles.axes3 handles.axes4 handles.axes5 handles.axes7],'x');

axes(handles.axes6);
axis equal; 

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


% --- Executes on selection change in filelist_box.
function filelist_box_Callback(hObject, eventdata, handles)
% hObject    handle to filelist_box (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
 contents = cellstr(get(hObject,'String'));
 struct_index=get(hObject,'Value');
 jstruct = handles.jstruct;
 windowSize = 20;
%  fid = fopen(strcat(handles.working_dir,'\',filename));
%  date = fread(fid,1,'double');
%  handles.working_buff = fread(fid,[4 11000],'double');
%  fclose(fid)
 
 
 %data =  load(strcat(handles.working_dir,'\',filename));
 
%    handles.working_buff = data.working_buff;
 
 traj_x = jstruct(struct_index).traj_x;
 traj_y = jstruct(struct_index).traj_y;
 np_pairs = jstruct(struct_index).np_pairs;
 rw_onset = jstruct(struct_index).reward_onset;
 js_pairs_r = jstruct(struct_index).js_pairs_r;
 js_pairs_l = jstruct(struct_index).js_pairs_l;
 
 js_reward = jstruct(struct_index).js_reward;
 
 
%     traj_x = filter(ones(1,windowSize)/windowSize,1,traj_x);
%     traj_y = filter(ones(1,windowSize)/windowSize,1,traj_y);
%     traj_x = traj_x(20:end-20);
%     traj_y = traj_y(20:end-20);
    
samp_rate = 1000; 

 xmin = 1/samp_rate;
 xmax = length(traj_x)/samp_rate;
 ymin = 0;
 ymax = 5;
 
%  x_cen=jstruct.xcen;%handles.working_buff(1,end);
%  y_cen=jstruct.ycen;%handles.working_buff(2,end);

 np_vect = zeros(1,length(traj_x));
 for i=1:size(np_pairs,1)
    np_vect(np_pairs(i,1):np_pairs(i,2))=4;
 end
 
 rw_vect = zeros(1,length(traj_x));
 for i=1:size(rw_onset,2)
    rw_vect(rw_onset(i):(rw_onset(i)+50))=4;
 end
 
 js_vect_r = zeros(1,length(traj_x));
 for i=1:size(js_pairs_r,1)
    js_vect_r(js_pairs_r(i,1):js_pairs_r(i,2))=4;
 end
 js_vect_l = zeros(1,length(traj_x));
 for i=1:size(js_pairs_l,1)
    js_vect_l(js_pairs_l(i,1):js_pairs_l(i,2))=4;
 end
 
 
 %xlen = length(handles.working_buff);
 
 str_ls = 'bgrcmykbgrcmyk';

 axes(handles.axes1)
 cla
 plot(handles.axes1,(1/samp_rate):(1/samp_rate):xmax,traj_x,'k','LineWidth',2);
 axis(handles.axes1,[xmin xmax -100 100])
 
 axes(handles.axes2)
 cla
 plot(handles.axes2,(1/samp_rate):(1/samp_rate):xmax,traj_y,'k','LineWidth',2);
 axis(handles.axes2,[xmin xmax -100 100])
 
 axes(handles.axes3)
 cla
 plot(handles.axes3,(1/samp_rate):(1/samp_rate):xmax,np_vect,'r','LineWidth',2);
 axis(handles.axes3,[xmin xmax ymin ymax])
 
 axes(handles.axes4)
 cla
 plot(handles.axes4,(1/samp_rate):(1/samp_rate):xmax,rw_vect,'k','LineWidth',2);
 axis(handles.axes4,[xmin xmax ymin 6])
 
 axes(handles.axes5)
 cla
 plot(handles.axes5,(1/samp_rate):(1/samp_rate):xmax,((traj_x).^2+(traj_y).^2).^(0.5),'LineWidth',2)
 axis(handles.axes5,[xmin xmax  0 110]);
 hold on
 plot(handles.axes5,(1/samp_rate):(1/samp_rate):xmax,js_vect_r*10,'k','LineWidth',2);
 plot(handles.axes5,(1/samp_rate):(1/samp_rate):xmax,js_vect_l*15,'r','LineWidth',2);
 
 axes(handles.axes7)
 cla
 plot(handles.axes7,(1/samp_rate):(1/samp_rate):xmax,js_vect_r,'k','LineWidth',2);
 hold on
 plot(handles.axes7,(1/samp_rate):(1/samp_rate):xmax,js_vect_l/0.8,'r','LineWidth',2);
 axis(handles.axes7,[xmin xmax ymin 6])
  
 set(handles.date_text,'String',datestr(jstruct(struct_index).date_time));
 
 axes(handles.axes6);
 cla
 axis manual
 
 hold on
 thresh = str2num(get(handles.threshold_edit,'String'));
 rw_fr = str2num(get(handles.rw_zone_fr,'String'));
 rw_to = str2num(get(handles.rw_zone_to,'String'));
 
 x = thresh*cosd(1:1:360);
 y = thresh*sind(1:1:360);
 
 plot(x,y,'k','LineWidth',2);
 plot(x(rw_fr:rw_to),y(rw_fr:rw_to),'c','LineWidth',2);
%  axis([-0.8 0.8 -0.8 0.8])
 
 traj_struct=[];
 
 start_p=[];
 k=0;
 
 if numel(js_pairs_r)>0 && numel(np_pairs)>0
     for j=1:size(js_pairs_r,1)
         %check if js movement happens in between nosepokes
         if(sum(((np_pairs(:,1)-js_pairs_r(j,1))<0)&((np_pairs(:,2)-js_pairs_r(j,1))>0))>0)
             c = (np_pairs(:,1)-js_pairs_r(j,1))<0;
             start_p_temp = start_p;
             start_p = max(np_pairs(c,1));
             start_i = max(start_p,js_pairs_r(j,1)-1000);
             np_end = np_pairs((np_pairs(c,1)==start_p),2);
             stop_p = min(js_pairs_r(j,2),np_end);
             if (numel(start_p)>0) && ~isequaln(start_p_temp,start_p)                
                 traj_x_t = traj_x(start_i:stop_p);
                 traj_y_t = traj_y(start_i:stop_p);
                 js_post = js_vect_l((js_pairs_r(j,1)):(stop_p))>2;             
                  if ((traj_x(start_p)^2+traj_y(start_p)^2)^(0.5))<10
                     mag_traj = ((traj_x_t.^2+traj_y_t.^2).^(0.5));
                     above_thresh=mag_traj>thresh;
                     a=find(above_thresh);
                     if numel(a)<1
                         a = find(mag_traj==max(mag_traj));
                     end
                     k=k+1;
%                      if (js_reward(j))
%                          if numel(a)>0
%                              plot(traj_x_t(1:a(1)),-1*traj_y_t(1:a(1)),'r');                             
%                              plot(traj_x_t(1:200:a(1)),-1*traj_y_t(1:200:a(1)),'ro');
%                              axes(handles.axes1)
%                              hold on
%                              plot((start_p:(start_p+a(1)-1))/10000,traj_x_t(1:a(1)),'r','LineWidth',2);
%                              axes(handles.axes2)
%                              hold on
%                              plot((start_p:(start_p+a(1)-1))/10000,traj_y_t(1:a(1)),'r','LineWidth',2);
%                              axes(handles.axes6);
%                          end
%                      else
%                          if numel(a)>0
%                              
%                              plot(traj_x_t(1:a(1)),-1*traj_y_t(1:a(1)),'b');
%                              plot(traj_x_t(1:200:a(1)),-1*traj_y_t(1:200:a(1)),'bo');
%                              
%                          end
%                      end
%                      plot(traj_x_t(1),traj_y_t(1),'rx');
%                      axis([-0.8 0.8 -0.8 0.8])
                     
                       traj_struct(k).traj_x = traj_x_t;
                       traj_struct(k).traj_y = traj_y_t;
                       traj_struct(k).js_post = js_post;
                       traj_struct(k).start_p = start_p;
                       traj_struct(k).stop_p = stop_p;
                       traj_struct(k).rw = js_reward(j);
                       traj_struct(k).th_index = a(1);
                       traj_struct(k).mag = ((traj_x(start_p)^2+traj_y(start_p)^2)^(0.5));
                       traj_struct(k).max_value = find(mag_traj==max(mag_traj));
                 end
             end
         end         
     end
 end
 
 
 if get(handles.time_info_checkbox,'Value')
     t_step = 10*str2num(get(handles.timestep_edit,'String'));
 else
     t_step=0;
 end
 
 onset_index = get(handles.onset_menu,'Value');
 offset_index = get(handles.offset_menu,'Value');
 pl_index = 1;
 handles.pl_index = pl_index;
 if(numel(traj_struct))>0 
 plot_traj_xy(traj_struct,t_step,onset_index,offset_index,thresh,handles.pl_index,handles);
 set(handles.text_startt,'String',num2str(traj_struct(pl_index).start_p));
 set(handles.text_magnp,'String',num2str(traj_struct(pl_index).mag));
 end
 
 handles.traj_struct = traj_struct;
%  try
%     traj = xy_traj(handles.working_buff); 
%  end
 
    
 
%  if numel(traj)>0
%    for i=1:size(traj,1)
%       traj_x = traj{i,1};
%       traj_y = traj{i,2};
%       pl_len = min(length(traj_x),5000);
%       axes(handles.axes6)
%       hold on
%       plot(traj_x(1:pl_len),traj_y(1:pl_len),str_ls(i));
%       plot(traj_x(1)*-1,traj_y(1),'rx');      
%       axis([-0.5 0.5 -0.5 0.5]);
%       hold off
% 
%       axes(handles.axes1);
%       hold on
%       plot(handles.axes1,traj{i,4}*(1/10000):(1/10000):(traj{i,4}+pl_len-1)*(1/10000),traj_x(1:pl_len),str_ls(i),'LineWidth',2);
%       hold off
%       axes(handles.axes2);
%       hold on
%       plot(handles.axes2,traj{i,4}*(1/10000):(1/10000):(traj{i,4}+pl_len-1)*(1/10000),traj_y(1:pl_len),str_ls(i),'LineWidth',2);
%       hold off      
%     end
%  end
 
 hold off
  
 guidata(hObject, handles);
%  axis(handles.axes6,[2 3 2 3]);
%  hold on
%  comet(handles.axes6,handles.working_buff.buff(1,:),handles.working_buff.buff(2,:))
%  
% Hints: contents = cellstr(get(hObject,'String')) returns filelist_box contents as cell array
%        contents{get(hObject,'Value')} returns selected item from filelist_box

% --- Executes during object creation, after setting all properties.
function filelist_box_CreateFcn(hObject, eventdata, handles)
% hObject    handle to filelist_box (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in selectdir_push.
function selectdir_push_Callback(hObject, eventdata, handles)
% hObject    handle to selectdir_push (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
 working_dir = uigetdir;
 handles.working_dir = working_dir;
 set(handles.filelist_box,'Value',1);
 load(strcat(working_dir,'\jstruct.mat'));
 
 handles.jstruct = jstruct;
 
 %filelist = dir(strcat(working_dir,'\*.mat'));
 %populate listbox
 for i=1:size(jstruct,2)
     str_list{i} = jstruct(i).filename;
 end
 set(handles.filelist_box,'String',str_list);
 set(handles.working_dir_text,'String',working_dir);
 
 guidata(hObject, handles);



% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in analyse_push.
function analyse_push_Callback(hObject, eventdata, handles)
%[stat_structure] = xy_getstats(handles.working_dir,get(handles.filelist_box,'String'));

figure
plot(stat_structure(:,1),stat_structure(:,2),'rx');
ylim([0 5]);
% hObject    handle to analyse_push (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes during object creation, after setting all properties.
function selectdir_push_CreateFcn(hObject, eventdata, handles)
% hObject    handle to selectdir_push (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes during object creation, after setting all properties.
function analyse_push_CreateFcn(hObject, eventdata, handles)
% hObject    handle to analyse_push (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes on selection change in onset_menu.
function onset_menu_Callback(hObject, eventdata, handles)
% hObject    handle to onset_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns onset_menu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from onset_menu


% --- Executes during object creation, after setting all properties.
function onset_menu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to onset_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in offset_menu.
function offset_menu_Callback(hObject, eventdata, handles)
% hObject    handle to offset_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns offset_menu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from offset_menu


% --- Executes during object creation, after setting all properties.
function offset_menu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to offset_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function threshold_edit_Callback(hObject, eventdata, handles)
% hObject    handle to threshold_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of threshold_edit as text
%        str2double(get(hObject,'String')) returns contents of threshold_edit as a double


% --- Executes during object creation, after setting all properties.
function threshold_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to threshold_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in prev_plot_button.
function prev_plot_button_Callback(hObject, eventdata, handles)
% hObject    handle to prev_plot_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if get(handles.time_info_checkbox,'Value')
    t_step = 10*str2num(get(handles.timestep_edit,'String'));
else
    t_step=0;
end
thresh = str2num(get(handles.threshold_edit,'String'));

onset_index = get(handles.onset_menu,'Value');
offset_index = get(handles.offset_menu,'Value');
pl_index=handles.pl_index;
pl_index=max(pl_index-1,1);
if(numel(handles.traj_struct))>0
    plot_traj_xy(handles.traj_struct,t_step,onset_index,offset_index,thresh,pl_index,handles);
end
set(handles.text_startt,'String',num2str(handles.traj_struct(pl_index).start_p));
set(handles.text_magnp,'String',num2str(handles.traj_struct(pl_index).mag));

handles.pl_index = pl_index;
guidata(hObject, handles);


% --- Executes on button press in next_plot_button.
function next_plot_button_Callback(hObject, eventdata, handles)
% hObject    handle to next_plot_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if get(handles.time_info_checkbox,'Value')
    t_step = 10*str2num(get(handles.timestep_edit,'String'));
else
    t_step=0;
end

onset_index = get(handles.onset_menu,'Value');
offset_index = get(handles.offset_menu,'Value');
thresh = str2num(get(handles.threshold_edit,'String'));
pl_index=handles.pl_index;
pl_index=min(pl_index+1,numel(handles.traj_struct));
if(numel(handles.traj_struct))>0
    plot_traj_xy(handles.traj_struct,t_step,onset_index,offset_index,thresh,pl_index,handles);
end
set(handles.text_startt,'String',num2str(handles.traj_struct(pl_index).start_p));
set(handles.text_magnp,'String',num2str(handles.traj_struct(pl_index).mag));
handles.pl_index = pl_index;
guidata(hObject, handles);


% --- Executes on button press in hold_plot_checkbox.
function hold_plot_checkbox_Callback(hObject, eventdata, handles)
% hObject    handle to hold_plot_checkbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hint: get(hObject,'Value') returns toggle state of hold_plot_checkbox


% --- Executes on button press in time_info_checkbox.
function time_info_checkbox_Callback(hObject, eventdata, handles)
% hObject    handle to time_info_checkbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of time_info_checkbox



function timestep_edit_Callback(hObject, eventdata, handles)
% hObject    handle to timestep_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of timestep_edit as text
%        str2double(get(hObject,'String')) returns contents of timestep_edit as a double


% --- Executes during object creation, after setting all properties.
function timestep_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to timestep_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function rw_zone_fr_Callback(hObject, eventdata, handles)
% hObject    handle to rw_zone_fr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of rw_zone_fr as text
%        str2double(get(hObject,'String')) returns contents of rw_zone_fr as a double


% --- Executes during object creation, after setting all properties.
function rw_zone_fr_CreateFcn(hObject, eventdata, handles)
% hObject    handle to rw_zone_fr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function rw_zone_to_Callback(hObject, eventdata, handles)
% hObject    handle to rw_zone_to (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of rw_zone_to as text
%        str2double(get(hObject,'String')) returns contents of rw_zone_to as a double


% --- Executes during object creation, after setting all properties.
function rw_zone_to_CreateFcn(hObject, eventdata, handles)
% hObject    handle to rw_zone_to (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
