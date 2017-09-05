%FILE DEL PROGETTO DI TATA
%prova stft e risintesi di un segnale audio
% 
% CALCOLO DEL NUMERO DI SPLICE: 
% numero_splice=1+((length(signal)-length(win))/(length(win)/2))
% 
% 


clear all;
close all;

%creazione finestra
win=hamming(512);

%definita anche la frequenza di campionamnto per come viene importato il file audio

[signal1,Fs1]=wavread('Urlo22.wav');
[signal2,Fs2]=wavread('Toms_diner22.wav');
[signal3,Fs3]=wavread('nonmisomiglia22.wav');



%%
%MICROFONO2

%Ritardo dei segnali (in numero di campioni)
rit1=160;
rit2=560;
rit3=800;

%definizione segnali
signal1r=[zeros(rit1,1); signal1];
signal2r=[zeros(rit2,1); signal2];
signal3r=[zeros(rit3,1); signal3];

%calcolo la lunghezza massima
lunghezzar=max(length(signal1r),length(signal2r));
lunghezzar=max(lunghezzar,length(signal3r));


%%
%PADDING
signal1=[signal1; zeros((lunghezzar-length(signal1)),1)];
signal2=[signal2; zeros((lunghezzar-length(signal2)),1)];
signal3=[signal3; zeros((lunghezzar-length(signal3)),1)];
signal1r=[signal1r; zeros((lunghezzar-length(signal1r)),1)];
signal2r=[signal2r; zeros((lunghezzar-length(signal2r)),1)];
signal3r=[signal3r; zeros((lunghezzar-length(signal3r)),1)];

%Spettri
[f1,f2,f3]=OLAfft(signal1,signal2,signal3,win);

%Rappresentazione
figure(1), imagesc(abs(f1));
figure(2), imagesc(abs(f2));
figure(3), imagesc(abs(f3));

%Segnali somma ai 2 mic (Assenza riverberazioni e dunque risposta impulsiva nel tempo del canale, banda piatta,unici ritardi quelli di propagaz)
som1=signal1+signal2+signal3;
som2=signal1r+signal2r+signal3r;

%Spettri

[fsum1,fsum2,fsum3]=OLAfft(som1,som2,0,win);
clear fsum3;

%Rappresentazione
figure(4); imagesc(abs(fsum1));
figure(5); imagesc(abs(fsum2));