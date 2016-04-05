function [] = get_freq_components(stats,N)

stats_len = get_stats_with_len(stats,N);
tstruct = stats_len.traj_struct;

x_mat = arrayfun(@(x) x.traj_x(1:N),tstruct,'UniformOutput',0);
y_mat = arrayfun(@(x) x.traj_y(1:N),tstruct,'UniformOutput',0);

for i=1:length(x_mat)
 x_mat_arr(i,:) = x_mat{i};
end

for i=1:length(y_mat)
 y_mat_arr(i,:) = y_mat{i};
end

x_fft = arrayfun(@(x) abs(fft(x_mat_arr(x,:))),1:length(x_mat),'UniformOutput',0);
y_fft = arrayfun(@(x) abs(fft(y_mat_arr(x,:))),1:length(y_mat),'UniformOutput',0);

for i=1:length(x_fft)
 x_fft_arr(i,:) = x_fft{i};
end

for i=1:length(y_fft)
 y_fft_arr(i,:) = y_fft{i};
end

x_psd = (1/(N*1000))*x_fft_arr(:,1:end/2+1).^2;
x_psd = 10*log10(x_psd(:,2:end-1));

y_psd = (1/(N*1000))*y_fft_arr(:,1:end/2+1).^2;
y_psd = 10*log10(y_psd(:,2:end-1));

x_psd_mean = mean(x_psd(:,1:100));
y_psd_mean = mean(y_psd(:,1:100));

figure;
subplot(1,2,1)

plot(0:1:99,x_psd_mean(1:100));
xlabel('Frequency (Hz)')
ylabel('Power/Frequency (dB/Hz)')
axis([0 100 -70 0]);
title('X')

subplot(1,2,2)

plot(0:1:99,y_psd_mean(1:100));
xlabel('Frequency (Hz)')
ylabel('Power/Frequency (dB/Hz)')
axis([0 100 -70 0]);
title('Y')
