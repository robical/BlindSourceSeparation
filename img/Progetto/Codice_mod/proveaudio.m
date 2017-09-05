clear all;
close all;

%creazione finestra
M=512;
win=hamming(M);

%I segnali importati devono essere tutti campionati alla stessa frequenza
%di campionamento
% [signal1,Fs1]=wavread('Urlo22.wav');   %sono tutti importati come vettori colonna
% [signal2,Fs2]=wavread('Toms_diner22.wav');
% [signal3,Fs3]=wavread('nonmisomiglia22.wav');
f1=50;
f2=100;
f3=200;
fc=1e3; %campiono a 1 Khz
t=0:1/fc:4-1/fc; %durata: 4 secondi
signal1=cos(2*pi*f1*t);
signal2=cos(2*pi*f2*t);
signal3=cos(2*pi*f3*t);

rit1=160;
rit2=560;
rit3=800;

%definizione segnali al mic2 (ritardati)
signal1r=[zeros(1,rit1) signal1];
signal2r=[zeros(1,rit2) signal2];
signal3r=[zeros(1,rit3) signal3];

%calcolo la lunghezza massima
maxl=max([length(signal1r) length(signal2r) length(signal3r)]);
minl=min([length(signal1) length(signal2) length(signal3)]);

signal1=[signal1 zeros(1,(maxl-minl))];
signal2=[signal2 zeros(1,(maxl-minl))];
signal3=[signal3 zeros(1,(maxl-minl))];
signal1r=[signal1r zeros(1,(maxl-length(signal1r)))];
signal2r=[signal2r zeros(1,(maxl-length(signal2r)))];
signal3r=[signal3r zeros(1,(maxl-length(signal3r)))];


[F1]=stft(signal1',win,maxl);
[F2]=stft(signal2',win,maxl);
[F3]=stft(signal3',win,maxl);

%Segnale somma e trasformate al mic1 e al mic2
oss1=signal1+signal2+signal3;
oss2=signal1r+signal2r+signal3r;
[Yos1]=stft(oss1',win,maxl);
[Yos2]=stft(oss2',win,maxl);

fk=-fc/2:fc/M:fc/2; %asse freq discrete
tk=0:(M/fc):(maxl/fc); 

figure(1); imagesc(tk,fk,abs(Yos1));
figure(2); imagesc(tk,fk,abs(Yos2));


