%FILE DEL PROGETTO DI TATA
% 
% 
% ASCOLTO DEI SEGNALI:
% Si può usare la funzione "sound(vettore,freq.camp)" 
% 
%LOGARITMI IN BASE 10 E NON BASE e !!!!!CAMBIARLI TUTTI!!! 
%
% Carlo Fortini   Roberto Calandrini


clear all;
close all;

time=cputime;

%creazione finestra
win=hamming(512);


%%
%SEGNALI AI DUE MICROFONI
%creo il segnale totale al primo microfono
[mic1,Fs1]=wavread('rss_mA.wav');
%creo il segnale totale al secondo microfono
[mic2,Fs2]=wavread('rss_mB.wav');

%%
%SPLICING/FOURIER

%CALCOLO LE STFT DEI SEGNALI DEI DUE MICROFONI

STFT1=STFT(mic1,win);
STFT2=STFT(mic2,win);

figure(1);
subplot(2,2,1); surf(10*log10(abs(STFT1)));
subplot(2,2,2); surf(10*log10(abs(STFT2)));
subplot(2,2,3); imagesc(10*log10(abs(STFT1)));
subplot(2,2,4); imagesc(10*log10(abs(STFT2)));

%%
% %RAPPORTO DIAGRAMMI STFT E CLASSIFICAZIONE

quoziente=STFT2./STFT1;

moduli=abs(quoziente);
fasi=angle(quoziente);

%NORMALIZZAZIONE DELLE FASI
for a=1:size(fasi,1);
    Norm=2*pi*a;
end;

for a=1:size(fasi,2);
    fasi(:,a)=fasi(:,a)./Norm;
end;

%EQUALIZZAZIONE DELLE FEATURES

%fasi
den=(1/340)*0.08;   %1/c^(-1)*d    c=velocità prop.  d=distanza microfoni
fasi=fasi/den;

%moduli
% energiaNorm=sum(abs(reshape(STFT1,1,[])));  %+sum(abs(reshape(STFT2,1,[])))
% moduli=100*moduli/sqrt(energiaNorm);



moduli=reshape(moduli,size(moduli,1)*size(moduli,2),1);
fasi=reshape(fasi,size(fasi,1)*size(fasi,2),1);


matrix=[moduli,fasi];

%Utilizzo una metrica in norma L1 per "proteggermi" da errori di stima
%degli outliers presenti
%[IDX Cen]= kmeans(matrix,3);     %capire bene se ha funzionato ai fini della separazione....vedi diverse metriche di distanza
[IDX Cen]= kmeans(matrix,2,'distance','cityblock');   %'distance','cityblock'

%conto gli elementi di ogni cluster (PER CONTROLLO!!!)

sorg1=0;sorg2=0;

for i=1:length(IDX);
    if IDX(i,1)==1;
        sorg1=sorg1+1;
    else
        if IDX(i,1)==2;
            sorg2=sorg2+1;
        end;
    end;
end;

sorg1
sorg2


%Disegno dei tre cluster sul grafico dello spazio delle features...
%  [...]
disp('coordinate dei centroidi');
Cen

%%
%CREAZIONE DELLE MASCHERE BINARIE

%per ogni punto della matrice mi dice il bin a che cluster è stato
%assegnato
class=reshape(IDX,length(win),[]);

masc1=zeros(size(STFT1,1),size(STFT1,2));
masc2=zeros(size(STFT1,1),size(STFT1,2));

for i=1:size(masc1,1);
    for t=1:size(masc1,2);
        if (class(i,t)==1);
            masc1(i,t)=1;
        else
            if (class(i,t)==2);
                masc2(i,t)=1;
            end;
        end;
    end;
end;

%%
%ISFT --> dai vettori della stft (opportunamente "filtarti" con le maschere binarie create dalla classificazione)
%devo ricreare i segnali nel tempo
%PHASE UNWRAPPING
%IFFT

%APPLICAZIONE DELLE MASCHERE BINARIE AI DIAGRAMMI Spazio-Tempo

sig1masc=STFT1.*masc1;
sig2masc=STFT1.*masc2;

%IFFT e RICOSTRUZIONE

sig1ric=ISTFT(sig1masc,win);
sig2ric=ISTFT(sig2masc,win);


%TRASFORMATE DEI SEGNALI RICOSTRUITI
tra1=STFT(sig1ric',win);
tra2=STFT(sig2ric',win);

figure; imagesc(10*log10(abs(tra1))); title('Prima Sorgente ricostruita');
figure; imagesc(10*log10(abs(tra2))); title('Seconda Sorgente ricostruita');



%%
%TEMPO DI ELABORAZIONE

disp('Tempo impiegato per elaborare')
time=cputime-time

%%
%PERFORMANCE
% 
% performance;

%%
% %RICORDARE LE RELAZIONI DI SIMMETRIA DELLA TRASFORMATA DI FOURIER:
% %
% %   SEQUENZA             TRASFORMATA
% %
% %   Real and Even        Real and Even
% %   Real and Odd         Imaginary and Odd
% %   Imaginary and Even   Imaginary and Even
% %   Imaginary and Odd    Real and Odd 
% 
% 
% 
% % Bisognerebbe provare a fare la classificazione con solamnte due sorgenti 
% % e poi provare a farla con sorgenti piu facili
% %Capire bene anche il discorso delle fasi....