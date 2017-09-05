% Blind Source Separation Problem resolved via Binary Mask Approach
%
% Roberto Calandrini  Carlo Fortini
%
%


clear all;
close all;

time=cputime;

%creazione finestra
win=hamming(512);

%Acquisizione delle 3 sorgenti audio

[s1,Fs1]=wavexread('3personePCM.wav');
[s2,Fs2]=wavexread('Toms_diner.wav');
[s3,Fs3]=wavexread('Voce_maschile.wav');

%Ritardo dei segnali (in numero di campioni)
ang=[-40 10 80];
[diffe,com,T]=geometria(Fs1,ang,[1 1 1],0.02);

%calcolo la lunghezza massima
lun=max([length(s1) length(s2) length(s3)]);
if rem(lun,2)~=0
    lun=lun+1;      %Avere la lunghezza del segnale pari semplifica le cose
end

%%
%PADDING
s1=[s1; zeros((lun-length(s1)),1)];
s2=[s2; zeros((lun-length(s2)),1)];
s3=[s3; zeros((lun-length(s3)),1)];

%Implementazione dei ritardi frazionali ai segnali
s1r=ritfraz(s1,diffe(1));
s2r=ritfraz(s2,diffe(2));
s3r=ritfraz(s3,diffe(3));

%Segnali somma ai 2 mic (Assenza riverberazioni e dunque risposta impulsiva nel tempo del canale, banda piatta,unici ritardi quelli di propagaz)
%Si aggiustano da soli in base agli angoli di arrivo
%
if ang(1)<0
    mic1=s1;
    mic2=s1r;
else
    mic1=s1r;
    mic2=s1;
end;
if ang(2)<0
    mic1=mic1+s2;
    mic2=mic2+s2r;
else
    mic1=mic1+s2r;
    mic2=mic2+s2;
end;
if ang(3)<0
    mic1=mic1+s3;
    mic2=mic2+s3r;
else
    mic1=mic1+s3r;
    mic2=mic2+s3;
end;


%Calcolo spettrogramma al mic1 e al mic2
fmic1=STFT(mic1,win,0.25);
fmic2=STFT(mic2,win,0.25);


%Rappresentazione spettrogrammi del segnale ai 2 mic
pas=length(win);
fk=-Fs1/2+Fs1/pas:Fs1/pas:Fs1/2; %asse delle frequenze discrete
wk=1:1:size(fmic1,2);            %asse con numeri d'indice delle finestre temporali
figure,imagesc(wk,fk,abs(fftshift(fmic1)));
figure,imagesc(wk,fk,abs(fftshift(fmic2)));

%Estraggo features (rapporto delle ampiezze, e fasi normalizzate)
Theta=featuresB(fmic1,fmic2,Fs1,fk);

%Classifico con kmeans (uso norma L1)
[IDX Cen]=kmeans(Theta,3,'dist','city');

%Conto quanti campioni classifica come appartenenti ad ogni sorgente
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

%Coordinate dei centroidi a display
disp('coordinate dei centroidi');
Cen


%Creazione maschere binarie
class=reshape(IDX,length(win),size(fmic1,2));

masc1=zeros(size(fmic1,1),size(fmic1,2));
masc2=zeros(size(fmic1,1),size(fmic1,2));
masc3=zeros(size(fmic1,1),size(fmic1,2));

for i=1:size(masc1,1);
    for t=1:size(masc1,2);
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

%Applico le maschere binarie alla STFT del segnale somma al primo microfono
s1traric=fmic1.*masc1;
s2traric=fmic1.*masc2;
s3traric=fmic1.*masc3;

%Ottengo i segnali temporali ricostruiti attraverso ISTFT
sig1ric=ISTFT(s1traric,win,0.25);
sig2ric=ISTFT(s2traric,win,0.25);
sig3ric=ISTFT(s3traric,win,0.25);

%RICONOSCIMENTO SORGENTI e CALCOLO PRESTAZIONI

%primo ricostruito
corre11=xcov(sig1ric,s1);
corre12=xcov(sig1ric,s2);
corre13=xcov(sig1ric,s3);

