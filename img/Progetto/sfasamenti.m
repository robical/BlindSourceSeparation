function Y=uladata(theta,P,N,sig2,m,d)
%
% Generates N snapshots of ULA sensor data
%
% Y=uladata(theta,P,N,sig2,m,d);
%
%    theta  <- arrival angles of the m sources in degrees
%    P      <- The covariance matrix of the source signals
%    N      <- number of snapshots to generate
%    sig2   <- noise variance
%    m      <- number of sensors
%    d      <- sensor spacing in wavelengths 
%    Y      -> m x N data matrix Y = [y(1),...,y(N)]

% Copyright 1996 by R. Moses

% generate the A matrix
A=exp(-2*pi*j*d*[0:m-1].'*sin([theta(:).']*pi/180));

% generate the source signals
n=max(size(P));
s=(sqrtm(P)')*randn(n,N);      % s(t)

% generate the noise component
e=sqrt(sig2/2)*(randn(m,N)+j*randn(m,N));

% generate the ULA data
Y=A*s+e;
