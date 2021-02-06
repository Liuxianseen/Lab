% Task 11
S=spv(array,directions);
Rmm=[1 1 0;1 1 0;0 0 1];
sigma2=0.0001;
Rxx=S*Rmm*S'+sigma2*eye(5,5);
Z=music(array,Rxx,3);
plot2d3d(Z,[0:180],0,'dB','MuSIC spectrum')
% 
% Rxx=ssp(Rxx_theorety,5);
% Z=music(array,Rxx,3);
% plot(Z,[0:180],0,'dB','MuSIC spectrum');