close all;
clc;

m=128;
n=256;
S=12;
A=normc(randn(m,n));
x=zeros(n,1);
suppSet = randsample(n,S);
x(suppSet,:)=randn(length(suppSet),1);
y=A*x;
x1=pinv(A)*y;
x2=A\y;
%OMP Algorithm
xs=zeros(n,1);
yr=y;
index=zeros(S,1);
for i = 1:1:S
    proj=A'*yr;
    pos=find(abs(proj)==max(abs(proj)));
    pos=pos(1);
    index(i)=pos;
    xs=zeros(n,1);
    xs(index(1:i))=A(:,index(1:i))\y; 
    yr=y-A*xs;   
end
x_OMP=xs;
%SP Algorithm
proj = A'*y;
[var,pos]=sort(abs(proj),'descend');
T=[];
T=union(T,pos(1:S));
yr=y-A*A'*y;
while(1)
    proj=A'*yr;
    [~,pos]=sort(abs(proj),'descend');
    T_add=union([],pos(1:S));
    T=union(T,T_add);
    bs=zeros(n,1);
    bs(T)=A(:,T)\y;
    [~,pos]=sort(abs(bs),'descend');
    T=union([],pos(1:S));
    xs=zeros(n,1);
    xs(T)=A(:,T)\y;
    yr_n=y-A*xs;
    if (norm(yr)^2/norm(y)^2<1e-6||norm(yr_n)>norm(yr))
        break;
    end
    yr=yr_n;
end
x_SP=xs;
%HIT Algorithm
xs=zeros(n,1);
yr=y-A*xs;
while(1)
    xs=xs+A'*(y-A*xs);
    [val,pos]=sort(abs(xs),'descend');
    xs(abs(xs)<min(val(S)))=0;
    yr_n=y-A*xs;
    if ((norm(yr_n,2)/norm(y,2)<1e-6)||norm(yr_n,2)>norm(yr,2))
        break;
    end
    yr=yr_n;
end
x_IHT=xs;