%Crea direttamente i ritardi associati a ciascuna sorgente per ciascun
%microfono, nel caso di geometria 2 microfoni e 3 sorgenti disposte su una
%circonferenza che ha centro nella schiera, a distanza R
%
%
% Variabili:
% fs= frequenza di campionamento temporale dei segnali audio
% d= distanza della schiera, ovvero periodo di campionamento spaziale, si
% calcola fissando quale direzione di arrivo si vuole poter individuare al
% Nyquist, il caso più generale se non si ha info sulle DOA è fissare il
% Nyquist a 90°, e dunque d<= c/(2*fmax(di tutti i segnali audio
% presenti)*sin(angoloDOA)=c/fmax*2 (espresso in metri)
% R= vettore raggi delle circonferenze sulle quali dispongo le sorgenti
% ang= vettore angoli ai quali dispongo le tre sorgenti
%
%
% Output:
% rit1= vettore che contiene i 2 ritardi in campioni rispetto alla prima
% sorgente ricevuta dal microfono, che segna il tempo zero per esso
% rit2 =uguale ma per l altro mic
% com= indica se può servire, quale dei microfoni riceve per primo in
% assoluto una delle sorgente, cioè quale dei 2 mic serve da base per
% temporizzare



function [rit1s,rit2s,rit3s]=Ritardig(fs,angoli,R,d)

%trasformazione in radianti
angoli=deg2rad(angoli);


rit1=zeros(3,1);
rit2=zeros(3,1);
%tempi di arrivo delle sorgenti al mic1, il suono in aria si propaga a
%340m/s, si suppone si propaghi un onda piana, in realtà questa
%approssimazione vale per grandi distanze sorgente/microfono

c=340;
%Il problema è ben posto se le sorgenti vengono disposte in
%ordine numerico da sinistra verso destra, e così i microfoni
t11=1/c*(R(1)+d/2*cos(angoli(1))); %mic1 sorg 1
t12=1/c*(R(2)+d/2*cos(angoli(2)));% mic1 sorg 2
%Se la terza sorgente è disposta a destra della linea di separazione
%tracciata a partire dal centro della schiera, significa che arriva prima
%al microfono 2, e poi al mic1: t3 è sviluppato per questo caso, nel caso
%cambi la geometria va tenuto conto di questo.
t13=1/c*(R(3)+d/2*cos(angoli(3))); % mic1 sorg 3

t21=1/c*(R(1)-d/2*cos(angoli(1))); %mic2 sorg1
t22=1/c*(R(2)-d/2*cos(angoli(2))); %mic2 sorg2
t23=1/c*(R(3)-d/2*cos(angoli(3))); %mic3 sorg3


rit1s=((t11-t21))/(1/8000);
rit2s=((t12-t22))/(1/8000);
rit3s=((t13-t23))/(1/8000);


