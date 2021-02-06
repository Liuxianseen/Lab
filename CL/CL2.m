close all;
clc;
xn=1000000;
SNRdB=0:1:35;
SNR = 10.^(SNRdB/10);
BEP_ML = zeros(1,length(SNRdB));
BEP_ZF = zeros(1,length(SNRdB));
BEP_MMSE = zeros(1,length(SNRdB));
nt=2;
nr=2;

i = randi([0,1],1,xn/2);                      %Generate the first bit of the modulated two bits
q = randi([0,1],1,xn/2);                      %Generate the sencond bit of the modulated two bits
si = (-2)*i+1;                                %For 1, change it to -1,for 0, change it to 1 to get the corresponding phase 
sq = (-2)*q+1;
QP_signal = (si+1i*sq)/sqrt(2);   %Mapping code into corresponding phase
code=[(1+1i),(1+1i),(1+1i),(1+1i),(-1+1i),(-1+1i),(-1+1i),(-1+1i),(-1-1i),(-1-1i),(-1-1i),(-1-1i),(1-1i),(1-1i),(1-1i),(1-1i);
     (1+1i),(-1+1i),(-1-1i),(1-1i),(1+1i),(-1+1i),(-1-1i),(1-1i),(1+1i),(-1+1i),(-1-1i),(1-1i),(1+1i),(-1+1i),(-1-1i),(1-1i)]/sqrt(2);
for n=1:length(SNRdB)
    Ctot_ML=0;
    Ctot_ZF=0;
    Ctot_MMSE=0;
    for m=1:xn/4
        H=sqrt(1/2)*(randn(nr,nt)+1i*randn(nr,nt));
        Xi=[QP_signal(2*m-1);QP_signal(2*m)];          
        Noise = sqrt(1/2)*(randn(nr,1)+1i*randn(nr,1));     %Use Noise power to generate noise signal 
        Yi=sqrt(SNR(n)/nt)*H*Xi+Noise;
        %ML Detector
        cp=zeros(1,16);
        for ii=1:16
            a=code(:,ii);
            cp(ii)=sum(abs(Yi-sqrt(SNR(n)/nt)*H*code(:,ii)).^2,1);
        end
        [~,I]=min(cp);
        Xiout_ML=code(:,I);
        CBit_ML=sum(real(Xiout_ML)==real(Xi))+sum(imag(Xiout_ML)==imag(Xi));
        Ctot_ML=Ctot_ML+CBit_ML;  
        %ZF detector
        zf=(sqrt(SNR(n)/nt)*H)^(-1)*Yi;
        Xiout_ZF=(1*sign(real(zf))+1i*sign(imag(zf)))/sqrt(2);
        CBit_ZF=sum(real(Xiout_ZF)==real(Xi))+sum(imag(Xiout_ZF)==imag(Xi)); 
        Ctot_ZF=Ctot_ZF+CBit_ZF;
        %MMSE detector
        mmse=(SNR(n)/nt*(H'*H)+eye(nt))^(-1)*sqrt(SNR(n)/nt)*H'*Yi;
        Xiout_MMSE=(1*sign(real(mmse))+1i*sign(imag(mmse)))/sqrt(2);
        CBit_MMSE=sum(real(Xiout_MMSE)==real(Xi))+sum(imag(Xiout_MMSE)==imag(Xi));
        Ctot_MMSE=Ctot_MMSE+CBit_MMSE;
    end
    BE_ML = xn-Ctot_ML;                                                %Calcaulate the number of wrong bits
    BEP_ML(n)= BE_ML/xn; 
    BE_ZF = xn-Ctot_ZF;
    BEP_ZF(n)= BE_ZF/xn;
    BE_MMSE = xn-Ctot_MMSE;
    BEP_MMSE(n)= BE_MMSE/xn;
end
semilogy(SNRdB,BEP_ML,'b','LineWidth',2);                                         %Plot the BEPs over SNR(dB)
hold on;
semilogy(SNRdB,BEP_ZF,'r','LineWidth',2);
hold on;
semilogy(SNRdB,BEP_MMSE,'g','LineWidth',2);
xlabel('SNR(dB)');
ylabel('BEP');
axis([0 35 10^-5 1]);
title("Bit error probabilities at different SNRs");
legend('ML','ZF','MMSE')
grid on;
hold on;