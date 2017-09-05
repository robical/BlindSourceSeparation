%creazione artificiale di segnali
%I segnali vanno creati come vettori colonna!!!!


Fs=8000; %frequenza di campionamento 1KHz
Lenght=24100;  %lunghezza in campioni del segnale

%creazione dell'asse temporale

T=1/Fs;  %periodo di campionamento
t=(0:Lenght-1).*T;

%creazione dei segnali (vettori)

seno150=sin(2*pi*150*t);
seno1000=sin(2*pi*1000*t);
seno500=sin(2*pi*500*t);
seno300=sin(2*pi*300*t);
seno2000=sin(2*pi*2000*t);
seno50=sin(2*pi*50*t);

signal1=seno150'+seno1000';
signal2=seno500'+seno50';
signal3=seno300'+seno2000';