%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% DEMO: Chen Ye, M. Olavi Sundström, Kari Remes
%
% Demo and verification of the equations in 
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
% Loosely based on the article.
% P = Fixed at 45 degrees.
% A = Rotating between set points [0 45 90 135] degrees.
% MFA = [-45 , 45] degrees.
% Delta = [0 , 90] degrees.

% Constant values
I0 = 1;     % Incoming intensity
P = 45;
ASetPoint = [0 45 90 135];

% Loop values
mfaToTry = linspace(-44,44,10); 
deltaToTry = 40;%linspace(0,90,5);
counter = 0;

ISetPoint = nan(numel(ASetPoint),1);
resultStore = nan(numel(mfaToTry)*numel(deltaToTry),4);

fprintf('%20s %10s          %10s %10s \n','','Real MFA', 'phi1', 'phi2');

for aLoop = 1:numel(deltaToTry)
    Delta = deltaToTry(aLoop);

    for bLoop = 1:numel(mfaToTry)
        mfa = mfaToTry(bLoop);

        for cLoop = 1:numel(ASetPoint)
            counter = counter + 1;
            A = ASetPoint(cLoop);

            a = sind(2*mfa)^2 + cosd(Delta)*cosd(2*mfa)^2 - 1i*cosd(2*mfa)*sind(Delta);
            % Equation 4a

            b = -sind(4*mfa)*sind(0.5*Delta)^2;
            % Equation 4b

            c = -b;
            % Equation 4c

            d = sind(2*mfa)^2 + cosd(Delta)*cosd(2*mfa)^2 + 1i*cosd(2*mfa)*sind(Delta);
            % Equation 4d

            Ts = [a b ; c d];
            % Equation 3

            E = sqrt(I0)*[cosd(A) sind(A)]*Ts*[cosd(P) sind(P)]'; 
            % Equation 5
            % N.B. I dropped the second row, so technically this is E(1). No loss of generality in 
            % this setting.

            Intensity = E*conj(E);
            % Top of page 6629, left hand side.
            
            ISetPoint(cLoop) = Intensity;
            % Collect intensity
        end

        T1 = (ISetPoint(2) - ISetPoint(4)) / (ISetPoint(2) + ISetPoint(4));
        % Equation 9a

        T2 = (ISetPoint(1) - ISetPoint(3)) / (ISetPoint(1) + ISetPoint(3));
        % Equation 9b

        phi1 = rad2deg(0.5*atan( -2*T2 /( sqrt(2*(1 + T1)) * (2 - sqrt(2*(1+T1)) ) ) ) );
        % Equation 10a

        phi2 = rad2deg(0.5*atan(  2*T2 /( sqrt(2*(1 + T1)) * (2 + sqrt(2*(1+T1)) ) ) ) );
        % Equation 10b
        
        fprintf(reportFormat,'',mfa, phi1, phi2);
        resultStore(counter,:) = [Delta mfa phi1 phi2];
        
    end
    pause(1)
end

figure;
plot(mfaToTry,mfaToTry,'--')
hold on
plot(resultStore(:,2),resultStore(:,3),'ob')
plot(resultStore(:,2),resultStore(:,4),'sr')
xlabel('Real MFA [Deg]')
ylabel('Ye \phi [Deg]')
legend('Equality','\phi_1(MFA)','\phi_2(MFA)','location','best')






