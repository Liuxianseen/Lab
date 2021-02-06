clear all,
clc

BER1=no_equalize('QPSK',4,4);
BER2=equalize('MMSE','QPSK',2,2);
BER3=equalize('MMSE','QPSK',4,4);
BER4=equalize('MMSE','QPSK',8,8);
EbNo=0:25;
figure
subplot(1,2,1)
semilogy(EbNo,BER1,'r-d');
hold on
semilogy(EbNo,BER3,'b-*');
hold on
xlabel('SNR [dB]');
ylabel('BER');
axis([0 25 1e-6 1]);
grid on
title('4x4MIMO&不同均衡算法误码性能比较');
legend('4x4-noequalize','4x4-MMSE');

subplot(1,2,2)
semilogy(EbNo,BER2,'r-d');
hold on
semilogy(EbNo,BER3,'g-*');
hold on
semilogy(EbNo,BER4,'b-o');
hold on
xlabel('SNR [dB]');
ylabel('BER');
axis([0 25 1e-6 1]);
grid on
title('不同MIMO&MMSE均衡算法误码性能比较');
legend('2x2-MMSE','4x4-MMSE','8x8-MMSE');



