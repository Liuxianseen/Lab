 % Exercise 2
load('s5.mat');
L=320;                    % Hamming window of 320 samples
win= hamming(L);
SH=s5(15800:15800+319);   % select the suit length array for window
AA=s5(17000:17000+319);
SH_win=SH.*win;
AA_win=AA.*win;
[A1,G1,r1,a1]=autolpc(SH_win,12);
[A2,G2,r2,a2]=autolpc(AA_win,12);
%%
plot(AA);
hold on;
plot(win.*AA);
title("signal AA compared with windowed signal");
legend('AA','windowed AA');

%%
SH_freq=freqz(A1,1,8000,'whole');        % use the function freqz to get the frequency responses
SH_vtm_filter=freqz(G1,A1,8000,'whole'); % A is prediction error filter, G/A is the vocal
figure(1);
plot(20*log10(abs(SH_vtm_filter)));       % get the log magnitude 
hold on;
plot(20*log10(abs(SH_freq)));
title('The prsdiction error filter and The vocal tract model filter for"SH"');
xlabel('Frequency(Hz)');
ylabel('magnitudue(dB)');
legend('The vocal tract model filter for "SH"','The prsdiction error filter for "SH"')
%%
AA_freq=freqz(A2,1,8000,'whole');
AA_vtm_filter=freqz(G2,A2,8000,'whole');
figure(2);
plot(20*log10(abs(AA_vtm_filter)));
hold on;
plot(20*log10(abs(AA_freq)));
title('The prsdiction error filter and The vocal tract model filter for"AA"');
xlabel('Frequency(Hz)');
ylabel('magnitudue(dB)');
legend('The vocal tract model filter for "AA"','The prsdiction error filter for "AA"')
%%
figure(3)       % find the zeros of the prediction error filter for both cases
zplane(A1');
title(' zeros of the prediction error filter for "SH"');
figure(4)
zplane(A2')
title(' zeros of the prediction error filter for "AA"');
%%
% Exercise 3
figure(5)                  % get DFT for SH
SH_DFT=fft(SH,8000);
SH_DFT_win=fft(SH_win,8000);
plot(20*log10(abs(SH_DFT)));
hold on;
plot(20*log10(abs(SH_DFT_win)));
% hold on;
% plot(20*log10(abs(SH_vtm_filter)));
title('The DFT of the windowed segment and vocal tract model for "SH"');
xlabel('Frequency(Hz)');
ylabel('magnitudue(dB)');
legend('no ','DFT for "SH"','vocal tract model for "SH"');
%%
figure(6)                 % get DFT for AA
AA_DFT=fft(AA_win,8000);
plot(20*log10(abs(AA_DFT)));
hold on;
plot(20*log10(abs(AA_vtm_filter)));
title('The DFT of the windowed segment and vocal tract model for "AA"');
xlabel('Frequency(Hz)');
ylabel('magnitudue(dB)');
legend('DFT for "AA"','vocal tract model for "AA"');


% Exercise 4
OO=s5(7200:7200+319);
OO_win=OO.*win;
OO_DFT=fft(OO_win,8000);
[A3,G3,r3,a3]=autolpc(OO_win,12);
OO_vtm_filter=freqz(G3,A3,8000,'whole');
figure(7)
plot(20*log10(abs(OO_DFT)));
hold on;
plot(20*log10(abs(OO_vtm_filter)));
title('The DFT of the windowed segment and vocal tract model for "O"');
xlabel('Frequency(Hz)');
ylabel('magnitudue(dB)');
legend('DFT for "O"','vocal tract model for "O"');

II=s5(14500:14500+319);
II_win=II.*win;
II_DFT=fft(II_win,8000);
[A4,G4,r4,a4]=autolpc(II_win,12);
II_vtm_filter=freqz(G4,A4,8000,'whole');
figure(8)
plot(20*log10(abs(II_DFT)));
hold on;
plot(20*log10(abs(II_vtm_filter)));
title('The DFT of the windowed segment and vocal tract model for "I"');
xlabel('Frequency(Hz)');
ylabel('magnitudue(dB)');
legend('DFT for "I"','vocal tract model for "I"');
%%
plot(OO);
hold on;
plot(II);
title("time domain of 'OO'and'II'");
legend('OO','II');
%%
% Exercise 5
% We choose SH in this part, [A1,G1,r1,a1]=autolpc(SH_win,12);
[A_p8,G_p8,r_p8,a_p8]=autolpc(SH_win,8);
SH_vtm_filter_p8=freqz(G_p8,A_p8,8000,'whole');
[A_p10,G_p10,r_p10,a_p10]=autolpc(SH_win,10);
SH_vtm_filter_p10=freqz(G_p10,A_p10,8000,'whole');
[A_p20,G_p20,r_p29,a_p20]=autolpc(SH_win,20);
SH_vtm_filter_p20=freqz(G_p20,A_p20,8000,'whole');
figure(9)
plot(20*log10(abs(SH_DFT_win)));
hold on;
plot(20*log10(abs(SH_vtm_filter_p8)));
hold on;
plot(20*log10(abs(SH_vtm_filter_p10)));
hold on;
plot(20*log10(abs(SH_vtm_filter)));
hold on;
plot(20*log10(abs(SH_vtm_filter_p20)));
xlabel('Frequency(Hz)');
ylabel('magnitudue(dB)');
legend('DFT for "SH"','vocal tract model for "SH" in p=8', ...
    'vocal tract model for "SH" in p=10', ...
    'vocal tract model for "SH" in p=12', ...
    'vocal tract model for "SH" in p=20');

% Exercise 6
y = filter([1, 0.2], 1, s5);
SH_y=y(15800:15800+319);
SH_y_win=SH_y.*win;
[A_y,G_y,r_y,a_y]=autolpc(SH_y_win,12);
SH_y_freq=freqz(A_y,1,8000,'whole');
figure(10)
plot(20*log10(abs(SH_freq)));
hold on;
plot(20*log10(abs(SH_y_freq)));
title('Comparison for whether apply a preemphasis filter');
xlabel('Frequency(Hz)');
ylabel('magnitudue(dB)');
legend('Without new filter','With new filter');
