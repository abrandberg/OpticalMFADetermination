function Intensity = fitFunctionYeColorSingleWall(x, AtoTry,wavelengthToTry)

mfa = x(1);

AtoTry = rad2deg(AtoTry);
P = 45;

for aLoop = 1:length(AtoTry)
    Delta = (x(2)*0.05*1e-6*2*pi/wavelengthToTry(aLoop));
    
    A = AtoTry(aLoop);
    
% a = sind(2*mfa)^2 + cosd(Delta)*cosd(2*mfa)^2 - 1i*cosd(2*mfa)*sind(Delta);
% % Equation 4a
% 
% b = -sind(4*mfa)*sind(0.5*Delta)^2;
% % Equation 4b
% 
% c = -b;
% % Equation 4c
% 
% d = sind(2*mfa)^2 + cosd(Delta)*cosd(2*mfa)^2 + 1i*cosd(2*mfa)*sind(Delta);
% % Equation 4d
% 
% Ts = [a b ; c d];
% Equation 3
RmatRight = [cosd(mfa) sind(mfa) ; -sind(mfa) cosd(mfa)];
RmatLeft = [cosd(-mfa) sind(-mfa) ; -sind(-mfa) cosd(-mfa)];
Lmat = [exp(-1i*Delta*0.5) 0 ; 0 exp(1i*Delta*0.5)];
Ts = RmatLeft*Lmat*RmatRight;


I0 = 1e3*0.5;
E = sqrt(I0)*[cosd(A) sind(A)]*Ts*[cosd(P) sind(P)]'; 
% Equation 5
% N.B. I dropped the second row, so technically this is E(1). No loss of generality in 
% this setting.

Intensity(aLoop) = E.*conj(E);


% Intensity(aLoop) = I0*((c^2*cosd(P)^2 + a*d*sind(P)^2 + 0.5*c*(a+d)*sind(2*P))*sind(A)^2 ...
%                       +(a*d*cosd(P)^2 + b^2*sind(P)^2 + 0.5*b*(a+d)*sind(2*P))*cosd(A)^2 ...
%                       + 0.5*(c*(a+d)*cosd(P)^2 + b*(a+d)*sind(P)^2 + 0.5*(a^2+d^2+2*b*c)*sind(2*P))*sind(2*A));


end
% Top of page 6629, left hand side.
% IntensityOld == Intensity;








