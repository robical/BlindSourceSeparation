function [four]=stft(signal,win,maxl)

M=length(win);
R=M/2; %hop size del 50%
part(1:M,1)=signal(1:M,1);
splice(1:M,1)=part(1:M,1)'.*win';

for i=2:(round(maxl/M))
    
    start=(i-1)*(R); %avanza del 50%
    fin=start+M-1;
    part(1:M,i)=signal(start:fin,1);
    splice(1:M,i)=part(1:M,i)'.*win';
    
end;

for i=1:(round(maxl/M));
    
    four(1:M,i)=fft(splice(1:M,i));
    four(1:M,i)=fftshift(four(1:M,i));  %centra la trasformata in modo da avere la continua al centro, 
    %ed il Nyquist all'estremo destro solo se il numero di campioni DFT è pari 
    
end;