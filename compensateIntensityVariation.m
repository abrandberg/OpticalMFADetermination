function I0 = compensateIntensityVariation(polarizerPosition,analyzerPosition,Iref)
%function compensateIntensityVariation compensates for partially polarized source light when the
% Chun Ye method is used together with a switch of moving component from the analyzer to the polarizer.
%
% This compensation requires a second measurement point, which should contain no optical elements
% other than the polarizer and analyzer.
%
% INPUTS:
%       NAME                        TYPE                    SIZE
%       polarizerPosition           {Numeric matrix}        [n x 1] or [1 x n], n = number of measurements
%           Polarizer position in radians.
%
%       analyzerPosition            {Numeric matrix}        [n x 1] or [1 x n], n = number of measurements
%           Analyzer position in radians.
%
%       Iref                        {Numeric matrix}        [n x 1] or [1 x n], n = number of measurements
%           Output (measured) intensity of ray that did not pass through the fiber/waveplate(s).
%           Typically given in W/m^2 (Joule per second per square meter).
%
%
% OUTPUTS:
%       NAME                        TYPE                    SIZE
%       I0                          {Numeric matrix}        [n x 1] or [1 x n] or [1 x 1], n = number of measurements
%           Ray intensity exiting the polarizer. If scalar is supplied, function expands it to a vector.
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
%
%
% Created by: August Brandberg augustbr at kth dot se
% Date: 2020-12-10


polarizerPosition = rad2deg(polarizerPosition);
analyzerPosition = rad2deg(analyzerPosition);


for aLoop = 1:length(analyzerPosition)
    A = analyzerPosition(aLoop);
    % Set current analyzer position
    
    P = polarizerPosition(aLoop);
    % Set current polarizer position
    
    Enorm = [cosd(A) sind(A)]*[cosd(P) sind(P)]'; 
    % First component of the electric field vector of the light beam behind
    % the analyzer (Equation 5).
    %
    % N.B. I dropped the second row, so technically this is E(1). No loss of generality in 
    % this setting.

    I0(aLoop) = Iref(aLoop)/(Enorm.*conj(Enorm));
    % Top of page 6629, left hand side, inverted.
end

I0 = reshape(I0,[],1);
% Always return a column vector
