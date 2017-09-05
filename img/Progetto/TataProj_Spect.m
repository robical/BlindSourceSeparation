%FILE DEL PROGETTO DI TATA
%UTILIZZO DELLA FUNZIONE SPECTROGRAM
% 
% CALCOLO DEL NUMERO DI SPLICE: 
% numero_splice=1+((length(signal)-length(win))/(length(win)/2))
% 
% 
% ASCOLTO DEI SEGNALI:
% Si può usare la funzione "sound(vettore,freq.camp)" 
% 
% PROVARE CON LA FUNZIONE SPECTROGRAM COME IN QUESTO FILE MA NORMALIZZANDO
% LE FREQUENZE
% 


clear all;
close all;

%creazione finestra
win=hamming(512);

%definita anche la frequenza di campionamnto per come viene importato il file audio

[signal1,Fs1]=wavread('Brutta_Casa.wav');
[signal2,Fs2]=wavread('A_maschile.wav');
[signal3,Fs3]=wavread('Bella_Casa.wav');

%capire i formati supportati da wavread e wavexread...



%%
%MICROFONO1

%definizione segnali

lunghezza=max(length(signal1),length(signal2));
lunghezza=max(lunghezza,length(signal3));

signal1=cat(1,signal1,zeros(lunghezza-length(signal1),1));
signal2=cat(1,signal2,zeros(lunghezza-length(signal2),1));
signal3=cat(1,signal3,zeros(lunghezza-length(signal3),1));


%%
%MICROFONO2

%Ritardo dei segnali (in numero di campioni)
rit1=16;
rit2=56;        %prima erano 160,560,800...provo per vedere...!!!
rit3=80;

%definizione segnali
signal1r=[zeros(rit1,1); signal1];
signal2r=[zeros(rit2,1); signal2];
signal3r=[zeros(rit3,1); signal3];

%calcolo la lunghezza massima
lunghezzar=max(length(signal1r),length(signal2r));
lunghezzar=max(lunghezzar,length(signal3r));


%%
%PADDING
signal1r=cat(1,signal1r,zeros(lunghezzar-length(signal1r),1));
signal2r=cat(1,signal2r,zeros(lunghezzar-length(signal2r),1));
signal3r=cat(1,signal3r,zeros(lunghezzar-length(signal3r),1));

padd=max(lunghezza,lunghezzar);

signal1=cat(1,signal1,zeros(padd-length(signal1),1));
signal2=cat(1,signal2,zeros(padd-length(signal2),1));
signal3=cat(1,signal3,zeros(padd-length(signal3),1));
signal1r=cat(1,signal1r,zeros(padd-length(signal1r),1));
signal2r=cat(1,signal2r,zeros(padd-length(signal2r),1));
signal3r=cat(1,signal3r,zeros(padd-length(signal3r),1));

%creo il segnale totale al primo microfono
mic1=signal1+signal2+signal3;
%creo il segnale totale al secondo microfono
mic2=signal1r+signal2r+signal3r;

%%
%SPLICING/FOURIER



% %eseguo la finestratura dei seganli, lo splicing
% part1(1:512,1)=signal1(1:length(win),1);
% part2(1:512,1)=signal2(1:length(win),1);
% part3(1:512,1)=signal3(1:length(win),1);
% splice1(1:512,1)=part1(1:512,1)'.*win';
% splice2(1:512,1)=part2(1:512,1)'.*win';
% splice3(1:512,1)=part3(1:512,1)'.*win';
% 
% for i=2:93;
%     
%     start=1+(i-1)*(256);
%     fin=start+length(win)-1;
%     part1(1:512,i)=signal1(start:fin,1);
%     part2(1:512,i)=signal2(start:fin,1);
%     part3(1:512,i)=signal3(start:fin,1);
%     splice1(1:512,i)=part1(1:512,i)'.*win';
%     splice2(1:512,i)=part2(1:512,i)'.*win';
%     splice3(1:512,i)=part3(1:512,i)'.*win';
%     
% end;
% 
% %memorizzo le trasformate
% 
% for i=1:93;
%     
%     fourier1(1:512,i)=fft(splice1(1:512,i));
%     fourier2(1:512,i)=fft(splice2(1:512,i));
%     fourier3(1:512,i)=fft(splice3(1:512,i));
%     
% end;
% 
% %moduli per poterli rappresentare
% mod_stft1=abs(fourier1);
% mod_stft2=abs(fourier2);
% mod_stft3=abs(fourier3);
% figure(2); imagesc(mod_stft1); title('Prima Sorgente (E femminile, mod_stft1)');
% figure(3); imagesc(mod_stft2); title('Seconda Sorgente (A Maschile, mod_stft2)');
% figure(4); imagesc(mod_stft3); title('Terza Sorgente (Frase, mod_stft3)')



