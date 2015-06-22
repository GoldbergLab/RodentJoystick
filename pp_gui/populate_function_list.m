function [obj] = populate_function_list(obj)
%Helper function generates a list of plotting functions and assigns it to
%the appropriate dropdown box.

%% MODIFY THIS SECTION TO ADD PLOTS
function_list = {'Nosepoke Joystick Onset Distribution';
                    'Nosepoke Post Onset Distribution';
                    'Hold Length Distribution (Max)';
                    'Hold Length Distribution (Threshold)';
                    'Hold Time Distribution (Trajectories)';
                    'Rewarded Hold Time Distribution';
                    'Reward Rate by Hold Time Distribution';
                    'Joystick Onset to Reward Distribution';
                    'Nosepoke/Reward Activity Distribution';
                    'Activity Heat Map';
                    'Velocity Heat Map';
                    'Velocity Variation Heat Map';
                    'Acceleration Variation Heat Map';
                    'Angle Distribution (Linear)';
                    'Trajectory Analysis (4)';
                    'Trajectory Analysis (6)'};

%% GUI UI interactions
set(obj, 'String', function_list);

end

