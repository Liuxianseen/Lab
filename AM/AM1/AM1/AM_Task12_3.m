% Task 12_3
S_d = spv(array,[90,0]);
S_j = spv(array,[30,0;35,0]);
P = fpoc(S_j);
w = P * S_d;
yt = w'*X_im;
yt_im_nor = mapminmax(yt, 0, 255);
displayimage(yt_im_nor, image_size, 201,'interference cancellation and signal received using superresolution beamformer for 90');
Z=pattern(array, w);
plot2d3d(Z, [0:180], 0, 'gain in dB','superresolution beamformer array pattern for 90');
%%
S_d_30 = spv(array,[30,0]);
S_j_30 = spv(array,[35,0;90,0]);
P_30 = fpoc(S_j_30);
w_30 = P_30 * S_d_30;
yt_30 = w_30'*X_im;
yt_im_nor_30 = mapminmax(yt_30, 0, 255);
displayimage(yt_im_nor_30, image_size, 202,'interference cancellation and signal received using superresolution beamformer for 30');
Z_30=pattern(array, w_30);
plot2d3d(Z_30, [0:180], 0, 'gain in dB','superresolution beamformer array pattern for 30');
%%
S_d_35 = spv(array,[35,0]);
S_j_35 = spv(array,[30,0;90,0]);
P_35 = fpoc(S_j_35);
w_35 = P_35 * S_d_35;
yt_35 = w_35'*X_im;
yt_im_nor_35 = mapminmax(yt_35, 0, 255);
displayimage(yt_im_nor_35, image_size, 203,'interference cancellation and signal received using superresolution beamformer for 35');
Z_35=pattern(array, w_35);
plot2d3d(Z_35, [0:180], 0, 'gain in dB','superresolution beamformer array pattern for 35');