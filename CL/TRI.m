close all
clc

nT=2;
nR=2;

SNR_dB =0:1:35;     % SNR in dB as a Vactor
H = zeros(nR,nT); % H-Matrix of Channel Coefficient of MIMO
I = eye(nR);

N_Bit = 20000;
N_Symbol = N_Bit/2;
number_H=100;

z=1/sqrt(2);
map=[z+1i*z,-z+1i*z,-z-1i*z,z-1i*z];

qpsk=zeros(1, N_Symbol);
distance=zeros(4,4);
BER1=zeros(1,36);
BER2=zeros(1,36);
BER3=zeros(1,36);
d=0;
e=0;
detect1=zeros(1,4);
detect2=zeros(1,4);
detect3=zeros(1,4);

for s=1:36
    SNR = 10.^(SNR_dB(s)/10); % Absolute Value of SNR
    
    %QPSK modulation
    bit = (randn(1, N_Bit)<0.5);%random 0's and 1's
    for n=1:length(bit)/2
        I=bit(2*n-1);
        Q=bit(2*n);
        if (I==0)&&(Q==0)
            qpsk(n)=exp(1i*pi/4);%45 degrees

        elseif (I==0)&&(Q==1)
            qpsk(n)=exp(1i*3*pi/4);%135 degrees

        elseif (I==1)&&(Q==1)
            qpsk(n)=exp(1i*5*pi/4);%225 degrees

        elseif (I==1)&&(Q==0)
            qpsk(n)=exp(1i*7*pi/4);%315 degrees
        end
    end
        
    for h=1:number_H
        error_number1=zeros(1,36);
        error_number2=zeros(1,36);
        error_number3=zeros(1,36);
        
        H = (1/sqrt(2))*(randn(nR,nT)+1i*randn(nR,nT));
        Noise = (1/sqrt(2))*(randn(nR,1)+1i*randn(nR,1));
        for k=1:(N_Symbol/2)
            
            x=[qpsk(2*k-1);qpsk(2*k)];%transmitted vector
            y=(sqrt(SNR/nT))*H*x+Noise;%received signal

            for b=1:4
               for c=1:4
                   distance(b,c)=(norm(y-sqrt(SNR/nT)*H*[map(b);map(c)])).^2;
               end
            end

            distance_min=min(reshape(distance,1,4*4));

            for b=1:4              
               for c=1:4
                   if distance_min==distance(b,c)
                       d=b;
                       e=c;
                   end
               end
            end

            detect1=MLmapping(map,d,e);
            bit_original=[bit(4*k-3),bit(4*k-2),bit(4*k-1),bit(4*k)];
            error_number1(s)=error_number1(s)+sum(bit_original~=detect1);%number of errors
            
            xhat1=inv(sqrt(SNR/nT)*H)*y;
            detect2=mapping(xhat1);
            error_number2(s)=error_number2(s)+sum(bit_original~=detect2);%number of errors

            xhat2=(inv(SNR/nT*(H')*H+I))*sqrt(SNR/nT)*(H')*y;
            detect3=mapping(xhat2);
            error_number3(s)=error_number3(s)+sum(bit_original~=detect3);%number of errors
        end
        BER1(s)=BER1(s)+error_number1(s)/N_Bit;
        BER2(s)=BER2(s)+error_number2(s)/N_Bit;
        BER3(s)=BER3(s)+error_number3(s)/N_Bit;
    end
    BER1(s)=BER1(s)/number_H;
    BER2(s)=BER2(s)/number_H;
    BER3(s)=BER3(s)/number_H;
end

figure(1);
semilogy(SNR_dB,BER1,'-','LineWidth',1,'Color','r');
hold on;
semilogy(SNR_dB,BER2,'-','LineWidth',1,'Color','b');
hold on;
semilogy(SNR_dB,BER3,'-','LineWidth',1,'Color','g');
xlabel('SNR (dB)')
ylabel('Bit Error Rate')
title('Bit error rate of a 2-by-2 MIMO system with QPSK modulation')
legend({'ML','ZF','MMSE'},'location','ne');
set(gca,'yscale','log')

function [detect] = MLmapping(map,d,e)

        %first symbol
        if (real(map(d))>0)&&(imag(map(d))>0)
            detect(1)=0;%45 degrees
            detect(2)=0;%45 degrees

        elseif (real(map(d))<=0)&&(imag(map(d))>0)
            detect(1)=0;%135 degrees
            detect(2)=1;%135 degrees

        elseif (real(map(d))<=0)&&(imag(map(d))<=0)
            detect(1)=1;%225 degrees
            detect(2)=1;%225 degrees

        elseif (real(map(d))>0)&&(imag(map(d))<=0)
            detect(1)=1;%315 degrees
            detect(2)=0;%315 degrees
        end

        %second symbol
        if (real(map(e))>0)&&(imag(map(e))>0)
            detect(3)=0;%45 degrees
            detect(4)=0;%45 degrees

        elseif (real(map(e))<=0)&&(imag(map(e))>0)
            detect(3)=0;%135 degrees
            detect(4)=1;%135 degrees

        elseif (real(map(e))<=0)&&(imag(map(e))<=0)
            detect(3)=1;%225 degrees
            detect(4)=1;%225 degrees

        elseif (real(map(e))>0)&&(imag(map(e))<=0)
            detect(3)=1;%315 degrees
            detect(4)=0;%315 degrees
        end
end
function [detect] = mapping(xhat)

        %first symbol
        if (real(xhat(1,1))>0)&&(imag(xhat(1,1))>0)
            detect(1)=0;%45 degrees
            detect(2)=0;%45 degrees

        elseif (real(xhat(1,1))<=0)&&(imag(xhat(1,1))>0)
            detect(1)=0;%135 degrees
            detect(2)=1;%135 degrees

        elseif (real(xhat(1,1))<=0)&&(imag(xhat(1,1))<=0)
            detect(1)=1;%225 degrees
            detect(2)=1;%225 degrees

        elseif (real(xhat(1,1))>0)&&(imag(xhat(1,1))<=0)
            detect(1)=1;%315 degrees
            detect(2)=0;%315 degrees
        end
        
        if (real(xhat(2,1))>0)&&(imag(xhat(2,1))>0)
            detect(3)=0;%45 degrees
            detect(4)=0;%45 degrees

        elseif (real(xhat(2,1))<=0)&&(imag(xhat(2,1))>0)
            detect(3)=0;%135 degrees
            detect(4)=1;%135 degrees

        elseif (real(xhat(2,1))<=0)&&(imag(xhat(2,1))<=0)
            detect(3)=1;%225 degrees
            detect(4)=1;%225 degrees

        elseif (real(xhat(2,1))>0)&&(imag(xhat(2,1))<=0)
            detect(3)=1;%315 degrees
            detect(4)=0;%315 degrees
        end
end
