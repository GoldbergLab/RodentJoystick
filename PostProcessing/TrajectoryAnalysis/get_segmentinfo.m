function [seginfo_vect,redir_points] = get_segmentinfo(tstruct)

seginfo_vect=[];
redir_points=[];

kk=0;
% num_rdirpts_c=0;
% num_rdirpts_nc=0;


    if (numel(tstruct.traj_x))>10
        [redir_points, quality, data] = detect_sharpturns(tstruct);
        if numel(redir_points)>2
            
            dist_from_c = (tstruct.traj_x(redir_points).^2+tstruct.traj_y(redir_points).^2).^(0.5);
            
%             num_rdirpts_c  = num_rdirpts_c+sum(dist_from_c<(0.30*6.25));
%             num_rdirpts_nc = num_rdirpts_nc+sum(dist_from_c>(0.30*6.25));
            
            for jj = 1:(length(redir_points)-1)
                
                peakvel = max(data.speed(redir_points(jj):redir_points(jj+1)));
                dur = (redir_points(jj+1)-redir_points(jj));
                pathlen = sum((diff(tstruct.traj_x(redir_points(jj):redir_points(jj+1)))).^2 + (diff(tstruct.traj_y(redir_points(jj):redir_points(jj+1))).^2)).^(0.5);
                kk=kk+1;
                seginfo_vect(kk).peakvel = peakvel;
                seginfo_vect(kk).dur = dur;
                seginfo_vect(kk).pathlen = pathlen;
                seginfo_vect(kk).quality = quality(jj);
                seginfo_vect(kk).velprofile = data.speed(redir_points(jj):redir_points(jj+1));
            end
        end
    end
