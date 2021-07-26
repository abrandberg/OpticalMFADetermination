function Ts = singleWallTransmissionFunction(mfa,Delta)

RmatRight = [cosd(mfa) sind(mfa) ; -sind(mfa) cosd(mfa)];
RmatLeft = [cosd(-mfa) sind(-mfa) ; -sind(-mfa) cosd(-mfa)];
Lmat = [exp(-1i*Delta*0.5) 0 ; 0 exp(1i*Delta*0.5)];
Ts = RmatLeft*Lmat*RmatRight;