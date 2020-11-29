function [outputSet1, outputSet2] = chunYe(IntensitySweep)
% Intensity sweep contains all of the data, organized in 3 columns:
%   >   Analyzer angle
%   >   Wavelength
%   >   Output intensity


uniqueWavelengths = unique(IntensitySweep(:,2));

anglesToCatch = [0 pi/4 2*pi/4 3*pi/4];

for aLoop = 1:length(uniqueWavelengths)
    waveSel = IntensitySweep(:,2) == uniqueWavelengths(aLoop);
    
    for bLoop = 1:4
        angleSel = 1e-4 > abs(IntensitySweep(:,1) - anglesToCatch(bLoop));
        catchSel = waveSel & angleSel;
        ISetPoint(aLoop,bLoop) = IntensitySweep(catchSel,3);
    end
end


T1 = (ISetPoint(:,2) - ISetPoint(:,4)) ./ (ISetPoint(:,2) + ISetPoint(:,4));
        % Equation 9a

T2 = (ISetPoint(:,1) - ISetPoint(:,3)) ./ (ISetPoint(:,1) + ISetPoint(:,3));
% Equation 9b

phi1 = rad2deg(0.5*atan( -2*T2 ./( sqrt(2*(1 + T1)) .* (2 - sqrt(2*(1+T1)) ) ) ) );
% Equation 10a

phi2 = rad2deg(0.5*atan(  2*T2 ./( sqrt(2*(1 + T1)) .* (2 + sqrt(2*(1+T1)) ) ) ) );
% Equation 10b
        
%         fprintf(reportFormat,'',mfa, phi1, phi2);
%         resultStore(counter,:) = [Delta mfa phi1 phi2];


Delta1=acos( 1-(1 - 0.5*sqrt(2+2*T1)) ./ cos(2*phi1).^2 );
Delta2=acos( 1-(1 + 0.5*sqrt(2+2*T1)) ./ cos(2*phi2).^2 );


% = (x(2)*0.05*1e-6*2*pi/wavelengthToTry(aLoop));
wt1 = Delta1./0.05./1e-6./(2*pi).*uniqueWavelengths;
wt2 = Delta2./0.05./1e-6./(2*pi).*uniqueWavelengths;

selIdx1 = ~(imag(wt1));
phi1 = phi1(selIdx1);
wt1 = wt1(selIdx1);

selIdx2 = ~(imag(wt2));
phi2 = phi2(selIdx2);
wt2 = wt2(selIdx2);

outputSet1 = [phi1 wt1];
outputSet2 = [phi2 wt2];
