function [outputSet1, outputSet2] = chunYe(experimentalConditions,rotatorSwitch)
%function chunYe calculates the MFA and wall thickness given intensity values, wavelengths of the
%light used and position of the rotating polarizer or analyzer.
%
% INPUTS:
%       NAME                        TYPE                    SIZE
%       experimentalConditions      {Numeric matrix}        [n x 3], n = number of measurements
%           Columns:
%           [:,1]           Analyzer or polarizer position in radians. Whichever was rotated should 
%                           be suppled.
%           [:,2]           Wavelength of the monochromatic light used. Should be given in SI unit (meters)
%           [:,3]           Output intensity - Intensity recorded by the camera.
%
%       rotatorSwitch               {String}                Arbitrary size
%           IF rotatorSwitch == 'P'
%           The first column of "experimentalConditions" is taken to be the polarizer position.
%           ELSE
%           The first column of "experimentalConditions" is taken to be the analyzer position.
%
%
% OUTPUTS:
%       NAME                        TYPE                    SIZE
%       outputSet1                  {Numeric matrix}        [m x 2], m = number of unique wavelengths used that returned real wall thickness
%           Columns:
%           [:,1]           MFA estimates for each wavelength used in degrees. Solution set 1.
%           [:,2]           Wall thickness estimates for each wavelength used, in micro meters (10^-6*meters)
%                           Solution set 1.
%
%       outputSet2                  {Numeric matrix}        [m x 2], m = number of unique wavelengths used that returned real wall thickness
%           Columns:
%           [:,1]           MFA estimates for each wavelength used in degrees. Solution set 2.
%           [:,2]           Wall thickness estimates for each wavelength used, in micro meters (10^-6*meters)
%                           Solution set 2.
%
% REFERENCES:
% [1] Ye C, Sundström MO, Remes K. 
%     Microscopic transmission ellipsometry: measurement of the fibril angle and the relative phase retardation of single, intact wood pulp fibers.
%     Appl Opt 1994;33:6626. https://doi.org/10.1364/ao.33.006626.
%
%
% ABOUT:
% 
%
% Created by: August Brandberg augustbr at kth dot se
% Date: 2020-12-09


uniqueWavelengths = unique(experimentalConditions(:,2));
% Find and return each unique wavelength input.

anglesToCatch = [0 pi/4 2*pi/4 3*pi/4];
% Chun Ye uses these 4 angles to construct equation 9 - 12.

ISetPoint = nan(length(uniqueWavelengths), length(anglesToCatch));

for aLoop = 1:length(uniqueWavelengths)
    waveSel = experimentalConditions(:,2) == uniqueWavelengths(aLoop);
    for bLoop = 1:numel(anglesToCatch)
        angleSel = 1e-4 > abs(experimentalConditions(:,1) - anglesToCatch(bLoop));
        catchSel = waveSel & angleSel;
        ISetPoint(aLoop,bLoop) = experimentalConditions(catchSel,3);
    end
end

assert(sum(sum(isnan(ISetPoint))) == 0,'Intensity records are rank deficient. A At least one wavelength must have recordings for [0, 45, 90, 135] degrees.')

if strcmp(rotatorSwitch,'P')
    ISetPoint = ISetPoint(:,[3 2 1 4]);
end


T1 = (ISetPoint(:,2) - ISetPoint(:,4)) ./ (ISetPoint(:,2) + ISetPoint(:,4));
% Equation 9a

T2 = (ISetPoint(:,1) - ISetPoint(:,3)) ./ (ISetPoint(:,1) + ISetPoint(:,3));
% Equation 9b

phi1 = rad2deg(0.5*atan( -2*T2 ./( sqrt(2*(1 + T1)) .* (2 - sqrt(2*(1+T1)) ) ) ) );
% Equation 10a

phi2 = rad2deg(0.5*atan(  2*T2 ./( sqrt(2*(1 + T1)) .* (2 + sqrt(2*(1+T1)) ) ) ) );
% Equation 10b
        
Delta1=acos( 1-(1 - 0.5*sqrt(2+2*T1)) ./ cos(2*phi1).^2 );
% Equation 11a

Delta2=acos( 1-(1 + 0.5*sqrt(2+2*T1)) ./ cos(2*phi2).^2 );
% Equation 11b

wt1 = Delta1./0.05./1e-6./(2*pi).*uniqueWavelengths;
wt2 = Delta2./0.05./1e-6./(2*pi).*uniqueWavelengths;
% Equation 12

selIdx1 = ~(imag(wt1));
% Select only outputs without complex-valued wall thickness
phi1 = phi1(selIdx1);
wt1 = wt1(selIdx1);

selIdx2 = ~(imag(wt2));
phi2 = phi2(selIdx2);
wt2 = wt2(selIdx2);

outputSet1 = [phi1 wt1];
outputSet2 = [phi2 wt2];
% Collect outputs


end % End of function chunYe.m