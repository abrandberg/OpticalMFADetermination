function Intensity = fitFunctionYeColor(x, polarizerPosition, analyzerPosition, wavelength,I0)
%function fitFunctionYeColor calculates the expected output light intensity. The function is based
%around reference 1, meaning it assumes the fiber can be idealized as two crossed linear retarders.
%
% INPUTS:
%       NAME                        TYPE                    SIZE
%       x                           {Numeric matrix}        [2 x 1] or [1 x 2]
%           Fitting variables.
%           Columns:
%           [1]             Micro-fibril angle, in degrees.
%           [2]             Wall thickness, in um (10^-6 * m)
%
%       polarizerPosition           {Numeric matrix}        [n x 1] or [1 x n], n = number of measurements
%           Polarizer position in radians.
%
%       analyzerPosition            {Numeric matrix}        [n x 1] or [1 x n], n = number of measurements
%           Analyzer position in radians.
%
%       wavelength                  {Numeric matrix}        [n x 1] or [1 x n], n = number of measurements
%           Wavelength in meters.
%
%       I0                          {Numeric matrix}        [n x 1] or [1 x n] or [1 x 1], n = number of measurements
%           Ray intensity exiting the polarizer. If scalar is supplied, function expands it to a vector.
%           Typically given in W/m^2 (Joule per second per square meter).
%
%
% OUTPUTS:
%       NAME                        TYPE                    SIZE
%       Intensity                   {Numeric matrix}        [n x 1], n = number of measurements
%           Output intensity for each of the measurements performed. 
%           Typically given in W/m^2 (Joule per second per square meter).
%
%
% REFERENCES:
% [1] Ye C, Sundström MO, Remes K. 
%     Microscopic transmission ellipsometry: measurement of the fibril angle and the relative phase retardation of single, intact wood pulp fibers.
%     Appl Opt 1994;33:6626. https://doi.org/10.1364/ao.33.006626.
%
%
% ABOUT:
% The function "fitFunctionYeColorSingleWall.m" implements this method for the case of light passing
% through a single fiber wall. 
%
%
% Created by: August Brandberg augustbr at kth dot se
% Date: 2020-12-09


mfa = x(1);
tf = x(2);
% Unpacking

if length(I0) == 1
    % If scalar given, expand. Convenient if analyzer is rotated.
    I0 = I0.*ones(1,length(polarizerPosition));
end

analyzerPosition = rad2deg(analyzerPosition);
polarizerPosition = rad2deg(polarizerPosition);


for aLoop = 1:length(analyzerPosition)
    A = analyzerPosition(aLoop);
    % Set current analyzer position
    
    P = polarizerPosition(aLoop);
    % Set current polarizer position
    
    Delta = (tf*0.05*1e-6*2*pi/wavelength(aLoop));
    % Equation (12)

    RmatRight = [         cosd(mfa)  sind(mfa) ;  -sind(mfa)         cosd(mfa)];
    RmatLeft  = [        cosd(-mfa) sind(-mfa) ; -sind(-mfa)        cosd(-mfa)];
    Lmat      = [exp(-1i*Delta*0.5)          0 ;           0 exp(1i*Delta*0.5)];
    % Jones' matrices for the individual optical elements
    
    Ts = RmatRight*Lmat*RmatLeft*RmatLeft*Lmat*RmatRight;
    % Condensed/pre-computed transmission matrix
    % Equation 1

    E = sqrt(I0(aLoop)) * [cosd(A) sind(A)]*Ts*[cosd(P) sind(P)]'; 
    % First component of the electric field vector of the light beam behind
    % the analyzer (Equation 5).
    %
    % N.B. I dropped the second row, so technically this is E(1). No loss of generality in 
    % this setting.

    Intensity(aLoop) = E.*conj(E);
    % Top of page 6629, left hand side.
end

Intensity = reshape(Intensity,[],1);
% Always return a column vector

end % End of function fitFunctionYeColor

