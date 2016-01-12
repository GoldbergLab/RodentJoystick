function [obj] = populate_function_list(obj)
%Helper function generates a list of plotting functions and assigns it to
%the appropriate dropdown box.

%% MODIFY THIS SECTION TO ADD PLOTS
function_list = {'Nosepoke Joystick Onset Distribution';
                    'Nosepoke Post Onset Distribution';
                    'Hold Time Distribution';
                    'Rewarded Hold Time Distribution';
                    'Reward Rate by Hold Time Distribution';
                    'Joystick Onset to Reward Distribution';
                    'Nosepoke/Reward Activity Distribution';
                    'JS Touch Dist';
                    'Activity Heat Map';
                    'Velocity Heat Map';
                    'Velocity Variation Heat Map';
                    'Acceleration Heat Map'
                    'Acceleration Variation Heat Map';
                    'Angle Distribution (Linear)';
                    'Trajectory Analysis (4)';
                    'Trajectory Analysis (6)';
                    'Pathlength';
                    'Duration';
                    'Average Velocity';
                    'Maximum Velocity';
                    'Accleration Peaks';
                    'Segments in Trajectory';
                    'Angle at Thresh';
                    'Angle at Thresh after Hold';
                    'Segment Pathlen';
                    'Segment Avg Vel';
                    'Segment Peak Vel';
                    'Segment Duration'};

%% GUI UI interactions
set(obj, 'String', function_list);

end

