max_displace = [];
for i = 1:length(jstruct)
    if numel(jstruct(i).js_pairs_r)>0
    js_start = jstruct(i).js_pairs_r(jstruct(i).js_reward==1,1);
    js_stop = jstruct(i).js_pairs_r(jstruct(i).js_reward==1,2);
    for j =1:length(js_start)
        t_x = jstruct(i).traj_x(js_start(j):js_stop(j));
        t_y = jstruct(i).traj_y(js_start(j):js_stop(j));
        angle_t = atan2(t_y,t_x);
        displace = (t_x.^2 + t_y.^2).^(0.5);
        displace = displace(angle_t>-1 & angle_t<90);
        if numel(displace>0)
        max_displace(length(max_displace)+1) = max(displace);
        end
    end
    end
end