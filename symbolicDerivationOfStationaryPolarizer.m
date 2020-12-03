%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Symbolic derivation of transmission functions when the polarizer is stationary
% and the analyzer is rotated.
%
% Basically a proof of concept for the next step: Transmission function when
% the analyzer is stationary and the polarizer is rotated.
%
%
% ABOUT: Uses Reference 1 Eq 6 with P = 45 deg
%
% REFERENCES:
% [1] Ye C, Sundström MO, Remes K.
%     Microscopic transmission ellipsometry: measurement of the fibril angle and the relative phase retardation of single, intact wood pulp fibers.
%     Appl Opt 1994;33:6626. https://doi.org/10.1364/ao.33.006626.
% 
% created by: August Brandberg augustbr at kth dot se
% date: 2020-12-01

clear; close all; clc

I0 = 1; 
% Normalizing value for the intensity. Arbitrary units

A = sym('A','real');
% Analyzer position

mfa = sym('mfa','real');
% MFA

Delta = sym('Delta','positive');
% Retardance 

P = pi/4;
% Polarizer position [rad]


RmatRight = [         cos(mfa)  sin(mfa) ;  -sin(mfa)         cos(mfa)];
RmatLeft  = [        cos(-mfa) sin(-mfa) ; -sin(-mfa)        cos(-mfa)];
% Eq 2 in [1]

Lmat      = [exp(-1i*Delta*0.5)          0 ;           0 exp(1i*Delta*0.5)];
% Eq 1 in [1]
% Jones' matrices for the individual optical elements

Ts = RmatRight*Lmat*RmatLeft*RmatLeft*Lmat*RmatRight;
% Eq 3 in [1]
% Condensed/pre-computed transmission matrix

E = sqrt(I0)*[cos(A) sin(A)]*Ts*[cos(P) sin(P)]';
% First component of the electric field vector of the light beam behind
% the analyzer (Equation 5).
%
% N.B. I dropped the second row, so technically this is E(1). No loss of generality in 
% this setting.

I = simplify(E*conj(E));
% Top of page 6629, left hand side.

% Check answer by defining T1 and T2
T1 = 1 + 8*cos(2*mfa)^2*sin(0.5*Delta)^2* (cos(2*mfa)^2*sin(0.5*Delta)^2 - 1);
% Eq 8a in [1]

T2 = 2*sin(4*mfa)*sin(0.5*Delta)^2* (2*cos(2*mfa)^2*sin(0.5*Delta)^2 - 1);
% Eq 8b in [1]

I_Ye = 0.5*I0*(1 + T1*sin(2*A) + T2*cos(2*A));
% Eq 7 in [1]

diffABvsCY = simplify(I-I_Ye);
% Difference between calculation from all steps and end result in [1]

fprintf('%10s %20s\n','','Difference I_calc(P=45) - I_Ye = ');
fprintf('%10s %s\n','',diffABvsCY);







% Solving for mfa and delta (MATLAB == too stupid for trigonometry, doesn't work)
% I0 = sym('I0','positive');
% I45 = sym('I45','positive');
% I90 = sym('I90','positive');
% I135 = sym('I135','positive');
% Imeasured = [I0 I45 I90 I135]';
% 
Icalc = simplify([subs(I, A,0.25*[0 pi 2*pi 3*pi]')])
% 
% 
% solve(Icalc == Imeasured,mfa)





% Result copy-pasted from symbolicDerivationOfStationaryAnalyzer.m
IcalcA =[
 sin(4*mfa)/4 - sin(8*mfa)/8 - (sin(4*mfa)*cos(Delta)^2)/4 + (cos(4*mfa)*sin(4*mfa)*cos(Delta))/2 - (cos(4*mfa)*sin(4*mfa)*cos(Delta)^2)/4 + 1/2
                                                                                       (cos(Delta) - cos(4*mfa) + cos(4*mfa)*cos(Delta) + 1)^2/4
 sin(8*mfa)/8 - sin(4*mfa)/4 + (sin(4*mfa)*cos(Delta)^2)/4 - (cos(4*mfa)*sin(4*mfa)*cos(Delta))/2 + (cos(4*mfa)*sin(4*mfa)*cos(Delta)^2)/4 + 1/2
                                                    -((cos(Delta) - 1)*(cos(4*mfa) + 1)*(cos(Delta) - cos(4*mfa) + cos(4*mfa)*cos(Delta) + 3))/4]

% Equations are identical (but ordered differently, obviously).



