function [signal]=istft2(tra,win,av)

w=length(win);
t=length(tra(1,:));
part=zeros(w,t)

for i=1:t
    part(:,i)=ifftshift(ifft(tra(:,i),'symmetric')).*(1/win)';
end

lun=(size(tra,2)+1)*(w*av);
signal=zeros(lun,1);

signal(1:256,1)=part(:,1);
for i=2:t
    start=1+(i-1)*(w*av);
    fin=start+w-1;
    signal(start:fin,1)=signal(start:fin,1)+part(:,i);
end

