%&Implementazione STFT
%
% av=percentuale di avanzamento espressa in forma decimale es. 50%=0.5
% win=tipo di finestra



function [fourier1]=OLAfft(signal1,win,av)
    
    durata=length(signal1); %durata segnale
    pas=length(win); %durata finestra
    
    splice1=zeros(pas,(fix(durata/(pas*av)))+1);
    part1=zeros(pas,(fix(durata/(pas*av)))+1);
    
    splice1(1:pas,1)=signal1(1:pas,1)'.*win';
    part1(1:pas,1)=splice1(1:pas,1);
    
    cicli=fix((durata-pas)/(pas/2));
    
    for i=2:cicli;
    
    start=1+(i-1)*(pas*av); %avanza del 50%
    fin=start+pas-1;
    part1(1:pas,i)=signal1(start:fin,1);
    splice1(1:pas,i)=part1(1:pas,i)'.*win';
    end;
    resto=rem(durata,(pas*av));
    fin=fix(durata/(pas*av))*(pas*av);
    part1(1:pas,(fix(durata/(pas*av))-1))=[signal1(fin:durata,1); zeros((pas-resto-1),1)];
    splice1(1:pas,(fix(durata/(pas*av))-1))=part1(1:pas,(fix(durata/(pas*av))-1))'.*win';
    
    for i=1:fix(durata/(pas*av))-1;
        
    fourier1(1:pas,i)=fftshift(fft(splice1(1:pas,i)));
    
    end;
    
