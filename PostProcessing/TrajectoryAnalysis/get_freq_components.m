function [fig1,fig2] = get_freq_components(stats,N,fig1,fig2,color)

max_len = 1000;
Fs = 1000;
stats_len = get_stats_with_len(stats,N);
tstruct = stats_len.traj_struct;

x_mat = arrayfun(@(x) x.vel_x(1:(min(numel(x.vel_x),1000))),tstruct,'UniformOutput',0);
y_mat = arrayfun(@(x) x.vel_y(1:(min(numel(x.vel_y),1000))),tstruct,'UniformOutput',0);
mag_mat = arrayfun(@(x) x.vel_mag(1:(min(numel(x.vel_mag),1000))),tstruct,'UniformOutput',0);

for i=1:length(x_mat)
 x_mat_arr(i,:) = [x_mat{i} zeros(1,poslin(1000-numel([x_mat{i}])))];
end

for i=1:length(x_mat)
 y_mat_arr(i,:) = [y_mat{i} zeros(1,poslin(1000-numel([y_mat{i}])))];
end

for i=1:length(x_mat)
 mag_mat_arr(i,:) = [y_mat{i} zeros(1,poslin(1000-numel([y_mat{i}])))];
end

x_fft = arrayfun(@(x) abs(fft(x_mat_arr(x,:))),1:length(x_mat),'UniformOutput',0);
y_fft = arrayfun(@(x) abs(fft(y_mat_arr(x,:))),1:length(y_mat),'UniformOutput',0);
mag_fft = arrayfun(@(x) abs(fft(mag_mat_arr(x,:))),1:length(mag_mat),'UniformOutput',0);

for i=1:length(x_fft)
 x_fft_arr(i,:) = x_fft{i};
end
x_fft_mean = mean(x_fft_arr(:,1:end/2+1));

for i=1:length(y_fft)
 y_fft_arr(i,:) = y_fft{i};
end
y_fft_mean = mean(y_fft_arr(:,1:end/2+1));

for i=1:length(mag_fft)
 mag_fft_arr(i,:) = mag_fft{i};
end
mag_fft_mean = mean(y_fft_arr(:,1:end/2+1));

x_psd = (1/(Fs*max_len))*x_fft_arr(:,1:end/2+1).^2;
x_psd(2:end-1) = 2*x_psd(2:end-1);
x_psd = 10*log10(x_psd);

y_psd = (1/(Fs*max_len))*y_fft_arr(:,1:end/2+1).^2;
y_psd(2:end-1) = 2*y_psd(2:end-1);
y_psd = 10*log10(y_psd);

mag_psd = (1/(Fs*max_len))*mag_fft_arr(:,1:end/2+1).^2;
mag_psd(2:end-1) = 2*mag_psd(2:end-1);
mag_psd = 10*log10(mag_psd);

x_psd_mean = mean(x_psd);
y_psd_mean = mean(y_psd);
mag_psd_mean = mean(mag_psd);

% if isempty(fig1)
%    fig1 = figure;
% else
%    figure(fig1); 
% end
% 
% subplot(1,3,1)
% hold on
% plot(0:1:500,x_psd_mean/sum(x_psd_mean),'color',color);
% xlabel('Frequency (Hz)')
% ylabel('Power/Frequency (dB/Hz)')
% xlim([0 50])
% title('X')
% hold off
% 
% subplot(1,3,2)
% hold on
% plot(0:1:500,y_psd_mean/sum(y_psd_mean),'color',color);
% xlabel('Frequency (Hz)')
% ylabel('Power/Frequency (dB/Hz)')
% xlim([0 50])
% title('Y')
% hold off
% 
% subplot(1,3,3)
% hold on
% plot(0:1:500,mag_psd_mean/sum(mag_psd_mean),'color',color);
% xlabel('Frequency (Hz)')
% ylabel('Power/Frequency (dB/Hz)')
% xlim([0 50])
% title('Y')
hold off


if isempty(fig1)
   fig1 = figure;
else
   figure(fig1); 
end  
subplot(1,3,1)
hold on
plot(0:1:500,x_fft_mean/(sum(x_fft_mean)),'color',color);
xlabel('Frequency (Hz)')
ylabel('Amplitude FFT')
xlim([0 50])
% axis([0 50 0 1]);
title('X')
hold off

subplot(1,3,2)
hold on
plot(0:1:500,y_fft_mean/(sum(y_fft_mean)),'color',color);
xlabel('Frequency (Hz)')
ylabel('Amplitude FFT')
xlim([0 50])
% axis([0 50 0 1]);
title('Y')
hold off

subplot(1,3,3)
hold on
plot(0:1:500,y_fft_mean/(sum(y_fft_mean)),'color',color);
xlabel('Frequency (Hz)')
ylabel('Amplitude FFT')
xlim([0 50])
% axis([0 50 0 1]);
title('Mag')
hold off