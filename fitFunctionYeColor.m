function Intensity = fitFunctionYeColor(x, AtoTry,wavelengthToTry)

mfa = x(1);
% Unpacking

AtoTry = rad2deg(AtoTry);
% Analyzer position is given in radians inside COMSOL.

P = 45;
% Hard-coded polarizer position for Chun Ye et al. method.

for aLoop = 1:length(AtoTry)
    A = AtoTry(aLoop);
    % Set current analyzer position
    
    Delta = (x(2)*0.05*1e-6*2*pi/wavelengthToTry(aLoop));
    % Equation (12)

    RmatRight = [         cosd(mfa)  sind(mfa) ;  -sind(mfa)         cosd(mfa)];
    RmatLeft  = [        cosd(-mfa) sind(-mfa) ; -sind(-mfa)        cosd(-mfa)];
    Lmat      = [exp(-1i*Delta*0.5)          0 ;           0 exp(1i*Delta*0.5)];
    % Jones' matrices for the individual optical elements
    
    Ts = RmatRight*Lmat*RmatLeft*RmatLeft*Lmat*RmatRight;
    % Condensed/pre-computed transmission matrix

    I0 = 1e3*0.5;
    % Intensity (set to match COMSOL settings)
    
    E = sqrt(I0)*[cosd(A) sind(A)]*Ts*[cosd(P) sind(P)]'; 
    % First component of the electric field vector of the light beam behind
    % the analyzer (Equation 5).
    %
    % N.B. I dropped the second row, so technically this is E(1). No loss of generality in 
    % this setting.

    Intensity(aLoop) = E.*conj(E);
    % Top of page 6629, left hand side.

end


