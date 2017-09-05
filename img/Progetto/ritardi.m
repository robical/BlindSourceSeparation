%RITARDO FRAZIONALE TRAMITE DFT

%prima prova (anticipo di 0.5 campioni)
FT1=fft(signal1);
k1=1:size(signal1)/2;
esp1=exp(-i*2*pi*k1/60*0.5);
esp1=esp1';
FT1(1:size(FT1)/2,1)=FT1(1:size(FT1)/2,1).*esp1;
k2=11959:size(FT1);esp2=exp(-i*2*pi*(k2/60-1)*0.5);
esp2=esp2';
FT1(size(FT1)/2+1:size(FT1),1)=FT1(size(FT1)/2+1:size(FT1),1).*esp2;



signal1R=ifft(FT1,'symmetric');
figure; plot(signal1R);
sound(signal1R,8000);
sound(signal1,8000);
prova2=signal1-signal1R;
figure; plot(prova2);
sound(prova2,8000);
sound(signal1,8000);
sound(signal1R,8000);
sound(prova2,8000);

%seconda prova
FT1=fft(signal1);
k1=1:size(signal1)/2;
esp1=exp(-i*2*pi*k1/60*3.5);
esp1=esp1';
FT1(1:size(FT1)/2,1)=FT1(1:size(FT1)/2,1).*esp1;
k2=11959:size(FT1);esp2=exp(-i*2*pi*(k2/60-1)*3.5);
esp2=esp2';
FT1(size(FT1)/2+1:size(FT1),1)=FT1(size(FT1)/2+1:size(FT1),1).*esp2;
signal1R=ifft(FT1,'symmetric');
sound(signal1R,8000);
prova2=signal1-signal1R;
sound(prova2,8000);