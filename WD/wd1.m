close all;
clc;
m=128;
n=256;
A=normc(rand(m,n));
x=randn(n,1);
y=A*x;
x1=pinv(A)*y;
x2=A\y;