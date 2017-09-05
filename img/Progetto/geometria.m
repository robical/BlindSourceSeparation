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



function [rit1,rit2,com,T]=geometria(fs,ang,R,d)

rit1=zeros(3,1);
rit2=zeros(3,1);
%tempi di arrivo delle sorgenti al mic1, il suono in aria si propaga a
%340m/s, si suppone si propaghi un onda piana, in realtà questa
%approssimazione vale per grandi distanze sorgente/microfono

c=340;
%Il problema è ben posto se le sorgenti vengono disposte in
%ordine numerico da sinistra verso destra, e così i microfoni
t11=1/c*(R(1)+d/2*sin(ang(1)/180*pi)); %mic1 sorg 1
t12=1/c*(R(2)+d/2*sin(ang(2)/180*pi));% mic1 sorg 2
%Se la terza sorgente è disposta a destra della linea di separazione
%tracciata a partire dal centro della schiera, significa che arriva prima
%al microfono 2, e poi al mic1: t3 è sviluppato per questo caso, nel caso
%cambi la geometria va tenuto conto di questo.
t13=1/c*(R(3)+d/2*sin(ang(3)/180*pi)); % mic1 sorg 3
t21=1/c*(R(1)-d/2*sin(ang(1)/180*pi)); %mic2 sorg1
t22=1/c*(R(2)-d/2*sin(ang(2)/180*pi)); %mic2 sorg2
t23=1/c*(R(3)-d/2*sin(ang(3)/180*pi)); %mic3 sorg3

%Chi arriva prima? Il tempo di arrivo più breve in assoluto fa da base
%temporale (ritardo zero), per tutti gli altri tempi di arrivo, si riesce a
%capire osservando i pedici dei tempi di arrivo se il primo a registrare un
%contributo è il mic1 o il mic2

t1=[t11 t12 t13];
t2=[t21 t22 t23];
T=[t11 t12 t13 t21 t22 t23]; %vettore tempi di arrivo
[base, ind]=min(T);

%Quale microfono uso come base di temporizzazione?
%La variabile com indica quale microfono "comanda"
if ind>3
    com=2;
else
    com=1;
end

%Calcolo dei ritardi in campioni
for i=1:3
    rit1(i,1)=round((t1(i)-T(ind))*fs);
end
for i=1:3
    rit2(i,1)=round((t2(i)-T(ind))*fs);
end
