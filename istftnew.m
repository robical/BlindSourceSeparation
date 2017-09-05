function [sign]=istftnew(trasf,win,maxl)

M=length(win);
R=M/4;
for i=1:size(trasf,2)
    trasf(1:M,i)=ifftshift(trasf(1:M,i));
splicesig(1:M,i)=ifft(trasf(1:M,i));
end

sign(:,1)=[splicesig(1:M,1); zeros((M*(size(trasf,2)-1)),1)];

for i=2:(size(trasf,2))
    
    start=(i-1)*(R); %avanza del 25%
    fin=start+M-1;
    sign(start:fin,1)=sign(start:fin,1)+splicesig(1:M,i);
end;


