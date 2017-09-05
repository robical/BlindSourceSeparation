function [theta]=featureF(fmic1,fmic2)

A=abs(fmic1).^2+abs(fmic2).^2;

og1=abs(fmic1)./A;
og2=abs(fmic2)./A;
