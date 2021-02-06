% Task 13
array=[-2 0 0; -1 0 0; 0 0 0; 1 0 0; 2 0 0];
directions = [30, 0; 35, 0 ; 90, 0];
Num_receiver = 5;
Num_source = 3;
SS = spv(array, directions);                   %Known signal source and manifold vector                    
sigma2=0.0001;                                                 
Rmm = eye(Num_source);   
L = 250;                                       %Generate L snapshots of x(t)
Rxx_theoretical = SS*Rmm*SS'+sigma2*eye(Num_receiver); 
[EV,D]=eig(Rxx_theoretical);
z_tl = zeros(Num_receiver,L);
x_tl = zeros(Num_receiver,L);
for i = 1 : L
    z_tl(:,i) = (randn(Num_receiver,1)+1i*randn(Num_receiver,1))/sqrt(2);
    x_tl(:,i) = EV * sqrt(D) * z_tl(:,i); 
end

Rxx_practical = x_tl * x_tl'/L;
[EV_p,D_p]=eig(Rxx_practical);
eigenvalues=sort(diag(D_p),'descend');

% criterion
for k = 0 : Num_receiver-1
    index = 1/(Num_receiver-k);
    %get geometric mean and arithmetic mean
    geometric = prod(eigenvalues(k+1:Num_receiver)).^(index); 
    arithmetic = index * sum(eigenvalues(k+1:Num_receiver));
    %using AIC equation and MDL equation from paper
    AIC(k+1) = -2*L*log(((geometric/arithmetic)^((Num_receiver-k))))+2*k*(2*Num_receiver-k); 
    MDL(k+1) = -L*log(((geometric/arithmetic)^((Num_receiver-k))))+0.5*k*(2*Num_receiver-k)*log(L);
end    
[AIC_value_min,num_sources]=min(AIC);
[MDL_value_min,num_sources]=min(MDL);
num_sources = num_sources-1;       %retrieve 1 because the value k=0 is stocked in the index 1.

%retrieve 1 because the value k=0 is stocked in the index 1.

plot(0:Num_receiver-1,AIC);
grid;
hold on
plot(0:Num_receiver-1,MDL);
hold on
plot(num_sources,AIC_value_min,'ro');
hold on
plot(num_sources,MDL_value_min,'ro');

hold off
ylabel('Criterion value')
xlabel('Number of sources')
title("AIC and MDL criteria");