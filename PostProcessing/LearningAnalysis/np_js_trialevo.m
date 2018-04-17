function [out,h] = np_js_trialevo(dirlist,varargin)

np_js_nc_vect=[];
np_js_time_vect=[];

for i=1:length(dirlist)
        [pathstr,name,ext] = fileparts(dirlist(i).name);
        [pathstr_rule,name,ext] = fileparts(pathstr);        
        contingency_angle = strsplit(name,'_');
        i
        out_thresh(i) = str2num(contingency_angle{2});
        hold_time(i) = str2num(contingency_angle{3});
        hold_thresh(i) = str2num(contingency_angle{4});
        angle1(i) = str2num(contingency_angle{5});
        angle2(i) = str2num(contingency_angle{6});
        angle3(i) = str2num(contingency_angle{7});
        angle4(i) = str2num(contingency_angle{8});
        
        try
            stats_temp = load_stats(dirlist(i),0,0,0,'np_js_nc');
            np_js_nc_vect = [np_js_nc_vect;stats_temp.np_js_nc(:,1)];
            np_js_time_vect = [np_js_time_vect;stats_temp.np_js_nc(:,2)];         
            
            cont_index(i) = numel(np_js_nc_vect);
        end        
end

    zeros_ind = (np_js_nc_vect~=0);
    np_js_nc_vect = np_js_nc_vect(zeros_ind);
    np_js_time_vect = np_js_time_vect(zeros_ind);
    
    within_rangeind = np_js_nc_vect>-1000 & np_js_nc_vect<1000;
    np_js_nc_vect = np_js_nc_vect(within_rangeind);
    np_js_time_vect = np_js_time_vect(within_rangeind);
    
    np_js_time_vect = np_js_time_vect - floor(min(np_js_time_vect));

win_size = 1000;
overlap = 50;
interv = 50;
time_c = -1000:interv:1000;

for i = 1:(length(np_js_nc_vect)-win_size)/overlap
       index_curr = ((i-1)*overlap+1):((i-1)*overlap+win_size);
       np_js_trial_pdf(i,:) = histc(np_js_nc_vect(index_curr),time_c)/win_size;
end

for i=1:size(np_js_trial_pdf,1)
    cumpdf_vect(i,:) = cumsum(np_js_trial_pdf(i,:));
end

for i=1:size(np_js_trial_pdf,1)
    z_vect(i) = max(zscore(np_js_trial_pdf(i,:)));
end

% f1 = figure;
% pcolor(np_js_trial_pdf(:,180:220)); 
% set(gca,'xtick', 1:10:41);
% set(gca,'xticklabel',['-1000';'-500 ';'0    ';'500  ';'1000 ']);
% shading flat
% 
% f2 = figure;
% hold on;
% stairs(1:size(cumpdf_vect,1),cumpdf_vect(:,200));
% ylim([0 1]);

% f3 = figure;
% hold on;
% stairs(1:length(z_vect),z_vect);

out.np_js_vect = np_js_nc_vect;
out.np_js_time_vect = np_js_time_vect;
out.np_js_trial_pdf = np_js_trial_pdf;
out.cumpdf = cumpdf_vect;
out.zvect = z_vect;
% out.figures = [f1,f2];