X = imread('autumn.tif');
I = rgb2gray(X);
imshow(I);
I = double(I(1:128,128:255));%Cut the 128x128 image data
imshow(I,[]);
title('128x128 image')
%%
siz = 16;%Block is 16x16
D = dctmtx(siz);
S = zeros(siz);
M = zeros(128);
%Only use the left top 1/4 of DCT values, set all the other part to zero.
for i = 1:128/siz
    for j = 1:128/siz
        S = D*I(siz*(j-1)+1:siz*j,siz*(i-1)+1:siz*i)*D';
        B = S(1:siz/4,1:siz/4);
        S = zeros(siz);
        S(1:siz/4,1:siz/4) = B;
        M(siz*(j-1)+1:siz*j,siz*(i-1)+1:siz*i) = idct2(S)/255;
    end
end
imshow(M)
title('128x128 reformed image with noise using 16x16 blocks DCT')
%%
X = imread('autumn.tif');
I = rgb2gray(X);
I = imnoise(I,'gaussian');%Add gaussian noise
I = double(I(1:128,128:255));%Cut the 128x128 image data
imshow(I,[]);
title('128x128 image with noise')
siz = 16;%Block is 16x16
D = dctmtx(siz);
S = zeros(siz);
M = zeros(128);
%Only use the left top 1/4 of DCT values, set all the other part to zero.
for i = 1:128/siz
    for j = 1:128/siz
        S = D*I(siz*(j-1)+1:siz*j,siz*(i-1)+1:siz*i)*D';
        B = S(1:siz/4,1:siz/4);
        S = zeros(siz);
        S(1:siz/4,1:siz/4) = B;
        M(siz*(j-1)+1:siz*j,siz*(i-1)+1:siz*i) = idct2(S)/255;
    end
end
imshow(M)
title('128x128 reformed image with noise using 16x16 blocks DCT')