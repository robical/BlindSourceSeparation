%FILE DEL PROGETTO DI TATA
%prova stft e risintesi di un segnale audio
 
clc;

clear all;
close all;

%creazione finestra
M=512;
win=hamming(M);

%I segnali importati devono essere tutti campionati alla stessa frequenza
%di campionamento
[signal1,Fs1]=wavread('Urlo22.wav');   %sono tutti importati come vettori colonna
[signal2,Fs2]=wavread('Toms_diner22.wav');
[signal3,Fs3]=wavread('nonmisomiglia22.wav');

%Taglio tutti i segnali in modo da renderli della stessa lunghezza del più
%corto
minl=min([length(signal1) length(signal2) length(signal3)]);
signal1=signal1([1:minl],1);
signal2=signal2([1:minl],1);
signal3=signal3([1:minl],1);

%Ritardo dei segnali (in numero di campioni)
rit1=160;
rit2=560;
rit3=800;

%definizione segnali al mic2 (ritardati)
signal1r=[zeros(rit1,1); signal1];
signal2r=[zeros(rit2,1); signal2];
signal3r=[zeros(rit3,1); signal3];

%calcolo la lunghezza massima
maxl=max([length(signal1r) length(signal2r) length(signal3r)]);


%PADDING di tutti i segnali per arrivare alla lunghezza del segnale con ritardo max
signal1=[signal1; zeros((maxl-minl),1)];
signal2=[signal2; zeros((maxl-minl),1)];
signal3=[signal3; zeros((maxl-minl),1)];
signal1r=[signal1r; zeros((maxl-length(signal1r)),1); zeros((M*round(maxl/M)-maxl),1)];
signal2r=[signal2r; zeros((maxl-length(signal2r)),1); zeros((M*round(maxl/M)-maxl),1)];
signal3r=[signal3r; zeros((maxl-length(signal3r)),1); zeros((M*round(maxl/M)-maxl),1)];


%SPLICING/FOURIER segnali sorgente al microfono 1, non ritardati
[F1]=stft(signal1,win,maxl);
[F2]=stft(signal2,win,maxl);
[F3]=stft(signal3,win,maxl);

%Segnale somma e trasformate al mic1 e al mic2
oss1=signal1+signal2+signal3;
oss2=signal1r+signal2r+signal3r;

%STFT dei segnali osservati ai 2 mics
[Yos1]=stft(oss1,win,maxl);
[Yos2]=stft(oss2,win,maxl);

%Assi in frequenza e tempo
fc=Fs1;                         %freq campionamento
fk=-fc/2:fc/M:fc/2;             %asse freq discrete
tk=0:(M/fc):(maxl/fc);          %asse dei tempi discretizzato in funzione della larghezza della finestra in secondi

%Estrazione matrice delle features
[The]=tipoB(Yos1,Yos2,Fs2,fk);

%Clustering
[idx,C]=kmeans(The,3);

%Maschere binarie
idxmask=reshape(idx,size(Yos1,1),size(Yos1,2));
mask1=zeros(1,size(idxmask,1)*size(idxmask,2));
mask2=zeros(1,size(idxmask,1)*size(idxmask,2));
mask3=zeros(1,size(idxmask,1)*size(idxmask,2));

mask1(idxmask==1)=1;
mask1k=reshape(mask1',size(idxmask,1),size(idxmask,2));

mask2(idxmask==2)=1;
mask2k=reshape(mask2',size(idxmask,1),size(idxmask,2));

mask3(idxmask==3)=1;
mask3k=reshape(mask3',size(idxmask,1),size(idxmask,2));

%Estrazione delle STFT dei segnali
STFT1r=Yos1.*mask1k;
STFT2r=Yos1.*mask2k;
STFT3r=Yos1.*mask3k;

%Ricostruzione

sig1r=istft(STFT1r,win,maxl);
sig2r=istft(STFT2r,win,maxl);
sig3r=istft(STFT3r,win,maxl);

% %Grafici delle trasformate dei segnali sorgente
% %I moduli
% figure(1); imagesc(tk,fk,abs(F1));
% figure(2); imagesc(tk,fk,abs(F2));
% figure(3); imagesc(tk,fk,abs(F3));
% %Le fasi
% figure(4); imagesc(tk,fk,angle(F1));
% figure(5); imagesc(tk,fk,angle(F2));
% figure(6); imagesc(tk,fk,angle(F3));