%ora devo creare i grafici SDTF ottenuti dai segnali dei due microfoni

%grafico microfono 1
mic1part(1:512,1)=mic1(1:length(win),1);
mic1splice(1:512,1)=mic1part(1:512,1)'.*win';

%andrà poi inserito il controllo per usare tutti i campioni dei
%segnali....con uteriore padding

% cicli=fix((length(mic1)-length(win))/(length(win)/2)); %uso fix per prendere l'intero inferiore
% for i=2:cicli;
%     
%     start=1+(i-1)*(256);
%     fin=start+length(win)-1;
%     mic1part(1:512,i)=mic1(start:fin,1);
%     mic1splice(1:512,i)=mic1part(1:512,i)'.*win';
%   
% end;
% 
% %grafico microfono 2
% mic2part(1:512,1)=mic2(1:length(win),1);
% mic2splice(1:512,1)=mic2part(1:512,1)'.*win';
% 
% cicli=fix((length(mic2)-length(win))/(length(win)/2)); %uso fix per prendere l'intero inferiore
% for i=2:cicli;
%     
%     start=1+(i-1)*(256);
%     fin=start+length(win)-1;
%     mic2part(1:512,i)=mic2(start:fin,1);
%     mic2splice(1:512,i)=mic2part(1:512,i)'.*win';
%   
% end;
% 
% %diagrammi STFT
% for i=1:cicli;
%     
%     mic1FFT(1:512,i)=fft(mic1splice(1:512,i));
%     mic2FFT(1:512,i)=fft(mic2splice(1:512,i));
%         
% end;
% 
% %calcolo i moduli per rappresentarli (solo per chiarezza e controllo)
% mod_mic1=abs(mic1FFT);
% mod_mic2=abs(mic2FFT);

mic1FFT=spectrogram(mic1,512,[],512,8000);
mic2FFT=spectrogram(mic2,512,[],512,8000);

mod_mic1=abs(mic1FFT);
mod_mic2=abs(mic2FFT);

