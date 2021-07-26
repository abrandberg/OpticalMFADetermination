%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Symbolic derivation of transmission functions when the polarizer is stationary
% and the analyzer is rotated.
%
% Basically a proof of concept for the next step: Transmission function when
% the analyzer is stationary and the polarizer is rotated.
%
%
% ABOUT: Uses Reference 1 Eq 6 with A = 45 deg
%
% REFERENCES:
% [1] Ye C, Sundström MO, Remes K.
%     Microscopic transmission ellipsometry: measurement of the fibril angle and the relative phase retardation of single, intact wood pulp fibers.
%     Appl Opt 1994;33:6626. https://doi.org/10.1364/ao.33.006626.
% 
% created by: August Brandberg augustbr at kth dot se
% date: 2020-12-01

clear; close all; clc
format compact
fprintf('%10s %20s\n','','Symbolic derivation of Intensity(P=45 deg, A)');
fprintf('%10s %20s\n','','');


I0 = 1; 
% Normalizing value for the intensity. Arbitrary units

P = sym(pi/4); 
% Analyzer position

mfa = sym('mfa','real');
% MFA

Delta = sym('Delta','positive');
% Retardance 

A = sym('A','real');
% Polarizer position [rad]


RmatRight = [         cos(mfa)  sin(mfa) ;  -sin(mfa)         cos(mfa)];
RmatLeft  = [        cos(-mfa) sin(-mfa) ; -sin(-mfa)        cos(-mfa)];
% Eq 2 in [1]

Lmat      = [exp(-1i*Delta*0.5)          0 ;           0 exp(1i*Delta*0.5)];
% Eq 1 in [1]
% Jones' matrices for the individual optical elements



% New layers
DeltaS1 = sym('DeltaS1','positive');
DeltaS3 = sym('DeltaS3','positive');
mOrto = sym(pi*0.5);%deg2rad(90);
S1_1 = [cos(-mOrto) sin(-mOrto) ; -sin(-mOrto) cos(-mOrto)]*[exp(-1i*DeltaS1*0.5) 0 ; 0 exp(1i*Delta*0.5)]*[cos(mOrto)  sin(mOrto) ;  -sin(mOrto) cos(mOrto)];
S3_1 = [cos(-mOrto) sin(-mOrto) ; -sin(-mOrto) cos(-mOrto)]*[exp(-1i*DeltaS3*0.5) 0 ; 0 exp(1i*Delta*0.5)]*[cos(mOrto)  sin(mOrto) ;  -sin(mOrto) cos(mOrto)];

mOrto2 = sym(-pi*0.5);%deg2rad(-90);
S1_2 = [cos(-mOrto2) sin(-mOrto2) ; -sin(-mOrto2) cos(-mOrto2)]*[exp(-1i*DeltaS1*0.5) 0 ; 0 exp(1i*Delta*0.5)]*[cos(mOrto2)  sin(mOrto2) ;  -sin(mOrto2) cos(mOrto2)];
S3_2 = [cos(-mOrto2) sin(-mOrto2) ; -sin(-mOrto2) cos(-mOrto2)]*[exp(-1i*DeltaS3*0.5) 0 ; 0 exp(1i*Delta*0.5)]*[cos(mOrto2)  sin(mOrto2) ;  -sin(mOrto2) cos(mOrto2)];



Ts = simplify(S1_2*RmatRight*Lmat*RmatLeft* S3_2 *  S3_1*RmatLeft*Lmat*RmatRight*S1_1);
% Eq 3 in [1]
% Condensed/pre-computed transmission matrix

