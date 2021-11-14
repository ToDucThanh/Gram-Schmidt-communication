function X = ReceiverRealization()
clc;

fs = 1000; % Sampling frequency

% Create orthonormal basis functions
phi1 = [( 1/sqrt(3))*ones(1,fs) ( 1/sqrt(3))*ones(1,fs) (-1/sqrt(3))*ones(1,fs)];
phi2 = [( 1/sqrt(6))*ones(1,fs) ( 1/sqrt(6))*ones(1,fs) ( 2/sqrt(6))*ones(1,fs)];
phi3 = [0*ones(1,fs) 0*ones(1,fs) 0*ones(1,fs)];
phi4 = [( 1/sqrt(2))*ones(1,fs) (-1/sqrt(2))*ones(1,fs) 0*ones(1,fs)];

% Vectorized
s1 = [(2/sqrt(3)) (sqrt(6)/3) 0 0]; % Coordinates are found by calculating the wanted signal projection on to the respective axis e.g. 2/sqrt(3) = s11
s2 = [0 0 0 sqrt(2)];
s3 = [(sqrt(3)) 0 0 0];
s4 = [(-1/sqrt(3)) (-4/sqrt(6)) 0 0];

% Based on these orthonormal basis functions, create the four symbol waveforms
sig_s1 = (2/sqrt(3))*phi1 + (sqrt(6)/3)*phi2 + 0*phi3 + 0*phi4;
sig_s2 = 0*phi1 + 0*phi2 + 0*phi3 + sqrt(2)*phi4;
sig_s3 = (sqrt(3))*phi1 + 0*phi2 + 0*phi3 + 0*phi4;
sig_s4 = (-1/sqrt(3))*phi1 + (-4/sqrt(6))*phi2 + 0*phi3 + 0*phi4;

figure(1)
n = 1/fs:1/fs:3;

subplot(2,2,1)
plot(n,sig_s1,'LineWidth',2.5);grid on;
xlim([0 4])
ylim([-1.5 1.5])
xlabel('Time(n)')
ylabel('Amplitude')
title('s1(t)')

subplot(2,2,2)
plot(n,sig_s2,'LineWidth',2.5);grid on;
xlim([0 4])
ylim([-1.5 1.5])
xlabel('Time(n)')
ylabel('Amplitude')
title('s2(t)')

subplot(2,2,3)
plot(n,sig_s3,'LineWidth',2.5);grid on;
xlim([0 4])
ylim([-1.5 1.5])
xlabel('Time(n)')
ylabel('Amplitude')
title('s3(t)')

subplot(2,2,4)
plot(n,sig_s4,'LineWidth',2.5);grid on;
xlim([0 4])
ylim([-1.5 1.5])
xlabel('Time(n)')
ylabel('Amplitude')
title('s4(t)')

% Data stearm
rx_sig = [sig_s1 sig_s4 sig_s3 sig_s3 sig_s1 sig_s4 sig_s1 sig_s2 sig_s1 sig_s1];
org_msg = [];
for i = 1:1:10
    if (rx_sig(((i-1)*3*fs+1):1:(i*3*fs)) == sig_s1)
        org_msg = [org_msg 1];
    elseif (rx_sig(((i-1)*3*fs+1):1:(i*3*fs)) == sig_s2)
        org_msg = [org_msg 2];
    elseif (rx_sig(((i-1)*3*fs+1):1:(i*3*fs)) == sig_s3)
        org_msg = [org_msg 3];
    else
        org_msg = [org_msg 4];
    end
end

d1 = [];
d2 = [];
d4 = [];
for i = 1:1:10
    d1 = [d1 sum(rx_sig(((i-1)*3*fs+1):1:(i*3*fs)).*phi1)];
    d2 = [d2 sum(rx_sig(((i-1)*3*fs+1):1:(i*3*fs)).*phi2)];
    d4 = [d4 sum(rx_sig(((i-1)*3*fs+1):1:(i*3*fs)).*phi4)];
end
d1 = d1/fs;
d2 = d2/fs;
d4 = d4/fs;

rec_msg = [];
for i = 1:1:10
    [value, sym] = min([sum((s1 - [d1(i) d2(i) 0 d4(i)]).^2) sum((s2 - [d1(i) d2(i) 0 d4(i)]).^2) sum((s3 - [d1(i) d2(i) 0 d4(i)]).^2) sum((s4 - [d1(i) d2(i) 0 d4(i)]).^2)]);
     rec_msg = [rec_msg sym];
end

figure(2)
n_msg = 0:1:9;

subplot(1,2,1)
stem(n_msg,org_msg,'LineWidth',2.5);grid on;
xlim([0 11])
ylim([-.5 5])
xlabel('Time(n)')
ylabel('Symbol index')
title('Original message')

subplot(1,2,2)
stem(n_msg,rec_msg,'LineWidth',2.5);grid on;
xlim([0 11])
ylim([-.5 5])
xlabel('Time(n)')
ylabel('Symbol index')
title('Recovered message')