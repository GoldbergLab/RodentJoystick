function [out,fig1] = get_freq_components(stats,N,fig1,color)

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

parfor i = 1:size(x_mat_arr,1)
  x_fft_arr(i,:) = abs(fft(x_mat_arr(i,:)));
  y_fft_arr(i,:) = abs(fft(y_mat_arr(i,:)));
  mag_fft_arr(i,:) = abs(fft(mag_mat_arr(i,:)));
end    
% 
% y_fft = arrayfun(@(x) abs(fft(y_mat_arr(x,:))),1:length(y_mat),'UniformOutput',0);
% mag_fft = arrayfun(@(x) abs(fft(mag_mat_arr(x,:))),1:length(mag_mat),'UniformOutput',0);

num_arr = size(x_fft_arr,1);


x_fft_mean = mean(x_fft_arr(:,1:end/2+1));
x_fft_sem = nanstd(x_fft_arr(:,1:end/2+1),0,1)/sqrt(num_arr);

y_fft_mean = mean(y_fft_arr(:,1:end/2+1));
y_fft_sem = nanstd(y_fft_arr(:,1:end/2+1),0,1)/sqrt(num_arr);

mag_fft_mean = mean(mag_fft_arr(:,1:end/2+1));
mag_fft_sem = nanstd(mag_fft_arr(:,1:end/2+1),0,1)/sqrt(num_arr);

x_psd = (1/(Fs*max_len))*x_fft_arr(:,1:end/2+1).^2;
x_psd(2:end-1) = 2*x_psd(2:end-1);
x_psd = 10*log10(x_psd);

y_psd = (1/(Fs*max_len))*y_fft_arr(:,1:end/2+1).^2;
y_psd(2:end-1) = 2*y_psd(2:end-1);
y_psd = 10*log10(y_psd);

mag_psd = (1/(Fs*max_len))*mag_fft_arr(:,1:end/2+1).^2;
mag_psd(2:end-1) = 2*mag_psd(2:end-1);
mag_psd = 10*log10(mag_psd);

out.x_psd_mean = mean(x_psd);
out.y_psd_mean = mean(y_psd);
out.mag_psd_mean = mean(mag_psd);
out.mag_fft_arr = mag_fft_arr;
out.x_fft_mean = x_fft_mean/(sum(x_fft_mean));
out.y_fft_mean = y_fft_mean/(sum(y_fft_mean));
out.mag_fft_mean = mag_fft_mean/(sum(mag_fft_mean));

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
% hold off



if isempty(fig1)
   fig1 = figure;
else
   figure(fig1); 
end

u20 = (x_fft_mean+x_fft_sem)/(sum(x_fft_mean));
d20 = (x_fft_mean-x_fft_sem)/(sum(x_fft_mean));
d20(d20<0) = 0;

y2 = [u20 d20]';
x2 = [0:500 0:500]';
vertices1 = [x2 y2];
faces = [1:501 1002:-1:502];

subplot(1,3,1)
hold on
plot(0:1:500,out.x_fft_mean,'color',color);
patch('vertices',vertices1,'faces',faces,'Facecolor',color,'Edgecolor','none');
xlabel('Frequency (Hz)')
ylabel('Amplitude FFT')
xlim([0 50])
% axis([0 50 0 1]);
title('X')
hold off
alpha(0.3);

u20 = (y_fft_mean+y_fft_sem)/(sum(y_fft_mean));
d20 = (y_fft_mean-y_fft_sem)/(sum(y_fft_mean));
d20(d20<0) = 0;

y2 = [u20 d20]';
x2 = [0:500 0:500]';
vertices1 = [x2 y2];
faces = [1:501 1002:-1:502];

subplot(1,3,2)
hold on
plot(0:1:500,out.y_fft_mean,'color',color);
patch('vertices',vertices1,'faces',faces,'Facecolor',color,'Edgecolor','none');
xlabel('Frequency (Hz)')
ylabel('Amplitude FFT')
xlim([0 50])
% axis([0 50 0 1]);
title('Y')
hold off
alpha(0.3);

u20 = (mag_fft_mean+mag_fft_sem)/(sum(mag_fft_mean));
d20 = (mag_fft_mean-mag_fft_sem)/(sum(mag_fft_mean));
d20(d20<0) = 0;

y2 = [u20 d20]';
x2 = [0:500 0:500]';
vertices1 = [x2 y2];
faces = [1:501 1002:-1:502];

subplot(1,3,3)
hold on
plot(0:1:500,out.mag_fft_mean,'color',color);
patch('vertices',vertices1,'faces',faces,'Facecolor',color,'Edgecolor','none');
xlabel('Frequency (Hz)')
ylabel('Amplitude FFT')
xlim([0 50])
% axis([0 50 0 1]);
title('Mag')
hold off
alpha(0.3);



