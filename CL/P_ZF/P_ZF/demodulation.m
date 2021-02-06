function rx_demodu=demodulation(rx_deci,BITS)
%对每条天线上判决后得到的符号（行向量）进行解调
len=length(rx_deci);
if BITS==1
    rx_demodu=(rx_deci+1)/2;
elseif BITS==2
    inp=reshape(rx_deci*sqrt(2),len,1);
    r=real(inp);
    i=imag(inp);
    outp=([r i]+1)/2;
    rx_demodu=reshape(outp',1,2*len);
elseif BITS==4
    table=[0 0;0 1;1 0;1 1];
    inp=reshape(rx_deci*sqrt(10),len,1);
    r=floor((real(inp)+5)/2);%[-3 -1 1 3]->[1 2 3 4],用以对应table的各行数据
    i=floor((imag(inp)+5)/2);
    outp1=table(r,:);
    outp2=table(i,:);
    outp=[outp1 outp2];
    rx_demodu=reshape(outp',1,4*len);
elseif BITS==6
    table=[0 0 0;0 0 1;0 1 0;0 1 1;1 0 0;1 0 1;1 1 0;1 1 1];
    inp=reshape(rx_deci*sqrt(42),len,1);
    r=floor((real(inp)+9)/2);%[-7 -5 -3 -1 1 3 5 7]->[1 2 3 4 5 6 7 8]
    i=floor((imag(inp)+9)/2);
    outp1=table(r,:);
    outp2=table(i,:);
    outp=[outp1 outp2];
    rx_demodu=reshape(outp',1,6*len);
end