%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% DEMO: Chen Ye, M. Olavi Sundström, Kari Remes
%
% 
%
% INSERT REFERENCE INFO
%
% Created by: August Brandberg  augustbr at kth dot se
% date: 2020-11-13
%
%
% Meta instructions
clear; close all; clc
format compact

reportFormat = '%20s %10.1f          %10.1f %10.1f\n';

% Demo 1:
% Loosely based on CDL Presentation
% A = Rotating between [0 360] degrees.
% P = Rotating at A+90 degrees.
% MFA = [-45 , 45] degrees.

% Constant values
I0 = 1;     % Incoming intensity

ASetPoint = linspace(0,360,37);         % Analyzer positions

% Loop values
mfaToTry = linspace(-44,44,10); 

counter = 0;

ISetPoint = nan(numel(ASetPoint),1);
resultStore = nan(numel(mfaToTry),4);



for aLoop = 1:numel(mfaToTry)
    mfa = mfaToTry(aLoop)
    for bLoop = 1:numel(ASetPoint)

        A = ASetPoint(bLoop);
        P = A + 90;

        I = I0*sind(2*-mfa)^2; 
        % Eq on slide 4 of presentation, with theta = 0 (fiber aligned) and C = 0 (arbitrary in this setting)

        ISetPoint(bLoop) = I;
    end

    plot(ASetPoint,ISetPoint,'-o','DisplayName',['MFA = ' sprintf('%3.1f',mfa) '^\circ'])
    hold on
end
legend('location','best')
xlabel('Analyzer position [Deg]')
ylabel('Intensity output [a.u.]')