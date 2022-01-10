% plot the dumped data
clear; close all;

Fs = 480e3;
Nfft = 2*1024;
Navg = 16;
Nskip = 10000;

in_pattern = '~/Downloads/tetra2/tetra/tetra_rx_fs=480kHz_f0=%dMHz_rxgain=%.1fdB_txgain=%.1fdB_shift=50kHz_bb.dat';
out_pattern = './data/tetra_rx_fs=480kHz_rxgain=%.1fdB_txgain=%.1fdB_shift=50kHz_cal.png';

for tx_gain = [10,20,30,40,50]
for rx_gain = [10,20,30,40,50]
printf('rx=%.0fdB tx=%.0fdB\n', rx_gain, tx_gain);

f = fopen(sprintf(in_pattern, 50, rx_gain, tx_gain));
x = fread(f, Inf, 'float32');
fclose(f);
a = x(1:2:end) + 1j*x(2:2:end);

f = fopen(sprintf(in_pattern, 1000, rx_gain, tx_gain));
x = fread(f, Inf, 'float32');
fclose(f);
b = x(1:2:end) + 1j*x(2:2:end);

f = fopen(sprintf(in_pattern, 2000, rx_gain, tx_gain));
x = fread(f, Inf, 'float32');
fclose(f);
c = x(1:2:end) + 1j*x(2:2:end);

f = fopen(sprintf(in_pattern, 3000, rx_gain, tx_gain));
x = fread(f, Inf, 'float32');
fclose(f);
d = x(1:2:end) + 1j*x(2:2:end);

aa = reshape(a(Nskip+1:Nskip+Nfft*Navg), Nfft, Navg);
bb = reshape(b(Nskip+1:Nskip+Nfft*Navg), Nfft, Navg);
cc = reshape(c(Nskip+1:Nskip+Nfft*Navg), Nfft, Navg);
dd = reshape(d(Nskip+1:Nskip+Nfft*Navg), Nfft, Navg);

aaa = mean(abs(fftshift(fft(aa))),2);
bbb = mean(abs(fftshift(fft(bb))),2);
ccc = mean(abs(fftshift(fft(cc))),2);
ddd = mean(abs(fftshift(fft(dd))),2);

h = figure(1,"position",get(0,"screensize"));
grid on; hold on;
plot((-Nfft/2:Nfft/2-1)*Fs/Nfft*1e-3, 10*log10(aaa), 'r-');
plot((-Nfft/2:Nfft/2-1)*Fs/Nfft*1e-3, 10*log10(bbb), 'b-');
plot((-Nfft/2:Nfft/2-1)*Fs/Nfft*1e-3, 10*log10(ccc), 'g-');
plot((-Nfft/2:Nfft/2-1)*Fs/Nfft*1e-3, 10*log10(ddd), 'k-');
legend('50MHz', '1GHz', '2GHz', '3GHz');
xlabel('frequency, kHz');
ylabel('magnitude, dB');
title(sprintf('TETRA shift=50kHz rx=%.0fdB tx=%.0fdB (force calibration)', rx_gain, tx_gain));
saveas(h, sprintf(out_pattern, rx_gain, tx_gain), 'png');
close(h);

endfor % rx_gain
endfor % tx_gain
