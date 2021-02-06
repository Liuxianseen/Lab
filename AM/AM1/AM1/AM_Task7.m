%%
% Task 7:repeat 2 4 5.1 6
S=spv(array, direction);
Rmm=eye(length(direction));
sigma2=0.1;     % here the noise is 10dB
Rxx_theoretical=S*Rmm*S'+sigma2*eye(5,5);
directions=[];
Rmm=[];
S=[];
sigma2=[];
Eig=eig(Rxx_theoretical);
Sd=spv(array,[90,0]);
a=6.99;
wopt= a*inv(Rxx_theoretical)*Sd;                    % optimum Wiener-Hopf solution
Z=pattern(array, wopt);
plot2d3d(Z,[0:180], 0, 'gain in dB','W-H array pattern');





%%

%%
% Task 9: Estimation Problem
Z = music(array, Rxx_im,3);
plot2d3d(Z,[1:180],0,'dB', 'MuSIC spectrum for Rxx__im');

