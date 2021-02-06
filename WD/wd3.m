close all;
clc;

m=128;
n=256;
N=500;  %Number of tests
S=3:3:63;
succ_omp=zeros(1,length(S));
succ_sp=zeros(1,length(S));
succ_iht=zeros(1,length(S));
for Sn=1:1:length(S)
    succ_numo=0;
    succ_numsp=0;
    succ_numiht=0;
    
    for t=1:1:N
        A=normc(randn(m,n));
        x=zeros(n,1);
        suppSet = randsample(n,S(Sn));
        x(suppSet,:)=randn(length(suppSet),1);
        y=A*x;
        %OMP Algorithm
        xs=zeros(n,1);
        yr=y;
        index=zeros(S(Sn),1);
        for i = 1:1:S(Sn)
            proj=A'*yr;
            pos=find(abs(proj)==max(abs(proj)));
            pos=pos(1);
            index(i)=pos;
            xs=zeros(n,1);
            xs(index(1:i))=A(:,index(1:i))\y;
            yr=y-A*xs;
        end
        xomp=xs;
        %SP Algorithm
        proj = A'*y;
        [var,pos]=sort(abs(proj),'descend');
        T=[];
        T=union(T,pos(1:S(Sn)));
        yr=y-A*A'*y;
        while(1)
            proj=A'*yr;
            [~,pos]=sort(abs(proj),'descend');
            T_add=union([],pos(1:S(Sn)));
            T=union(T,T_add);
            bs=zeros(n,1);
            bs(T)=A(:,T)\y;
            [~,pos]=sort(abs(bs),'descend');
            T=union([],pos(1:S(Sn)));
            xs=zeros(n,1);
            xs(T)=A(:,T)\y;
            yr_n=y-A*xs;
            if (norm(yr_n,2)/norm(y,2)<1e-6||norm(yr_n,2)>=norm(yr,2))
                break;
            end
            yr=yr_n;
        end
        xsp=xs;
        %IHT Algorithm
        xs=zeros(n,1);
        yr=y-A*xs;
        while(1)
            xs=xs+A'*(y-A*xs);
            [val,pos]=sort(abs(xs),'descend');
            xs(pos(S(Sn)+1:n))=0;
            yr_n=y-A*xs;
            if ((norm(yr_n,2)/norm(y,2)<1e-6)||norm(yr_n,2)>norm(yr,2))
                break;
            end
            yr=yr_n;
        end
        xiht=xs;
        
        if ((norm(xomp-x,2)/norm(x))<1e-6)
            succ_numo=succ_numo+1;
        end
        if (norm(xsp-x,2)/norm(x)<1e-6)
            succ_numsp=succ_numsp+1;
        end
        if (norm(xiht-x,2)/norm(x)<1e-6)
            succ_numiht=succ_numiht+1;
        end
    end 
    succ_omp(Sn)=succ_numo/N;
    succ_sp(Sn)=succ_numsp/N;
    succ_iht(Sn)=succ_numiht/N;
end

plot(S,succ_omp);
hold on;
plot(S,succ_sp);
hold on;
plot(S,succ_iht);
xlabel('S');
ylabel('Success Rate');
legend('OMP','SP','IHT');
