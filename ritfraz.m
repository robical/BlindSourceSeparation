function [sign]=ritfraz(signal,rita)


N=length(signal);
FT1=1/N*fft(signal);
k1=0:N/2;
esp1=exp(-i*2*pi*(k1/N)*rita);  %il ritardo è già in numero di campioni       
esp1=esp1';
FT1(1:N/2+1,1)=FT1(1:N/2+1,1).*esp1;
k2=N/2+1:N-1;
esp2=exp(-i*2*pi*(k2/N-1)*rita);
esp2=esp2';
FT1(N/2+2:N,1)=FT1(N/2+2:N,1).*esp2;

sign=ifft(FT1,'symmetric')*N;