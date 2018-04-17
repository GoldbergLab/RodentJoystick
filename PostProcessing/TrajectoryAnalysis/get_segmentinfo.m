function [seginfo_vect,redir_points] = get_segmentinfo(tstruct)

seginfo_vect=[];
redir_points=[];

kk=0;
% num_rdirpts_c=0;
% num_rdirpts_nc=0;


    if (numel(tstruct.traj_x_seg))>110
        [redir_points, quality, data] = detect_sharpturns(tstruct);
        if numel(redir_points)>2
            
            dist_from_c = (tstruct.traj_x_seg(redir_points).^2+tstruct.traj_y_seg(redir_points).^2).^(0.5);
            
%             num_rdirpts_c  = num_rdirpts_c+sum(dist_from_c<(0.30*6.25));
%             num_rdirpts_nc = num_rdirpts_nc+sum(dist_from_c>(0.30*6.25));
            
            for jj = 1:(length(redir_points)-1)
                
                traj_x = tstruct.traj_x_seg(redir_points(jj):redir_points(jj+1));
                traj_y = tstruct.traj_y_seg(redir_points(jj):redir_points(jj+1));
                peakvel = max(data.speed(redir_points(jj):redir_points(jj+1)));
                avgvel = mean(data.speed(redir_points(jj):redir_points(jj+1)));
                avgR = mean(data.r_curv(redir_points(jj):redir_points(jj+1)));
                dur = (redir_points(jj+1)-redir_points(jj));
                pathlen = sum((diff(traj_x)).^2 + (diff(traj_y).^2)).^(0.5);
                disp_x = tstruct.traj_x_seg(redir_points(jj+1))-tstruct.traj_x_seg(redir_points(jj)); 
                disp_y = tstruct.traj_y_seg(redir_points(jj+1))-tstruct.traj_y_seg(redir_points(jj)); 
                displacement = (disp_x^2+disp_y^2)^(0.5);     
                
                kk=kk+1;
                seginfo_vect(kk).peakvel = peakvel;
                seginfo_vect(kk).avgvel = avgvel;
                seginfo_vect(kk).dur = dur;
                seginfo_vect(kk).pathlen = pathlen;
                seginfo_vect(kk).quality = quality(jj);
                seginfo_vect(kk).velprofile = data.speed(redir_points(jj):redir_points(jj+1));
                seginfo_vect(kk).disp =  displacement;
                seginfo_vect(kk).start = redir_points(jj);
                seginfo_vect(kk).stop = redir_points(jj+1);
                seginfo_vect(kk).index = jj;
                seginfo_vect(kk).last =0;
                seginfo_vect(kk).traj_x = traj_x;
                seginfo_vect(kk).traj_y = traj_y;
                seginfo_vect(kk).avgR = avgR;
            end
            
                redir_index = find(redir_points<(numel(tstruct.traj_x_seg)-200));
                redir_points = redir_points(redir_index);
                try
                    seginfo_vect = seginfo_vect(1:(min(numel(seginfo_vect),redir_index(end))));
                    seginfo_vect(end).last = 1;
                catch
                    seginfo_vect = []; 
                end
        end        
    end
