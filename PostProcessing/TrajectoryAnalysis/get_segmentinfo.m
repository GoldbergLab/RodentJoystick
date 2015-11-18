function [seginfo_vect,num_rdirpts_c,num_rdirpts_nc] = get_segmentinfo(tstruct)

kk=0;
num_rdirpts_c=0;
num_rdirpts_nc=0;
tstruct = filterandscale_trajstruct(tstruct);

for ii=1:length(tstruct)
    ii
    if (numel(tstruct(ii).traj_x)>10)
        [redir_points, data] = detect_sharpturns(tstruct(ii));
        if numel(redir_points)>2
            [quality] = fit_speed_model(data.speed, redir_points);
            
            dist_from_c = (tstruct(ii).traj_x(redir_points).^2+tstruct(ii).traj_y(redir_points).^2).^(0.5);
            
            num_rdirpts_c  = num_rdirpts_c+sum(dist_from_c<(0.30*6.25));
            num_rdirpts_nc = num_rdirpts_nc+sum(dist_from_c>(0.30*6.25));
            
            for jj = 1:(length(redir_points)-1)
                
                peakvel = max(data.speed(redir_points(jj):redir_points(jj+1)));
                dur = (redir_points(jj+1)-redir_points(jj));
                pathlen = sum((diff(tstruct(ii).traj_x(redir_points(jj):redir_points(jj+1)))).^2 + (diff(tstruct(ii).traj_y(redir_points(jj):redir_points(jj+1))).^2)).^(0.5);
                kk=kk+1;
                seginfo_vect(kk,:) = [peakvel dur pathlen quality(jj) tstruct(ii).laser];
                
            end
        end
    end
end