E = simplify(sqrt(I0)*[cos(A) sin(A)]*Ts*[cos(P) sin(P)]');
% First component of the electric field vector of the light beam behind
% the analyzer (Equation 5).
%
% N.B. I dropped the second row, so technically this is E(1). No loss of generality in 
% this setting.

I = simplify(E*conj(E));
% Top of page 6629, left hand side.
% 
% % Check answer by defining T1 and T2
% T1 = 1 + 8*cos(2*mfa)^2*sin(0.5*Delta)^2* (cos(2*mfa)^2*sin(0.5*Delta)^2 - 1);
% % Eq 8a in [1]
% 
% T2 = 2*sin(4*mfa)*sin(0.5*Delta)^2* (2*cos(2*mfa)^2*sin(0.5*Delta)^2 - 1);
% % Eq 8b in [1]
% 
% I_Ye = 0.5*I0*(1 + T1*sin(2*A) + T2*cos(2*A));
% % Eq 7 in [1]
% 
% diffABvsCY = simplify(I-I_Ye);
% % Difference between calculation from all steps and end result in [1]
% 
% fprintf('%10s %20s\n','','I_calc(A=45,P) - I_Ye(A,P=45) = ');
% fprintf('%10s %s\n','',diffABvsCY);
% 
% fprintf('%10s %20s\n','','');
% fprintf('%10s %20s\n','','Correct I(A=45,P) = ');
% fprintf('%10s %s\n','',I);
% 
% fprintf('%10s %20s\n','','');
% fprintf('%10s %s\n','','Warning: Rotating polarizer does not guarantee constant I0.')
% fprintf('%10s %s\n','','Consider using intensity relative to nominal intensity instead.')
% 
% 
% % Solving for mfa and delta
% I0 = sym('I0','positive');
% I45 = sym('I45','positive');
% I90 = sym('I90','positive');
% I135 = sym('I135','positive');
% Imeasured = [I0 I45 I90 I135]';
% 
% Icalc = simplify([subs(I, P,0.25*[0 pi 2*pi 3*pi]')])
% 
% 
% solve(Icalc == Imeasured,mfa)






% The question is now if we can find a DeltaS1_B, mfa_B, Delta_B and DeltaS3_B such that the sum
% matches that calculated using DeltaS1_A, mfa_A, Delta_A and DeltaS3_A for all values of 
mfa_A = sym('mfa_A','real');
mfa_B = sym('mfa_B','real');

DeltaS1_A = sym('DeltaS1_A','positive');
DeltaS1_B = sym('DeltaS1_B','positive');

Delta_A = sym('Delta_A','positive');
Delta_B = sym('Delta_B','positive');

DeltaS3_A = sym('DeltaS3_A','positive');
DeltaS3_B = sym('DeltaS3_B','positive');


IA = subs(I,mfa,mfa_A);
IA = subs(IA,DeltaS1,DeltaS1_A);
IA = subs(IA,Delta,Delta_A);
IA = simplify(subs(IA,DeltaS3,DeltaS3_A));

IB = subs(I,mfa,mfa_B);
IB = subs(IB,DeltaS1,DeltaS1_B);
IB = subs(IB,Delta,Delta_A);
IB = simplify(subs(IB,DeltaS3,DeltaS3_B));
% 
% 
% xp = solve(IA == IB,mfa_B)
% solve(IA == IB,[DeltaS1_B , mfa_B , Delta_B , DeltaS3_B])


% TSA = subs(Ts,mfa,mfa_A);
% TSA = subs(TSA,DeltaS1,DeltaS1_A);
% TSA = subs(TSA,Delta,Delta_A);
% TSA = simplify(subs(TSA,DeltaS3,DeltaS3_A));
% 
% TSB = subs(Ts,mfa,mfa_B);
% TSB = subs(TSB,DeltaS1,DeltaS1_B);
% TSB = subs(TSB,Delta,Delta_B);
% TSB = simplify(subs(TSB,DeltaS3,DeltaS3_B));
% 
% 
% xp = solve(TSA == TSB,[mfa_B Delta_B],'ReturnConditions',true)



% AP = simplify(RmatRight*Lmat*RmatLeft* RmatLeft*Lmat*RmatRight);
% 
% AP_A = subs(AP,mfa,mfa_A);
% AP_A = subs(AP_A,Delta,Delta_A);
% AP_B = subs(AP,mfa,mfa_B);
% AP_B = subs(AP_B,Delta,Delta_B);
% 
% xp = solve(AP_A == AP_B,[mfa_B],'ReturnConditions',true)

% Single wall
AP = simplify(RmatLeft*Lmat*RmatRight);

AP_A = subs(AP,mfa,mfa_A);
AP_A = subs(AP_A,Delta,Delta_A);
AP_B = subs(AP,mfa,mfa_B);
AP_B = subs(AP_B,Delta,Delta_B);



[solx,parameters,conditions] = solve(AP_A == AP_B,[mfa_B],'ReturnConditions',true)

assume(conditions)
restriction = [solx >= 0, solx <= 0.5*pi];
solk = solve(restriction,parameters)

valx = subs(solx,parameters,solk)




