function BER=no_equalize(modu,Nt,Nr)
%���Ծ����㷨��ZF��MMSE��
loop=1000;
num=120;
EbNo=0:35;%���������
idx=1;
%*****�жϵ��Ʒ�ʽ*********
switch modu  
    case 'BPSK'
        BITS=1;
    case 'QPSK'
        BITS=2;
    case '16QAM'
        BITS=4;
    case '64QAM'
        BITS=6;
end
for SNR=EbNo
    errors=zeros(1,loop);%��������ȶ�Ӧ������������
    for i=1:loop        
        x=randn(1,num*Nt)>0;%�����ź�
        tx_bits=reshape(x,Nt,num);%���źŷ��䵽��������
        %*****�Է����źŽ��е���*********
        for a1=1:Nt
            tx_modu(a1,:)=modulation(tx_bits(a1,:),BITS);
        end
        %*****ͨ���ŵ��������˹������************
        H=(randn(Nr,Nt)+j*randn(Nr,Nt))/sqrt(2);
        [m,n]=size(tx_modu);
        spow=sum(sum(abs(tx_modu).^2))/(m*n); 
        attn=0.5*spow/10.^(SNR/10);
        attn=sqrt(attn);
        inoise=(randn(Nt,num/BITS)+j*randn(Nt,num/BITS))*attn;
        r=H*tx_modu+inoise;
        %*****ZF����*************
%         switch alg
%             case 'ZF'
%                 G=pinv(H);
%         %*****MMSE����*************   
%             case 'MMSE'
%                 G=inv(H'*H+Nt/(10^(0.1*SNR))*eye(Nt))*H';
%         end
%         rx_equal=G*r;
        %*****�о������*************
%         rx_deci=decision(rx_equal,BITS);
          rx_deci=decision(r,BITS);
        for a2=1:Nt
            rx_demodu(a2,:)=demodulation(rx_deci(a2,:),BITS);
        end        
        %*****����������*************
        errors(i)=sum(sum(rx_demodu~=tx_bits))/(Nt*num);
    end
    BER(idx)=sum(errors)/loop;%�ܵ�����������
    idx=idx+1;
end