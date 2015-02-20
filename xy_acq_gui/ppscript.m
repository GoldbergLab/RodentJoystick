function ppscript(working_dir)

%working_dir = uigetdir(pwd);
filelist = dir(strcat(working_dir,'/*.dat'));
working_buff=[];
datenum_var=0;
mkdir(strcat(working_dir,'/comb'));

    fid = fopen(strcat(working_dir,'/',filelist(1).name));
    datenum_var = fread(fid,1,'double');
    working_buff= fread(fid,[5 11000],'double');
    fclose(fid);
    
for i = 2:length(filelist)-1
    fid = fopen(strcat(working_dir,'/',filelist(i).name));
    datenum_prev = datenum_var;
    datenum_var = fread(fid,1,'double');
    if ((datenum_var-datenum_prev) < (1.5/(24*3600)))   
      working_buff= [working_buff fread(fid,[5 11000],'double')];
    else
      save(strcat(working_dir,'/comb/',filelist(i).name(1:end-4),'.mat'),'datenum_var','working_buff');
      working_buff=fread(fid,[5 11000],'double');
    end
    fclose(fid);
    
end

i=length(filelist);
fid = fopen(strcat(working_dir,'/',filelist(i).name));
datenum_prev = datenum_var;
datenum_var = fread(fid,1,'double');
working_buff= [working_buff fread(fid,[5 11000],'double')];    
save(strcat(working_dir,'/comb/',filelist(i).name(1:end-4),'.mat'),'datenum_var','working_buff');
fclose(fid);