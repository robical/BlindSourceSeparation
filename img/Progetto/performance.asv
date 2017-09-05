%CALCOLO DELLE PERFORMANCE per valutare il funzionamento della
%calssificazione
% 
% 
% [...riferimento all'articolo...]
% 
% 
% [...inserire anche valutazione della sparsità delle sorgenti iniziali...]
% 
%
% "The separation performance was evaluated in
% terms of the SIR improvement and the signal to
% distortion ratio (SDR)."

% The SIR improvement was calculated by
% OutputSIRi-InputSIRi

%%
%CORRISPONDENZA RICOSTRUITI/SORGENTI ORIGINALI (correlazione)--> non funziona
%sempre...sbaglia sui segnali separati male  --> molto lento

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

[mass1,I1] = max(corre1);
[mass2,I2] = max(corre2);
[mass3,I3] = max(corre3);




%%
% %CALCOLO DELLE PRESTAZIONI
% 
% 
%CALCOLO DELLE INTERFERENZE PRIMA DEL PROCESSSING
SIRin1=10*log10(sum(abs(s1).^2)/(sum(abs(s2).^2)+sum(abs(s3).^2)));
SIRin2=10*log10(sum(abs(s2).^2)/(sum(abs(s1).^2)+sum(abs(s3).^2)));
SIRin3=10*log10(sum(abs(s3).^2)/(sum(abs(s1).^2)+sum(abs(s2).^2)));

%dipende dalla classificazione!!!!!!!
interf12=STFT((s1+s2),win);
interf23=STFT((s2+s3),win);
interf13=STFT((s1+s3),win);

if I1==1;
    interf23=interf23.*masc1;
    interf23=ISTFT(interf23,win);
    SIRout1=10*log10(sum(sig1ric.^2)/(sum(interf23.^2)));
    G1=SIRout1-SIRin1;
end;

if I1==2;
    interf13=interf13.*masc1;
    interf13=ISTFT(interf13,win);
    SIRout1=10*log10(sum(sig1ric.^2)/(sum(interf13.^2)));
    G2=SIRout1-SIRin2;
end;

if I1==3;
    interf12=interf12.*masc1;
    interf12=ISTFT(interf12,win);
    SIRout1=10*log10(sum(sig1ric.^2)/(sum(interf12.^2)));
    G3=SIRout1-SIRin3;
end;
    
   
if I2==1;
    interf23=interf23.*masc2;
    interf23=ISTFT(interf23,win);
    SIRout2=10*log10(sum(sig2ric.^2)/(sum(interf23.^2)));
    G1=SIRout2-SIRin1;
end;

if I2==2;
    interf13=interf13.*masc2;
    interf13=ISTFT(interf13,win);
    SIRout2=10*log10(sum(sig2ric.^2)/(sum(interf13.^2)));
    G2=SIRout2-SIRin2;
end;

if I2==3;
    interf12=interf12.*masc2;
    interf12=ISTFT(interf12,win);
    SIRout2=10*log10(sum(sig2ric.^2)/(sum(interf12.^2)));
    G3=SIRout2-SIRin3;
end;

if I3==1;
    interf23=interf23.*masc3;
    interf23=ISTFT(interf23,win);
    SIRout3=10*log10(sum(sig3ric.^2)/(sum(interf23.^2)));
    G1=SIRout3-SIRin1;
end;

if I3==2;
    interf13=interf13.*masc3;
    interf13=ISTFT(interf13,win);
    SIRout3=10*log10(sum(sig3ric.^2)/(sum(interf13.^2)));
    G2=SIRout3-SIRin2;
end;

if I3==3;
    interf12=interf12.*masc3;
    interf12=ISTFT(interf12,win);
    SIRout3=10*log10(sum(sig3ric.^2)/(sum(interf12.^2)));
    G3=SIRout3-SIRin3;
end;



disp('Guadagni in dB');
G1
G2
G3