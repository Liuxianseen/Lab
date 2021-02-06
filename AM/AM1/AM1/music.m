
function Z=music(array,Rxx,sources_num)
% [eigvector,eigvalue]=eig(Rxx);     %find the eigvector and eigvalue
% [eigvalue,I]=sort(sum(eigvalue),'descend');   %sort the eigvalue
% eigvector_s=eigvector(:,I);                    
% source=eigvector_s(:,1:sources_num);
% for theta=1:180
%     Sp=spv(array,[theta,0]);
%     Z(theta)=Sp'*(eye(5)-fpo(source))*Sp;
% end
% Z=-10*log10(Z);

for iang = 1:361
    angle(iang)=(iang-181)/2;
    phim=derad*angle(iang);
    a=exp(-1i*2*pi*d*sin(phim)).'; 
    En=EV(:,M+1:N);                   % 取矩阵的第M+1到N列组成噪声子空间
    Pmusic(iang)=1/(a'*En*En'*a);
end
Pmusic=abs(Pmusic);
Pmmax=max(Pmusic)
Pmusic=10*log10(Pmusic/Pmmax);            % 归一化处理


end