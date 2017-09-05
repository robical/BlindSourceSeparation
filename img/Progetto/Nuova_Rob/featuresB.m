function [theta]=featuresB(Y1,Y2,fs,fk)

%Assumo che tutti i segnali contengano parlato, dunque max freq facciamo
%esagerando il Nyquist, ovvero circa 11Khz, poichè campioniamo a 22050Hz.
%Allora c/f=lambda, cioè 340/11000=lambda in metri, e dmax per poter
%ascoltare tutte le sorgenti da -pi/2 a +pi/2 senza aliasing angolare e
%dunque di frequenza spaziale, dmax=lambda/2

f=fs/2;
c=340; %velocità
dmax=(c/2*f); %è già in metri
alfa=(4*pi*dmax)/c;  %dmax va espressa in metri, ed è la distanza massima anti-aliasing angolare per i sensori


w1=length(Y1(1,:));
l1=length(Y1(:,1));
w2=length(Y2(1,:));
l2=length(Y2(:,1));

Y1amp=reshape(abs(Y1),w1*l1,1);
Y2amp=reshape(abs(Y2),w2*l2,1);
Yamp=Y2amp./Y1amp;
FAS=angle(Y2).-angle(Y1);

for v=1:length(FAS(:,1))
    FAS(v,:)=FAS(v,:)*(alfa*fk(v));    %ok, con questo peso la feature di fase ha la stessa varianza di quelle di modulo
end

h=length(FAS(:,1));
k=length(FAS(1,:));

FASr=reshape(FAS,h*k,1);

[theta]=[Yamp FASr];
