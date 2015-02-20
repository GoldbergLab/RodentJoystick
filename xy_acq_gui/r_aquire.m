%Initialize the DAQ

samprate = 10000;
s=daq.createSession('ni');
s.IsContinuous=true;
s.IsNotifyWhenDataAvailableExceedsAuto=false;
s.NotifyWhenDataAvailableExceeds=1000;
s.Rate = samprate;

s.addAnalogInputChannel('Dev1','ai1','Voltage');
s.addAnalogInputChannel('Dev1','ai9','Voltage');
s.addAnalogInputChannel('Dev1','ai2','Voltage');
s.addAnalogInputChannel('Dev1','ai10','Voltage');
s.addAnalogInputChannel('Dev1','ai3','Voltage');
s.addAnalogInputChannel('Dev1','ai11','Voltage');
s.addAnalogInputChannel('Dev1','ai4','Voltage');
s.addAnalogInputChannel('Dev1','ai12','Voltage');
s.addAnalogInputChannel('Dev1','ai5','Voltage');
s.addAnalogInputChannel('Dev1','ai13','Voltage');
s.addAnalogInputChannel('Dev1','ai6','Voltage');
s.addAnalogInputChannel('Dev1','ai14','Voltage');
s.addAnalogInputChannel('Dev1','ai7','Voltage');
s.addAnalogInputChannel('Dev1','ai15','Voltage');
s.addAnalogInputChannel('Dev1','ai8','Voltage');
s.addAnalogInputChannel('Dev1','ai16','Voltage');
 
for i=1:16
s.Channels(i).InputType = 'SingleEnded';
end

lh = s.addlistener('DataAvailable', @xy_analyze); 

%global variables;
global buff;
global buff_count;
global write_count;
global frame_countdown 
frame_countdown = 0;
buff_count=0;
buff = double(zeros(4,11000));

s.startBackground();