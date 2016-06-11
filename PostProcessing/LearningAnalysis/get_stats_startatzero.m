function stats = get_stats_startatzero(stats,varargin)

default = {30};
numvarargs = length(varargin);
if numvarargs > 1
    error('too many arguments (> 3), only 1 required and 2 optional.');
end
[default{1:numvarargs}] = varargin{:};
[zerodef] = default{:};


tstruct = stats.traj_struct;
output = arrayfun(@(y) (y.magtraj(1) < zerodef*(6.35/100)), tstruct);

stats.traj_struct = tstruct(output);