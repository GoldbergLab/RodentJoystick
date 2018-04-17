function [jstruct_stats,mask_mat_vect] = np_js_l_nl(jstruct,jstruct_stats)

% Get Masked only vs Laser inactivation on Nosepoke
jstruct_stats.np_js_masked_l = [];
jstruct_stats.np_js_masked_nl = [];
jstruct_stats.np_js_nc_nl = [];

%if exist('jstruct(1).masking_light','var')
list=[];
list_laser=[];
list_masked=[];

masked_np_time = [];
masked_np_laser = [];

k=0;

for i=1:length(jstruct)
    if (numel(jstruct(i).np_pairs)>0)
        for j=1:size(jstruct(i).np_pairs,1)
            % was this nosepoked masked for laser?
            try
            if numel(jstruct(i).masking_light)>0
                if sum(abs(jstruct(i).masking_light(:,1) - jstruct(i).np_pairs(j,1))<2) && ~(sum((jstruct(i).js_pairs_r(:,1)-jstruct(i).np_pairs(j,1))<1 & (jstruct(i).js_pairs_r(:,2)-jstruct(i).np_pairs(j,1))>2)>0)                   
                        masked_np = 1;
                        k=k+1;
                        mask_mat_vect(k,:) = [i,j];
                        masked_np_time = [masked_np_time (jstruct(i).real_time) + (jstruct(i).np_pairs(j,1))/(1000*60*60*24)];
                else
                    masked_np = 0;
                end

            else
                masked_np = 0;
            end
            catch
                masked_np = 0;
            end
            % was this nosepoke hit with laser?
            try
            if numel(jstruct(i).laser_on)>0
                laser_index_temp = find(abs(jstruct(i).laser_on(:,1) - jstruct(i).np_pairs(j,1))<2);
                isLaser = numel(laser_index_temp);
                isBWJSon_off = (sum((jstruct(i).js_pairs_r(:,1)-jstruct(i).np_pairs(j,1))<1 & (jstruct(i).js_pairs_r(:,2)-jstruct(i).np_pairs(j,1))>2)>0);
                
                if isLaser                  
                    laser_length = (jstruct(i).laser_on(laser_index_temp,2)-jstruct(i).laser_on(laser_index_temp,1));                    
                    if laser_length<200 && laser_length>300
                      masked_np = masked_np(1:(end-1));
                      continue
                    end                    
                end
                
                if  isLaser && ~isBWJSon_off 
                    laser_np = 1;                    
                else
                    laser_np = 0;
                end                
            else
                laser_np = 0;
            end
            catch
                laser_np = 0;
            end
            %was there a joystick contact in this trial?
            if numel(jstruct(i).js_pairs_r>0)
                %Find closest positive js contact and add it to list
                np_js_diff = (jstruct(i).js_pairs_r(:,1)-jstruct(i).np_pairs(j,1));
                np_js_diff = np_js_diff(np_js_diff>0);
                [np_js_diff_abs,ind] = sort(np_js_diff);
                
                %keep adding each
                try
                    list = [list;np_js_diff(ind(1))];
                catch
                    list = [list;NaN];
                end
                
            else
                %if no joystick contact add NaN entry
                list = [list;NaN];
            end
            list_laser = [list_laser;laser_np];
            list_masked = [list_masked;masked_np];
            
            if masked_np
                masked_np_laser = [masked_np_laser laser_np&masked_np];
            end
            
        end
    end
end

jstruct_stats.np_js_masked_l = list((list_laser==1)&(list_masked==1));
jstruct_stats.np_js_masked_nl = list((list_laser==0)&(list_masked==1));
jstruct_stats.np_js_nc_nl = list((list_laser==0)&(list_masked==0));
jstruct_stats.masked_np_time = masked_np_time;
jstruct_stats.masked_np_laser = masked_np_laser;

edges = 0:1:1200;
out1 = histc(jstruct_stats.np_js_masked_l,edges)/numel(jstruct_stats.np_js_masked_l);
out2 = histc(jstruct_stats.np_js_masked_nl,edges)/numel(jstruct_stats.np_js_masked_nl);
figure
stairs(edges,smooth(cumsum(out1),3),'r');
hold on
stairs(edges,smooth(cumsum(out2),3),'b');
xlim([min(edges),max(edges)])
ylim([0 1]);

edges = 0:20:1200;
out1 = histc(jstruct_stats.np_js_masked_l,edges)/numel(jstruct_stats.np_js_masked_l);
out2 = histc(jstruct_stats.np_js_masked_nl,edges)/numel(jstruct_stats.np_js_masked_nl);
figure
stairs(edges,smooth(out1,3),'r');
hold on
stairs(edges,smooth(out2,3),'b');
xlim([min(edges),max(edges)])
ylim([0 0.4]);
%kstest2(jstruct_stats.np_js_masked_l,jstruct_stats.np_js_masked_nl)

