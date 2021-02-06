% Yibing Liu  01939400
% CL experiment

clear all
N = 100000;                  % Generate 10000 
SNR_dB = 0:5:30;                    % SNR is from 0 to 30dB
%
for nt= 1:4
    for n=1:length(SNR_dB)
        SNR = 10^(SNR_dB(n)/10);
        CH_total= 0;
        for m=1:N
            H = sqrt(1/2)*(randn(6,6)+1i*(randn(6,6)));
            CH=sqrt(1/2)*(det(eye(6)+SNR/nt*(H*H')));
            CH_total= CH_total+CH;
        end
        CH_av=CH_total/N;
    end
end


            

