%STFT
%
% INPUT:
%
% signal = segnale sotto analisi
% win = finestra temporale di analisi del segnale (ricordare che la risoluzione
% in frequenza ottenibile dipende dalla lunghezza temporale della finestra e dal
% tipo di finestra usata - il sovracampionamento nel dominio trasformato serve solo
% a vedere meglio, ma la max risoluzione ottenibile è data circa dal lobo principale della
% trasformata della finestra, poichè è per questa che viene convoluto lo spettro della
% porzione del segnale prelevata dalla finestra, dunque cercare tradeoff ottimo)
%
% Nfft= precisione alla quale vedo lo spettro - numero punti FFT
% av= percentuale del numero di campioni della finestra che verrà
% utilizzata come hop size (dunque tra 2 finestre consecutive avrò overlap 
% pari a av)
%
% OUTPUT:
%
% trasf= funzione 3D, spettrogramma, cioè una funzione da R2 a C, che dal
% dominio tempo-frequenza sezionato attraverso la finestratura, restituisce
% i valori di ampiezza complessa (trasformata per ogni slice temporale)
%
%
% 
% CALCOLO DEL NUMERO DI SPLICE: 
% numero_splice=1+((length(signal)-length(win))/(length(win)/2))


function [trasf]=STFT(signal,win,Nfft,av)

M=length(win); %durata finestra
T=length(signal); %durata segnale
R=M*av; %hop size del 50% (M/2)
part(1:M,1)=signal(1:M,1);
splice(1:M,1)=part(1:M,1)'.*win';
start=1;

if (rem(T,R)==0)
cicli=T/R-2;
else
    %padding segnale
    ini=fix(T/R)*R;
    signal=[signal; zeros(R-(T-ini),1)];
    T=length(signal);
    cicli=T/R-(1/av);
end

for i=2:cicli;
    
    start=R+start;
    fin=start+M-1;
    part(1:M,i)=signal(start:fin,1);
    splice(1:round(M),i)=part(1:round(M),i)'.*win';
    
end;

for i=1:(size(splice,2));
    
    trasf(1:Nfft,i)=fft(splice(1:M,i),Nfft);
        
end;