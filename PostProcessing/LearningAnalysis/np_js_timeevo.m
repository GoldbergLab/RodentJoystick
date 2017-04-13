function [out,h] = np_js_timeevo(dirlist,varargin)

np_js_nc_vect=[];
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
            np_js_nc_vect = [np_js_nc_vect;stats_temp.np_js_nc];
            np_js_time_vect = 0;
            np_js_nc_vect = np_js_nc_vect(np_js_nc_vect~=0);
            np_js_nc_vect = np_js_nc_vect(np_js_nc_vect>-1000 & np_js_nc_vect<1000);
            
            cont_day_temp = datenum(day_str,'mmddyy');
            if (k == 0) || (cont_day_temp ~= cont_day(k));
               k = k + 1;
               cont_day(k) = cont_day_temp;                
            end
            
            cont_index(k) = numel(np_js_nc_vect);
        end        
end

cont_index = cont_index(cont_index>0);
cont_index = [1 cont_index];

for i=1:(length(cont_index)-1)
    ind1 = cont_index(i);
    ind2 = cont_index(i+1);
    np_vect = np_js_nc_vect(ind1:ind2);
    np_vect_mean = mean(np_vect);
    %np_vect_stddev_norm = std(np_vect,1);%/abs(np_vect_mean);
    np_vect_stddev_norm = prctile(np_vect,75) - prctile(np_vect,25);
    pdf_vect_temp = histc(np_vect,-1000:50:1000);
    pdf_vect_temp = pdf_vect_temp/(sum(pdf_vect_temp));
    
    zscore_vect(i) = max(zscore(pdf_vect_temp));
    
    pdf_vect(i,:) = pdf_vect_temp;
    
    mean_vect(i) = np_vect_mean;
    
    stddev_vect(i) = np_vect_stddev_norm;
    
    cdf_vect(i,:) = cumsum(pdf_vect_temp);
    
end


out.np_js_vect = np_js_nc_vect;
out.pdf_vect = pdf_vect;
out.mean_vect = mean_vect;
out.stddev_vect = stddev_vect;
out.cdf_vect = cdf_vect;
out.zvect = zscore_vect;
