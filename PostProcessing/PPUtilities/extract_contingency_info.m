function [thresh2, ht, thresh, minangle, maxangle, e] = extract_contingency_info(day_directory)
%[out_thresh, ht, in_thresh, minangle, maxangle] = extract_contingency_info(day_directory)
%
%   returns the contingency information for the day represented by the
%   directory day_directory. It returns all five fields.
%
% ARGUMENTS:
%   
%   day_directory :: string representation of a directory
%
% OUTPUTS:
%
%   out_thresh :: the outer threshold that the trajectory must exceed
%
%   ht :: required hold time
%
%   in_thresh :: the inner threshold that the trajectory must remain inside
%
%   minangle :: the min angle defining the target sector
%
%   maxangle :: the max angle that the target must exceed

try
    stuff = strsplit(day_directory, '\');
    datecont = strsplit(stuff{end-1}, '_');
    thresh2 = str2num(datecont{2})*(6.35/100);
    thresh = str2num(datecont{4})*(6.35/100);
    ht = str2num(datecont{3});
    minangle = str2num(datecont{5});
    maxangle = str2num(datecont{6});
catch e
    thresh2 = 0;
    thresh = 0;
    ht = 0;
    minangle = -180;
    maxangle = 180;
end

