function [laser_ratio] = laser_prob_test(stats,jstruct)

tstruct = stats.traj_struct;

%Determine number of Trajectories Inactivated
num_traj = numel(tstruct);
tstruct_laser = arrayfun(@(y) (y.laser>0), tstruct);
num_traj_laser = sum(tstruct_laser);

laser_ratio.traj_laser = num_traj_laser/num_traj;
np_laser_eligible = 0;

for i=1:numel(jstruct)
    if (numel(jstruct(i).np_pairs)>0) && (numel(jstruct(i).js_pairs_l)>0)
        np_pairs = jstruct(i).np_pairs;
        js_pairs_l = jstruct(i).js_pairs_l;
        js_pairs_r = jstruct(i).js_pairs_r;
        np_onsets = np_pairs(:,1);
        
        np_onsets_w_pt = zeros(1,numel(np_onsets));
        
        for j = 1:numel(np_onsets)
             jspair_diff = ((js_pairs_l(:,1)-np_onsets(j))<0)&((js_pairs_l(:,2)-np_onsets(j))>0);             
             w_jspair_l = sum(jspair_diff)>0;
             if numel(js_pairs_r)
                w_jspair_r = sum(((js_pairs_r(:,1)-np_onsets(j))<0)&((js_pairs_r(:,2)-np_onsets(j))>0))>0;
                np_onsets_w_pt(j) = w_jspair_l & (~w_jspair_r);
             else
                np_onsets_w_pt(j) = w_jspair_l;
             end
             js_pairs_l = js_pairs_l(~jspair_diff,:);
        end
        
        np_laser_eligible = np_laser_eligible+sum(np_onsets_w_pt);
    end
end

np_laser_eligible