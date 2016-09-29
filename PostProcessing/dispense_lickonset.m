function [] = dispense_lickonset(dirlist)
%dirlist = dirlist(1:61);
lickonset_l = [];
lickonset_nl = [];
kk =0;

try
for ii=1:numel(dirlist)
    
    load(dirlist(ii).name,'working_buff');
    working_buff(:,8) = medfilt1(working_buff(:,8),3); %nose poke lick

    
    [index2,temp] = find(diff(working_buff(:,6))==1);
    if numel(index2)>0             
        for jj = 1:numel(index2)
            if (numel(working_buff(:,6))-index2(jj))>2000
                kk = kk+1;
                
                if sum(working_buff(index2(jj):(index2(jj)+1000),7))>10
                    laser_vect(kk) = 1;
                else
                    laser_vect(kk) = 0;
                end
                
                lick_diff=diff(working_buff(:,8)); %nosepoke lick
                [index1,temp] = find(lick_diff==1);
                
%                 figure;
%                 plot(1:2001,working_buff(index2(jj):(index2(jj)+2000),8));
%                 axis([1 2000 0 2]);
                
                if numel(index1>0)
                    if (laser_vect(kk) == 1)
                        lickonset_l = [lickonset_l;(index1-index2(jj))];
                    else
                        lickonset_nl = [lickonset_nl;(index1-index2(jj))];
                    end
                end
            end
        end
    end
   
end
catch
  
    ii
    jj
end
laser_lick = lickonset_l;
nl_lick = lickonset_nl;

% numlaser = sum(laser_vect==1);
% numnl = sum(laser_vect==0);

numlaser = numel(laser_lick);
numnl = numel(nl_lick);

figure;
edges = -2000:100:3000;
l_dist = histc(laser_lick,edges);
l_dist = l_dist/numlaser;
stairs(edges,l_dist,'r');
hold on;

nl_dist = histc(nl_lick,edges);
nl_dist = nl_dist/numnl;
%stairs(edges,cumsum(nl_dist),'b');
stairs(edges,nl_dist,'b');

legend('Laser', 'Non-Laser');
xlabel('Time to onset of Lick from Cue(ms)');
ylabel('Fraction');
title('Distribution of individual lick onsets (ALM Inactivated vs Intact) ');
% axis([-2000 3000 0 0.0001])