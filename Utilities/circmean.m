function [circ_med] = circmean(input_vect)

input_vect = (input_vect/180) * pi;
sin_val = sin(input_vect);
cos_val = cos(input_vect);

circ_med = atan2((sum(sin_val)/numel(sin_val)),(sum(cos_val)/numel(cos_val)));
circ_med = circ_med*180/pi;