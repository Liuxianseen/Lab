
%------OMP Algorithm
function[x_OMP]=OMP(S,A,y)
x_OMP=zeros(256,1);
S_set=[];
yr=y;
for l=1:S
    H1=H(1,A.'*yr);
    S_set = union(S_set,supp(H1));
    x_OMP=zeros(256,1);
    x_OMP(S_set)=A(:,S_set)\y;
    %judge stop
    yr_pre=yr;
    yr=y-A*x_OMP;
    if norm(yr,2)/norm(y,2)<1e-6||norm(yr,2)>norm(yr_pre,2)
        break;
    end
end
end

%------SP Algorithm
function[x_SP]=SP(S,A,y)
x_SP=zeros(256,1);
S_set=supp(H(S,A.'*y));
yr=resid(y,A(:,S_set));
for l=1:2*S
    S_exp=union(S_set,supp(H(S,A.'*yr)));
    b=zeros(256,1);
    b(S_exp)=A(:,S_exp)\y;
    S_set=supp(H(S,b));
    x_SP=zeros(256,1);
    x_SP(S_set)=A(:,S_set)\y;
    %judhe stop
    yr_pre=yr;
    yr=y-A*x_SP;
    if norm(yr,2)/norm(y,2)<1e-6||norm(yr,2)>norm(yr_pre,2)
        break;
    end
end
end

%-----IHT Algorithm
function[x_IHT]=IHT(S,A,y)
x_IHT=zeros(256,1);
yr=y;
while(1)
    x_IHT=H(S,x_IHT+A.'*(y-A*x_IHT));
    %judge stop
    yr_pre=yr;
    yr=y-A*x_IHT;
        if norm(yr,2)/norm(y,2)<1e-6||norm(yr,2)>norm(yr_pre,2)
        break;
        end
end
end

function [x_ad]=ad(s,a,y)

end

