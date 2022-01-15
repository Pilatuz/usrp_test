% plot the dumped data
clear; close all;

Fs = 125e6/8;
Nfft = 2*1024;
Navg = 16;
Nskip = 10000;

in_pattern = '~/Downloads/dump5/ofdm_rx_fs=15.625MHz_f0=%dMHz_txgain=%.0fdB_rxgain=%.0fdB_shift=2500kHz_%s.dat';
out_pattern = './data/sine_rx_fs=15.625MHz_rxgain=%.1fdB_txgain=%.1fdB_shift=2500kHz.png';

tx_gain = 10 %for tx_gain = [10,30,50]
rx_gain = 50 %for rx_gain = [10,30,50]
printf('rx=%.0fdB tx=%.0fdB\n', rx_gain, tx_gain);

f = fopen(sprintf(in_pattern, 2500, tx_gain, rx_gain, 'cal_def_def'));
x = fread(f, Inf, 'float32');
fclose(f);
a = x(1:2:end) + 1j*x(2:2:end);

aa = reshape(a(Nskip+1:Nskip+Nfft*Navg), Nfft, Navg);

aaa = mean(abs(fftshift(fft(aa))),2);

h = figure(1,"position",get(0,"screensize"));
grid on; hold on;
plot((-Nfft/2:Nfft/2-1)*Fs/Nfft*1e-3, 10*log10(aaa), 'b-x');
legend('2.5GHz');
xlabel('frequency, kHz');
ylabel('magnitude, dB');
title(sprintf('Tone shift=2.5MHz rx=%.0fdB tx=%.0fdB', rx_gain, tx_gain));
saveas(h, sprintf(out_pattern, rx_gain, tx_gain), 'png');
close(h);

%endfor % rx_gain
%endfor % tx_gain