figure(1);
subplot(2,2,1); surf(mod_mic1');
subplot(2,2,2); surf(mod_mic2');
subplot(2,2,3); imagesc(mod_mic1');
subplot(2,2,4); imagesc(mod_mic2');

%%
%RAPPORTO DIAGRAMMI STFT E CLASSIFICAZIONE

quoziente=mic2FFT./mic1FFT;

moduli=abs(quoziente);
fasi=angle(quoziente);

% %creo la matrice delle frasi normalizzando per le frequenze
% for i=1:257;
%     Norm(i,1)=i;
% end;
% Norm=2*pi*Norm;
% 
% for t=1:139;
%         fasiNorm(:,t)=fasi(:,t)./Norm(:,1);
% end;
% 
% %ora devo organizzare i valori di questi due matrici ottenuta dal rapporto
% %tra i due diagrammi STFT in opportuni vettori che possano essere sfruttati
% %dalle funzioni di classificazione

moduli=reshape(moduli,size(moduli,1)*size(moduli,2),1);
fasi=reshape(fasi,size(fasi,1)*size(fasi,2),1);
%fasiNorm=reshape(fasiNorm,size(fasiNorm,1)*size(fasiNorm,2),1);
matrix=[moduli,fasi];
%matrix1=[moduli,fasiNorm];

%applicazione dell'algoritmo...kmeans..
IDX = kmeans(matrix,3,'distance','cityblock');     %capire bene se ha funzionato ai fini della separazione....vedi diverse metriche di distanza
%IDX1= kmeans(matrix1,3);

%conto gli elementi di ogni cluster (PER CONTROLLO!!!)

sorg1=0;sorg2=0;sorg3=0;

for i=1:length(IDX);
    if IDX(i,1)==1;
        sorg1=sorg1+1;
    else
        if IDX(i,1)==2;
            sorg2=sorg2+1;
        else
            if IDX(i,1)==3;
                sorg3=sorg3+1;
            end;
        end;
    end;
end;

sorg1
sorg2
sorg3

% sorg10=0;sorg20=0;sorg30=0;
% 
% for i=1:length(IDX1);
%     if IDX1(i,1)==1;
%         sorg10=sorg10+1;
%     else
%         if IDX1(i,1)==2;
%             sorg20=sorg20+1;
%         else
%             if IDX1(i,1)==3;
%                 sorg30=sorg30+1;
%             end;
%         end;
%     end;
% end;
% 
% sorg10
% sorg20
% sorg30

%La prima prova a me sembra un po' troppo sbilaciata sulla terza
%sorgente....!!!

%Disegno dei punti raggruppati...sul grafico delle features..

%       [...]

%%
%CREAZIONE DELLE MASCHERE BINARIE

%per ogni punto della matrice mi dice il bin a che cluster è stato
%assegnato
class=reshape(IDX,257,[]);

masc1=zeros(257,139);
masc2=zeros(257,139);
masc3=zeros(257,139);

for i=1:257;
    for t=1:139;
        if (class(i,t)==1);
            masc1(i,t)=1;
        else
            if (class(i,t)==2);
                masc2(i,t)=1;
            else
                masc3(i,t)=1;
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

sig1masc=mic1FFT.*masc1;
sig2masc=mic1FFT.*masc2;
sig3masc=mic1FFT.*masc3;

% simm1=zeros(512,93);
% simm2=zeros(512,93);
% simm3=zeros(512,93);
% 
% %creazione dei diagrammi stft simmetrici dopo l'applicazione delle maschere
% %binarie:
% 
% for t=1:93;
%     for i=1:256;
%         simm1(i,t)=sig1masc(i,t);
%         simm2(i,t)=sig2masc(i,t);
%         simm3(i,t)=sig3masc(i,t);
%     end;
% end;
% 
% for t=1:93;
%     for i=1:256;
%         simm1(256+i,t)=sig1masc(257-i,t);
%         simm2(256+i,t)=sig2masc(257-i,t);
%         simm3(256+i,t)=sig3masc(257-i,t);
%     end;
% end;
% 
% mod_ric1=abs(simm1);
% mod_ric2=abs(simm2);
% mod_ric3=abs(simm3);

%NB. non posso sapere a quale cluster compete quale sorgente!!!

figure(5); imagesc(abs(sig1masc)); title('Prima Sorgente ricostruita');
figure(6); imagesc(abs(sig2masc)); title('Seconda Sorgente ricostruita');
figure(7); imagesc(abs(sig3masc)); title('Terza Sorgente ricostruita')


%IFFT e RICOSTRUZIONE

for i=1:139;  %prima era cicli invece che 93!!!
    
%     mic1IFFT(:,i)=ifft(mic1FFT(:,i));
%     mic2IFFT(:,i)=ifft(mic2FFT(:,i));
    sig1mIFFT(:,i)=ifft(sig1masc(:,i),512,'symmetric');
    sig2mIFFT(:,i)=ifft(sig2masc(:,i),512,'symmetric');
    sig3mIFFT(:,i)=ifft(sig2masc(:,i),512,'symmetric');
    
end;

%ora devo ricostruire al contrario dello splicing
%per semplicità utilizzo le trasposte delle matrici IFFT

% mic1IFFT=mic1IFFT';
% mic2IFFT=mic2IFFT';
% sig1mIFFT=(abs(sig1mIFFT))';
sig1mIFFT=sig1mIFFT';
sig2mIFFT=sig2mIFFT';
sig3mIFFT=sig3mIFFT';

% mic1ric=zeros(1,24064);
% mic1ric(1,1:512)=mic1IFFT(1,1:512);      %poi bisogna capire come fare parametrica anche la lunghezza dei vettori da preallocare
% 
% mic2ric=zeros(1,24064);
% mic2ric(1,1:512)=mic2IFFT(1,1:512);

sig1ric=zeros(1,length(signal1));
sig1ric(1,1:512)=sig1mIFFT(1,1:512);
sig2ric=zeros(1,length(signal1));
sig2ric(1,1:512)=sig2mIFFT(1,1:512);
sig3ric=zeros(1,length(signal1));
sig3ric(1,1:512)=sig3mIFFT(1,1:512);


for n=2:((size(moduli,1)*size(moduli,2))-2);
    
    start=1+(n-1)*(256);
    fin=start+length(win)-1;
%     mic1ric(1,start:fin)=mic1IFFT(n,:)+mic1ric(1,start:fin);
%     mic2ric(1,start:fin)=mic2IFFT(n,:)+mic2ric(1,start:fin);
    sig1ric(1,start:fin)=sig1mIFFT(n,:)+sig1ric(1,start:fin);
    sig2ric(1,start:fin)=sig2mIFFT(n,:)+sig2ric(1,start:fin);
    sig3ric(1,start:fin)=sig3mIFFT(n,:)+sig3ric(1,start:fin);
      
end;


%Inserire parametrizzazione per la funzione di splicing e di trasformazione
%e antitrasformazione


%RICORDARE LE RELAZIONI DI SIMMETRIA DELLA TRASFORMATA DI FOURIER:
%
%   SEQUENZA             TRASFORMATA
%
%   Real and Even        Real and Even
%   Real and Odd         Imaginary and Odd
%   Imaginary and Even   Imaginary and Even
%   Imaginary and Odd    Real and Odd 



% Bisognerebbe provare a fare la classificazione con solamnte due sorgenti 
% e poi provare a farla con sorgenti piu facili
%Capire bene anche il discorso delle fasi....