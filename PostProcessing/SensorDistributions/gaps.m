% [distr] = gaps(jstruct, index, [interv, end_time])
%
%   returns and plots the distribution of sensor onset to offset times
%   The sensor is selected via index.
%
% OUTPUTS:
%   
%   dist :: distribution of sensor onset to offset times
%
% ARGUMENTS:
%
%   jstruct :: standard jstruct data structure
%
%   index :: indicates which sensor to generate the distribution for
%       0 - nosepoke
%       1 - post touch
%       2 - joystick touch
%
% OPTIONAL ARGS:
%
%   interv :: histogram interval (ms)
%       DEFAULT - 10
%
%   end_time :: end time of histogram (ms)
%       DEFAULT - 1000

function [dist] = gaps(jstruct, index, varargin)
%% ARGUMENT MANIPULATION
default = {10, 1000};
numvarargs = length(varargin);
if numvarargs > 2
    error(['too many arguments (> 4), only 2 required ' ... 
            'and 2 optional.']);
end
[default{1:numvarargs}] = varargin{:};
[interv, end_time] = default{:};

%% DATA EXTRACTION
gap_list = [];
for i=1:length(jstruct)
    switch index
        case 0
            pairs = jstruct(i).np_pairs;
        case 1
            pairs = jstruct(i).js_pairs_l;
        case 2
            pairs = jstruct(i).js_pairs_r;
        otherwise
    end
    for j=1:(size(pairs,1)-1);
        gap = pairs(j+1,2)-pairs(j,1);
        gap_list = [gap_list gap];
    end
end

%% PLOTTING
x = 1:interv:end_time;
dist = histc(gap_list,x);
stairs(x,dist);