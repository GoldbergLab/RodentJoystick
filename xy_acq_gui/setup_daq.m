function [s,lh] = setup_daq(hObject)
samprate = 10000;
s=daq.createSession('ni');
s.IsContinuous=true;
s.IsNotifyWhenDataAvailableExceedsAuto=false;
s.NotifyWhenDataAvailableExceeds=1000;
s.Rate = samprate;

s.addAnalogInputChannel('Dev2','ai1','Voltage');
s.addAnalogInputChannel('Dev2','ai9','Voltage');
s.addAnalogInputChannel('Dev2','ai2','Voltage');
s.addAnalogInputChannel('Dev2','ai10','Voltage');
s.addAnalogInputChannel('Dev2','ai3','Voltage');
s.addAnalogInputChannel('Dev2','ai11','Voltage');
% s.addAnalogInputChannel('Dev2','ai4','Voltage');
% s.addAnalogInputChannel('Dev2','ai12','Voltage');
% s.addAnalogInputChannel('Dev2','ai7','Voltage');
% s.addAnalogInputChannel('Dev2','ai15','Voltage');
% s.addAnalogInputChannel('Dev2','ai0','Voltage');
% s.addAnalogInputChannel('Dev2','ai8','Voltage');
% s.addAnalogInputChannel('Dev2','ai5','Voltage');
% s.addAnalogInputChannel('Dev2','ai13','Voltage');
% s.addAnalogInputChannel('Dev2','ai6','Voltage');
% s.addAnalogInputChannel('Dev2','ai14','Voltage');
 
for i=1:6
s.Channels(i).InputType = 'SingleEnded';
end

lh = s.addlistener('DataAvailable', @(src,event) xy_analyze(src,event,hObject));