corre1=[max(corre11);max(corre12);max(corre13)]'

%secondo ricostruito
corre21=xcov(sig2ric,s1);
corre22=xcov(sig2ric,s2);
corre23=xcov(sig2ric,s3);

corre2=[max(corre21);max(corre22);max(corre23)]'

%terzo ricostruito
corre31=xcov(sig3ric,s1);
corre32=xcov(sig3ric,s2);
corre33=xcov(sig3ric,s3);

corre3=[max(corre31);max(corre32);max(corre33)]'

%REGOLE DI CORRISPONDENZA

[mass1,I1] = max(corre1);  %I1 dice quale sorgente è contenuta in sig1ric 
[mass2,I2] = max(corre2);  % e così via
[mass3,I3] = max(corre3);





%%
% %CALCOLO DELLE PRESTAZIONI
% 
% 
%CALCOLO DELLE INTERFERENZE PRIMA DEL PROCESSSING

SIRin1=10*log10(sum(abs(s1).^2)/(sum(abs(s2).^2)+sum(abs(s3).^2)));
SIRin2=10*log10(sum(abs(s2).^2)/(sum(abs(s1).^2)+sum(abs(s3).^2)));
SIRin3=10*log10(sum(abs(s3).^2)/(sum(abs(s1).^2)+sum(abs(s2).^2)));

%Varie combinazioni interferenti
interf12=STFT((s1+s2),win,0.25);
interf23=STFT((s2+s3),win,0.25);
interf13=STFT((s1+s3),win,0.25);

if I1==1;
    interf23=interf23.*masc1;
    interf23s=ISTFT(interf23,win,0.25);
    SIRout1=10*log10(sum(sig1ric.^2)/(sum(interf23s.^2)));
    G1=SIRout1-SIRin1;
end;

if I1==2;
    interf13=interf13.*masc1;
    interf13s=ISTFT(interf13,win,0.25);
    SIRout1=10*log10(sum(sig1ric.^2)/(sum(interf13s.^2)));
    G2=SIRout1-SIRin2;
end;

if I1==3;
    interf12=interf12.*masc1;
    interf12s=ISTFT(interf12,win,0.25);
    SIRout1=10*log10(sum(sig1ric.^2)/(sum(interf12s.^2)));
    G3=SIRout1-SIRin3;
end;
    
   
if I2==1;
    interf23=interf23.*masc2;
    interf23s=ISTFT(interf23,win,0.25);
    SIRout2=10*log10(sum(sig2ric.^2)/(sum(interf23s.^2)));
    G1=SIRout2-SIRin1;
end;

if I2==2;
    interf13=interf13.*masc2;
    interf13s=ISTFT(interf13,win,0.25);
    SIRout2=10*log10(sum(sig2ric.^2)/(sum(interf13s.^2)));
    G2=SIRout2-SIRin2;
end;

if I2==3;
    interf12=interf12.*masc2;
    interf12s=ISTFT(interf12,win,0.25);
    SIRout2=10*log10(sum(sig2ric.^2)/(sum(interf12s.^2)));
    G3=SIRout2-SIRin3;
end;

if I3==1;
    interf23=interf23.*masc3;
    interf23s=ISTFT(interf23,win,0.25);
    SIRout3=10*log10(sum(sig3ric.^2)/(sum(interf23s.^2)));
    G1=SIRout3-SIRin1;
end;

if I3==2;
    interf13=interf13.*masc3;
    interf13s=ISTFT(interf13,win,0.25);
    SIRout3=10*log10(sum(sig3ric.^2)/(sum(interf13s.^2)));
    G2=SIRout3-SIRin2;
end;

if I3==3;
    interf12=interf12.*masc3;
    interf12s=ISTFT(interf12,win,0.25);
    SIRout3=10*log10(sum(sig3ric.^2)/(sum(interf12s.^2)));
    G3=SIRout3-SIRin3;
end;

newtime=cputime-time;

disp('Guadagni in dB');
G1
G2
G3

disp('Tempo impiegato per elaborazione');
newtime