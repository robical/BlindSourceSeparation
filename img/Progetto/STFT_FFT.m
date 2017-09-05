%4Novembre2008_CarloFortini
%...completare con legenda e titoli grafici e costruzione asse delle
%frequenze....


clear all;
close all;
%prova STFT e FFT dell'intero segnale...

Fs=1000; %frequenza di campionamento 1KHz
Lenght=1000;  %lunghezza in campioni del segnale
win=hamming(1000);   %finestra

%creazione dell'asse temporale

T=1/Fs;  %periodo di campionamento
t=(0:Lenght-1).*T;

%creazione dei segnali (vettori)

seno150=sin(2*pi*150*t);
seno150win=seno150.*win';
figure(1);
hold on;
plot(t,seno150,'k');
plot(t,seno150win,'b');
seno50=sin(2*pi*50*t);
seno50win=seno50.*win';
figure(2);
hold on;
plot(t,seno50,'r');
plot(t,seno50win,'b');

pause;
close all;

%creazione dei segnali e segnale somma;

part1=zeros(1000);
part1=seno150+seno50;
part1win=seno150win+seno50win;
figure(1);
plot(t,part1,'b');
part2=zeros(1000);
part2=seno150;
part2win=seno150win;
figure(2);
plot(t,part2,'g');
signal=zeros(2000);
%rinormalizzo part2 per avere la stessa potenza
part2=1.5*part2;
signal=[part1,part2];
signalwin=[part1win,part2win];
figure(3);
plot(signal);

pause;
close all;   %per poi utilizzare le figure

%creazione delle trasformate
PA1=abs(fft(part1,1000));
PA1win=abs(fft(part1win,1000));
PA2=abs(fft(part2,1000));
PA2win=abs(fft(part2win,1000));
SIG=abs(fft(signal,2000));
SIGwin=abs(fft(signalwin,2000));%il valore del numero di campioni su cui effettuare la fft
pot1win=(PA1win).^2;          %può essere fatto variare...è stato variato per controllare il livello
pot1=(PA1).^2;
pot2win=(PA2win).^2;    %di precisione richiesto per la comprensione del problema
pot2=(PA2).^2;
pot=(SIG).^2;
potwin=(SIGwin).^2;     %ho aggiunto anche il caso finestrato con una finestar di hamming per vedere se mi
figure(1);                         %risolveva anche le righe spettrali che non mi trova con la fft su mille campioni 
semilogy(pot1,'b');
hold on;
semilogy(pot1win,'r');
figure(2);
semilogy(pot2,'r');
hold on;
semilogy(pot2win,'b');
figure(3);
semilogy(pot,'k');
hold on;
semilogy(potwin,'b');

%capire perchè lo spettro di part1 con finestra rettangolare e fft su mille
%campioni non è corretto....