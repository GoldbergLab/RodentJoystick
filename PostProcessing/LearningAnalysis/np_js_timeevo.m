function [out,h] = np_js_timeevo(dirlist,varargin)

np_js_nc_vect=[];
np_js_time_vect=[];
k=0;

for i=1:length(dirlist)
        [pathstr,day_str,ext] = fileparts(dirlist(i).name);
        [pathstr_rule,name,ext] = fileparts(pathstr);        
        contingency_rule = strsplit(name,'_');
        
        out_thresh(i) = str2num(contingency_rule{2});
        hold_time(i) = str2num(contingency_rule{3});
        hold_thresh(i) = str2num(contingency_rule{4});
        angle1(i) = str2num(contingency_rule{5});
        angle2(i) = str2num(contingency_rule{6});
        angle3(i) = str2num(contingency_rule{7});
        angle4(i) = str2num(contingency_rule{8});
        
        try
            hrin=0;
            stats_temp = load_stats(dirlist(i),0,0,hrin,'np_js_nc');
            np_js_nc_vect = [np_js_nc_vect;stats_temp.np_js_nc(:,1)];
            np_js_time_vect = [np_js_time_vect;stats_temp.np_js_nc(:,2)];              
        end        
end
    zeros_ind = (np_js_nc_vect~=0);
    np_js_nc_vect = np_js_nc_vect(zeros_ind);
    np_js_time_vect = np_js_time_vect(zeros_ind);
    
    within_rangeind = np_js_nc_vect>-1000 & np_js_nc_vect<1000;
    np_js_nc_vect = np_js_nc_vect(within_rangeind);
    np_js_time_vect = np_js_time_vect(within_rangeind);
    
    np_js_time_vect = np_js_time_vect - floor(min(np_js_time_vect));
    days_max = ceil(max(np_js_time_vect));
    time_bins = 1;
    
for i=1:(days_max*time_bins)
    
    np_vect = np_js_nc_vect((np_js_time_vect>(i-1)/time_bins)&(np_js_time_vect<(i)/time_bins));
    np_vect_mean = mean(np_vect);
    %np_vect_stddev_norm = std(np_vect,1);%/abs(np_vect_mean);
    np_vect_stddev_norm = prctile(np_vect,75) - prctile(np_vect,25);
    pdf_vect_temp = histc(np_vect,-1000:10:1000);
    pdf_vect_temp = pdf_vect_temp/(sum(pdf_vect_temp));
    
    zscore_vect(i) = max(zscore(pdf_vect_temp));
    filt_win = gausswin(10);
    pdf_vect(i,:) = conv(filt_win,pdf_vect_temp);
    pdf_vect(i,:) = pdf_vect(i,:)/(sum(pdf_vect(i,:)));
    
    mean_vect(i) = np_vect_mean;
    
    stddev_vect(i) = np_vect_stddev_norm;
    if (numel(np_vect))>50
     cdf_vect(i,:) = cumsum(pdf_vect_temp);
    else
     cdf_vect(i,1:(numel(pdf_vect(i,:))-99)) = NaN;
    end
    
end


out.np_js_vect = np_js_nc_vect;
out.pdf_vect = pdf_vect;
out.mean_vect = mean_vect;
out.stddev_vect = stddev_vect;
out.cdf_vect = cdf_vect;
out.zvect = zscore_vect;
