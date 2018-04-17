% [stats] = get_stats_with_trajid(stats,datenum_input, varargin)
%   
%   get_stats_with_day modifies the stats structures trajectories based
%   on the matlab datenum. Filters trajectories depending on the day of the trajectory.
%
% ARGS : 
%   
%   stats :: standard stats structure
%   datenum_input :: date input in matlab format
%
% OUTPUTS :
%
%   stats_out :: a standard stats structure with field traj_struct modified to
%       satisfy above condition
%
function stats_out = get_stats_with_day(stats,datenum_input, varargin)

    tstruct= stats.traj_struct;
    output = arrayfun(@(x) floor(x.real_time)==datenum_input,tstruct,'UniformOutput',false);
    
    output = cell2mat(output);
    tstruct = tstruct(output);          
    stats_out.traj_struct=tstruct;
    
end
