% Does all error handling as well, and intended to be called by a timer as
% well when necessary. Simple wrapper, nothing more than what's done in
% update_box, but for all 8 boxes.
function handles = update_all_boxes_anlys_gui(handles)
% hObject    handle to contstartstop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
try
    handles = update_box(handles, 1); 
catch
    disp('Failed to find contingency info for Box 1');
end
try
    handles = update_box(handles, 2); 
catch e
    disp(getReport(e));
    disp('Failed to find contingency info for Box 2');
end
try
    handles = update_box(handles, 3);
catch
    disp('Failed to find contingency info for Box 3');
end
try
    handles = update_box(handles, 4);
catch
    disp('Failed to find contingency info for Box 4');
end
try
    handles = update_box(handles, 5);
catch
    disp('Failed to find contingency info for Box 5');
end
try
    handles = update_box(handles, 6);
catch
    disp('Failed to find contingency info for Box 6');
end
try
    handles = update_box(handles, 7);
catch
    disp('Failed to find contingency info for Box 7');
end
try
    handles = update_box(handles, 8);
catch
    disp('Failed to find contingency info for Box 8');
end

