
% Task 11
array=[-2 0 0; -1 0 0; 0 0 0; 1 0 0; 2 0 0];                     
directions = [30, 0; 35, 0 ; 90, 0];
Num_receiver = 5;
Num_source = 3;
SS = spv(array, directions);                                      %get 5 * 3 Source Position Vector
Rmm_uncorr = [1 0 0;0 1 0;0 0 1];                                 %uncorrelated signal
Rmm_corr = [1 1 0;1 1 0;0 0 1];                                   %correlated signal
sigma2=0.0001;                                                    
Rxx_uncorr = SS*Rmm_uncorr*SS'+sigma2*eye(Num_receiver);      
Rxx_corr = SS*Rmm_corr*SS'+sigma2*eye(Num_receiver); 
subplot(3,1,1)
Z_corr = music(array, Rxx_corr,3);
plot2d3d(Z_corr,[1:180],0,'dB', 'MuSIC spectrum for correlated signal');
subplot(3,1,2)
Z_uncorr = music(array, Rxx_uncorr,3);
plot2d3d(Z_uncorr,[1:180],0,'dB', 'MuSIC spectrum for uncorrelated signal');

Rxx=ssp(Rxx_corr,5);
subplot(3,1,3)
Z_3=music(array,Rxx,3);
plot2d3d(Z_3,[1:180],0,'dB','MuSIC spectrum');
%%
%spatial smoothing technique
[M,MM] = size(Rxx_corr);
Num_element = 4;                              %The number of element in the subarrray
Num_subarray = M - Num_element + 1;                            %The number of subarray
Rxx_window=zeros(Num_element,Num_element);
for i=1:Num_subarray%第1个子阵列到第N个子阵列
Rxx_window=Rxx_window+Rxx_corr(i:i+Num_element-1,i:i+Num_element-1);
end
Rxx_spa=Rxx_window/Num_subarray;
[EV,D]=eig(Rxx_spa);
EVA=diag(D)'; 
[EVA,I]=sort(EVA); 
EVA=fliplr(EVA);
EV=fliplr(EV(:,I));
Es = EV(:,[1 2 3]);
PEs = fpo(Es);
Pn = eye(Num_element) - PEs;
for i = 0:180
    SS = spv([-2 0 0;-1 0 0;0 0 0;1,0,0],[i,0]);
    kesai_spa(i+1) = 1/(SS'*Pn*SS);
    kesai_spa_dB(i+1) = 10*log10(kesai_spa(i+1))/Num_element;
end
plot([0:180],kesai_spa_dB);
grid on;
title('MuSIC spectrum for correlated signal but using Spatial smoothing technique')