% Task 12
Sd_au=spv(array,[90,0]);
wopt_au=pinv(Rxx_au)*Sd_au;
yt_au=wopt'* X_au;
sound(real(yt_au), 11025);

Sd_im=spv(array,[90,0]);
wopt=pinv(Rxx_im)*Sd_im;
yt_im=wopt'* X_im;
yt_im_nor = mapminmax(yt_im, 0, 255);
displayimage(yt_im_nor, image_size, 202,'The received signal at o/p of W-H beamformer');
