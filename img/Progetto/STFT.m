%STFT

% CALCOLO DEL NUMERO DI SPLICE: 
% numero_splice=1+((length(signal)-length(win))/(length(win)/2))
% 
% 


function [trasf]=STFT(signal,win)

M=length(win);
R=M/2; %hop size del 50% (M/2)
part(1:M,1)=signal(1:M,1);
splice(1:M,1)=part(1:M,1)'.*win';

cicli=fix((length(signal)-length(win))/(length(win)/2)); %2 o 4

for i=2:cicli;
    
    start=1+(i-1)*(R);
    fin=start+length(win)-1;
    part(1:M,i)=signal(start:fin,1);
    splice(1:M,i)=part(1:M,i)'.*win';
    
end;

for i=1:(size(splice,2));
    
    trasf(1:M,i)=fft(splice(1:M,i));
        
end;