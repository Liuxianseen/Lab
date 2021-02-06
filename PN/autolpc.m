function [A, G, r, a] = autolpc(x, p)
%AUTOLPC Autocorrelation Method for LPC
% Usage: [A, G, r, a] = autolpc(x, p)
% x : input samples
% p : order of LPC
% A : prediction error filter, (A = [1; -a])
% G : rms prediction error
% r : autocorrelation coefficients
% a : predictor coefficients
x = x(:);
L = length(x);
r = zeros(p+1,1);
for i=0:p
   r(i+1) = x(1:L-i)' * x(1+i:L);
end
R = toeplitz(r(1:p));
a = R\r(2:p+1);   
A = [1; -a];
G = sqrt(sum(A.*r));
end