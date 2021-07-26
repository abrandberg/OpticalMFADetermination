function Intensity = fitFunctionYeColorSingleWall_mcmcVersion(params, polarizerPosition, analyzerPosition, wavelength,I0,ctrl)
%function fitFunctionYeColorSingleWall calculates the expected output light intensity. The function is based
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
% The function "fitFunctionYeColor.m" implements this method for the case of light passing
% through two fiber walls. 
%
%
% Created by: August Brandberg augustbr at kth dot se
% Date: 2020-12-09

S1Angle1 = params.S1Angle1;
S2Angle1 = params.S2Angle1;
S3Angle1 = params.S3Angle1;

S1Angle2 = params.S1Angle2;
S2Angle2 = params.S2Angle2;
S3Angle2 = params.S3Angle2;

S1Tkn1 = params.S1Tkn1;
S2Tkn1 = params.S2Tkn1;
S3Tkn1 = params.S3Tkn1;

S1Tkn2 = params.S1Tkn2;
S2Tkn2 = params.S2Tkn2;
S3Tkn2 = params.S3Tkn2;

Ret_S1 = params.Ret_S1; 
Ret_S2 = params.Ret_S2;
Ret_S3 = params.Ret_S3;
%Unpacking

if length(I0) == 1
    % If scalar given, expand. Convenient if analyzer is rotated.
    I0 = I0.*ones(1,length(polarizerPosition));
end

polarizerPosition = rad2deg(polarizerPosition);
analyzerPosition = rad2deg(analyzerPosition);


for aLoop = 1:length(analyzerPosition)
    DeltaS1_1 = (S1Tkn1*Ret_S1*1e-6*2*pi/wavelength(aLoop));
    DeltaS2_1 = (S2Tkn1*Ret_S2*1e-6*2*pi/wavelength(aLoop));
    DeltaS3_1 = (S3Tkn1*Ret_S3*1e-6*2*pi/wavelength(aLoop));
    
    DeltaS1_2 = (S1Tkn2*Ret_S1*1e-6*2*pi/wavelength(aLoop));
    DeltaS2_2 = (S2Tkn2*Ret_S2*1e-6*2*pi/wavelength(aLoop));
    DeltaS3_2 = (S3Tkn2*Ret_S3*1e-6*2*pi/wavelength(aLoop));
    
    
%     Delta = (tf*0.05*1e-6*2*pi/wavelength(aLoop));
    
    A = analyzerPosition(aLoop);
    % Set current analyzer position

    P = polarizerPosition(aLoop);
    % Set current polarizer position
    
    if strcmp(ctrl.opticalModel,'singleWall')
        
        Ts1S1 = eye(2);
        Ts1S2 = eye(2);
        Ts1S3 = eye(2);
    else
        % Wall 1: S1
        Ts1S1 = singleWallTransmissionFunction(S1Angle1,DeltaS1_1);

        % Wall 1: S2
        Ts1S2 = singleWallTransmissionFunction(S2Angle1,DeltaS2_1);

        % Wall 1: S3
        Ts1S3 = singleWallTransmissionFunction(S3Angle1,DeltaS3_1);
    end
    % Wall 2: S1
    Ts2S1 = singleWallTransmissionFunction(S1Angle2,DeltaS1_2);
    
    % Wall 2: S2
    Ts2S2 = singleWallTransmissionFunction(S2Angle2,DeltaS2_2);
    
    % Wall 2: S3
    Ts2S3 = singleWallTransmissionFunction(S3Angle2,DeltaS3_2);
    
    E = sqrt(I0(aLoop)) * [cosd(A) sind(A)]*Ts2S1*Ts2S2*Ts2S3*Ts1S3*Ts1S2*Ts1S1*[cosd(P) sind(P)]'; 
    % Equation 5
    % N.B. I dropped the second row, so technically this is E(1). No loss in 
    % this setting.

    Intensity(aLoop) = E.*conj(E);
    % Top of page 6629, left hand side.
end


Intensity = reshape(Intensity,[],1);
% Always return a column vector

end % End of function 





