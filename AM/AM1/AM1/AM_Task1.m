% AM Array Communications & Processing

array=[-2 0 0;-1 0 0;0 0 0;1 0 0;2 0 0];
direction=[30,0;35,0;90,0];
%%
% Task 1: Form the  of the above array.
% jay=sqrt(-1);
% theta=direction(:,1);
% r_x=array(:,1)';
% Z_direction=exp(-jay*pi*r_x*cos(30*pi/180))';
% array(:,1)=Z_direction;                        SPV in x direction
Z=pattern(array);
figure(1)
plot2d3d(Z,[0:180],0,'gain in dB','initial pattern');
% for 30, gain is -2.95dB; for 35, gain is -8.066dB; for 90. gain is 6.99dB

% Task 2: Theoretical Covariance Matrix Formation:
S=spv(array, direction);    % we can get a 5*3 array and it is just the Source Position Vectors:
Rmm=eye(length(direction));
sigma2=0.0001;
Rxx_theoretical=S*Rmm*S'+sigma2*eye(5,5);

%%
% Task 3: Practical Covariance Matrix:
load Xaudio.mat;
load Ximage.mat;
soundsc(abs(X_au(2,:)), 11025);
displayimage(X_im(2,:),image_size, 201,'The received signal at the 2nd antenna');
Rxx_au= X_au* X_au'/length(X_au(1,:));
Rxx_im= X_im* X_im'/length(X_im(1,:));

%%
% Task 4
directions=[];
Rmm=[];
S=[];
sigma2=[];

% Task 5: Detection Problem
Eig=eig(Rxx_theoretical);
Eig_au=eig(Rxx_au);
Eig_im=eig(Rxx_im);

%%
% Task 6: Estimation Problem 
Sd=spv(array,[90,0]);
a=6.99;
wopt= a*inv(Rxx_theoretical)*Sd;                    % optimum Wiener-Hopf solution
Z=pattern(array, wopt);
plot2d3d(Z,[0:180], 0, 'gain in dB','W-H array pattern');
