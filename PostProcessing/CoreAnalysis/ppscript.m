% ppscript(working_dir,filespec,numField)
%
%   takes all .dat files from the directory working_dir, makes a new
%   subdirectory called comb, and combines the .dat files into .mat data
%   files
%
% ARGUMENTS:
%
%       working_dir :: string representation of directory to be analyzed
%
%       filespec :: file format specification as a string (for
%           reading lines). 
%           EX: '%f %f %s %s %s %s %s %s'
%           
%       numField :: number of fields to be read
%
function faillist = ppscript(working_dir,filespec,numField)
%% Generate full file list
faillist = {};
filelist = dir(strcat(working_dir,'/*.dat'));
if isempty(filelist)
    error('ppscript attempted on empty directory');
end

%Remove all empty files from the list
 %filelist = filelist([filelist.bytes]>0);
if ~exist(strcat(working_dir,'/comb/'), 'dir')
    mkdir(strcat(working_dir,'/comb/'));
end


%% Iterate through all files, processing and saving combined versions
fname = [working_dir,'/',filelist(1).name];
[working_buff] = read_dat_file(fname, filespec, numField);
frame_number = str2num(filelist(1).name(1:10));
start_frame = frame_number; 
mat_fname = [working_dir,'/comb/',filelist(1).name(1:end-4),'.mat'];
frame_run =1;

for i = 2:(length(filelist))
    fname = [working_dir,'/',filelist(i).name];
    framenumber_prev = frame_number;
    [record_list] = read_dat_file(fname, filespec, numField);
    frame_number = str2num(filelist(i).name(1:10));
    if ((framenumber_prev+1)==frame_number)
        %Because of hardware bug, remove 'odd' files that have > 25
        %nosepoke pairs
        frame_run = frame_run + 1;
        np = [0; record_list(:, 5); 0]>0.5; np = (diff(np) ~= 0);
        working_buff = [working_buff;record_list];
    else
        if numel(working_buff)>0
            if frame_run == (size(working_buff,1)/1000)
                save(mat_fname,'start_frame','working_buff');
            end
        end
        working_buff=record_list;
        start_frame = frame_number;
        frame_run = 1;
        mat_fname = [working_dir,'/comb/',filelist(i).name(1:end-4),'.mat'];        
    end
end

if  numel(working_buff)>0
    save(mat_fname,'start_frame','working_buff');
end

function [record_list, frame_number] = read_dat_file(fname, filespec, numField)
% [record_list, frame_number] = read_dat_file(fname, filespec, numField)
%   
%   reads the .dat file specified by fname in the format collectively
%   described by filespec and numField
%
% OUTPUTS
%
%   record_list - double matrix of length 1000, and columns equal to
%       numField+2 (analog inputs)
%
%   frame_number - number of .dat file (stripped from fname)
%
fid = fopen(fname);
frame_number = str2num(fname(1:10));
datastruct = textscan(fid,filespec,1000);
record_list(:,1:2) = [datastruct{1} datastruct{2}];
for kk=3:numField
    %boolean data is written to .dat file as 'TRUE'/'FALSE' - convert to 1/0
    record_list(:,kk) = strcmp(datastruct{:,kk},'TRUE');
end
fclose(fid);




