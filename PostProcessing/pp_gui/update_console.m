function handles = update_console(handles, cellstring)
%updates the console with the contents of the cell array cellstring, which
%should be a cell array of strings
text = get(handles.console, 'String');
text = cellstr(text);
newtext = [cellstring; ' '; text];
set(handles.console, 'String', newtext);
set(handles.console, 'Value', 1);

end

