function [fig_handles,out] = get_trajectory_specgram(stats,b_t,a_t,t_len)

try
stats_nl = get_stats_with_trajid(stats,2);
stats_nl = get_stats_with_len(stats_nl,t_len);
%stats_nl = get_stats_rw(stats_nl,1);
stats_nl = get_stats_with_reach(stats_nl,2);
%stats_nl = get_stats_with_hold(stats_nl,30,200);

tstruct = stats_nl.traj_struct;

innerthresh_index = arrayfun(@(x) min(find(x.magtraj>30*(6.35/100))),tstruct);

for i=1:length(innerthresh_index)
    index_list(i,:) = ((innerthresh_index(i)-b_t):(innerthresh_index(i)+a_t));
end

%spec_nl = nan*zeros(501,401-t_len,numel(tstruct));

k=0;
for i=1:length(tstruct)
    try
        vel_mag = tstruct(i).vel_mag(index_list(i,:));
        [~,bp] = findpeaks(-1*vel_mag);
               
        vel_mag_ms = detrend(vel_mag,'linear',[1 bp(1:end-1)]);
        %vel_mag_ms = vel_mag - movavg(vel_mag,50,50)';
        %vel_mag_ms = vel_mag_ms(1:400);
        
%         figure;
%         plot(vel_mag,'r');
%         hold on
%         plot(vel_mag_ms,'b');
        
        k=k+1;
        [~,~,~,P] = spectrogram(vel_mag_ms,100,99,1000,1000);        
        spec_nl(:,(1:numel(vel_mag_ms)-99),k) = P;
    catch
        
    end
end

% spec_nl = 10*log10(abs(spec_nl));
spec_nl = abs(spec_nl);

spec_mean = nanmean(spec_nl,3);
h1 = figure;
pcolor(spec_mean)
shading flat
ylim([1 50])
%%
out.spec_nl = spec_nl;
out.spec_mean_nl = spec_mean;
%%
for i=1:size(spec_mean,2);spec_mean(:,i) = spec_mean(:,i)./sum(spec_mean(:,i));
end
h2 = figure;
pcolor(spec_mean)
shading flat
ylim([1 50])

%%
out.spec_mean_nl_norm = spec_mean;
%%

clearvars -except stats out h1 h2 a_t b_t t_len

stats_l = get_stats_with_trajid(stats,1);
stats_l = get_stats_with_len(stats_l,t_len);
stats_l = get_stats_with_reach(stats_l,2);
%stats_l = get_stats_rw(stats_l,1);

%stats_l = get_stats_with_hold(stats_l,30,200);

tstruct = stats_l.traj_struct;
innerthresh_index = arrayfun(@(x) min(find(x.magtraj>30*(6.35/100))),tstruct);

for i=1:length(innerthresh_index)
    index_list(i,:) = ((innerthresh_index(i)-b_t):(innerthresh_index(i)+a_t));
end

k=0;
for i=1:length(innerthresh_index)
    try
    vel_mag = tstruct(i).vel_mag(index_list(i,:));
    [~,bp] = findpeaks(-1*vel_mag);
    vel_mag_ms = detrend(vel_mag,'linear',[1 bp(1:end-1)]);
    %vel_mag_ms = vel_mag - movavg(vel_mag,50,50)';
    k=k+1;
    [~,F,T,spec_l(:,:,k)] = spectrogram(vel_mag_ms,100,99,1000,1000);    
    catch
        
    end
end

%spec_l = 10*log10(abs(spec_l));
spec_l = abs(spec_l);

spec_mean = mean(spec_l,3);

h3 = figure;
pcolor(spec_mean)
shading flat
ylim([1 50])

%%
out.spec_l = spec_l;
out.spec_mean_l = spec_mean;
%%

h4 = figure;
for i=1:size(spec_mean,2);spec_mean(:,i) = spec_mean(:,i)./sum(spec_mean(:,i));
end
pcolor(spec_mean)
shading flat
ylim([1 50])

%%
fig_handles = [h1 h2 h3 h4];
out.spec_mean_l_norm = spec_mean;
catch e
    display(e.message);
    if ~exist('fig_handles')
        fig_handles = [];
    end
end
