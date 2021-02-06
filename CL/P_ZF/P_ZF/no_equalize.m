function BER=no_equalize(modu,Nt,Nr)
%线性均衡算法（ZF、MMSE）
loop=1000;
num=120;
EbNo=0:35;%信噪比向量
idx=1;
%*****判断调制方式*********
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
    errors=zeros(1,loop);%单个信噪比对应的误码率向量
    for i=1:loop        
        x=randn(1,num*Nt)>0;%产生信号
        tx_bits=reshape(x,Nt,num);%将信号分配到各天线上
        %*****对发送信号进行调制*********
        for a1=1:Nt
            tx_modu(a1,:)=modulation(tx_bits(a1,:),BITS);
        end
        %*****通过信道，加入高斯白噪声************
        H=(randn(Nr,Nt)+j*randn(Nr,Nt))/sqrt(2);
        [m,n]=size(tx_modu);
        spow=sum(sum(abs(tx_modu).^2))/(m*n); 
        attn=0.5*spow/10.^(SNR/10);
        attn=sqrt(attn);
        inoise=(randn(Nt,num/BITS)+j*randn(Nt,num/BITS))*attn;
        r=H*tx_modu+inoise;
        %*****ZF均衡*************
%         switch alg
%             case 'ZF'
%                 G=pinv(H);
%         %*****MMSE均衡*************   
%             case 'MMSE'
%                 G=inv(H'*H+Nt/(10^(0.1*SNR))*eye(Nt))*H';
%         end
%         rx_equal=G*r;
        %*****判决，解调*************
%         rx_deci=decision(rx_equal,BITS);
          rx_deci=decision(r,BITS);
        for a2=1:Nt
            rx_demodu(a2,:)=demodulation(rx_deci(a2,:),BITS);
        end        
        %*****计算误码率*************
        errors(i)=sum(sum(rx_demodu~=tx_bits))/(Nt*num);
    end
    BER(idx)=sum(errors)/loop;%总的误码率向量
    idx=idx+1;
end