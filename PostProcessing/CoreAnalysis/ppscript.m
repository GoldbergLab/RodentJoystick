% ppscript(working_dir,fileformatspec,numField)
%
%   takes all .dat files from the directory working_dir, makes a new
%   subdirectory called comb, and combines the .dat files into .mat data
%   files
%
% ARGUMENTS:
%
%       working_dir :: string representation of directory to be analyzed
%
%       fileformatspec :: file format specification as a string (for
%           reading lines). 
%           EX: '%f %f %s %s %s %s %s %s
%           
%       numField :: number of fields to be read
%
function ppscript(working_dir,fileformatspec,numField)

filelist = dir(strcat(working_dir,'/*.dat'));
filelist = filelist([filelist.bytes]>0); %Remove all empty files from the list

mkdir(strcat(working_dir,'/comb/'));
open_flag=0;

fid = fopen(strcat(working_dir,'/',filelist(1).name));
frame_number = str2num(filelist(1).name(1:10));
start_frame = frame_number;
record_list =[];

datastruct = textscan(fid,fileformatspec,1000);
record_list(:,1:2) = [datastruct{1} datastruct{2}];
for i=3:numField
    %boolean data is written to .dat file as 'TRUE'/'FALSE' - convert to 1/0
    record_list(:,i) = strcmp(datastruct{:,i},'TRUE');
end
fclose(fid);

working_buff = record_list;
    
for i = 2:(length(filelist))
    fid = fopen(strcat(working_dir,'/',filelist(i).name));
    framenumber_prev = frame_number;
    frame_number = str2num(filelist(i).name(1:10));
    datastruct = textscan(fid,fileformatspec,1000);
    record_list(:,1:2) = [datastruct{1} datastruct{2}];
    for kk=3:numField
        record_list(:,kk) = strcmp(datastruct{:,kk},'TRUE');
    end
    
    if ((framenumber_prev+1)==frame_number)
        working_buff= [working_buff;record_list];
        %         record_list=[];
        open_flag=0;
    else
        %working_buff = working_buff(1:6, 1:10:end);
        if numel(working_buff)>0
            save(strcat(working_dir,'/comb/',filelist(i-1).name(1:end-4),'.mat'),'start_frame','working_buff');
        end
        open_flag=1;
        working_buff=record_list;
        start_frame = frame_number;
        %      record_list=[];
    end
    fclose(fid);
end

if (open_flag) && numel(working_buff)>0
    save(strcat(working_dir,'/comb/',filelist(i).name(1:end-4),'.mat'),'start_frame','working_buff');
end