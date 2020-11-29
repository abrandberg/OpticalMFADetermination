%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Verification of MFA-determination algorithms using COMSOL geometrical
% optics as an intensity generator.
%
%
% ABOUT: Intensity data has been precomputed using the COMSOL model found in
%
% REFERENCES:
% [1] Ye C, Sundström MO, Remes K.
%     Microscopic transmission ellipsometry: measurement of the fibril angle and the relative phase retardation of single, intact wood pulp fibers.
%     Appl Opt 1994;33:6626. https://doi.org/10.1364/ao.33.006626.
% 
% created by: August Brandberg augustbr at kth dot se
% date: 2020-11-28
%
clear; close all; clc
format compact
reportFormat = '%20s %10.1f          %10.1f %10.1f\n';
options = optimoptions(@fminunc,'Display','iter');


% Import pre-computed data (uncomment one)
load(['precomputedData' filesep 'precomputed_MFA=8_WALL=3_YE.mat'])
% load(['precomputedData' filesep 'precomputed_MFA=14_WALL=3_YE.mat'])
% load(['precomputedData' filesep 'precomputed_MFA=14_WALL=1_YE.mat'])
% load(['precomputedData' filesep 'precomputed_MFA=8_WALL=1_YE.mat'])
IntensitySweep(:,3) = [];



% Use Chun Ye et al. minimum viable model (Equation 9 to 11 in [1])
[chunYeSet1,chunYeSet2] = chunYe(IntensitySweep);


% Use Chun Ye et al. model with over-sampling
fitFcn  = @(x, A,wavelength) fitFunctionYeColor(x,A,wavelength);
costFcn = @(x) sqrt(1/size(IntensitySweep,1)*sum((fitFcn(x,IntensitySweep(:,1),IntensitySweep(:,2)) - IntensitySweep(:,3)').^2));
xSingleStart = fminunc(costFcn,[15 6],options)


% Use Chun Ye et al. model with restarting (less dependent on x0 guess)
if license('test', 'Optimization_Toolbox')
    gs = GlobalSearch;
    problem = createOptimProblem('fmincon','x0',[0 2],'objective',costFcn,'lb',[-40,1],'ub',[40,8]);
    x = run(gs,problem)

else
    fprintf('%s\n','Global Search Optimization toolbox not found. Using xSingleStart');
    fprintf('%s\n','Exercise caution if this if this warning has been triggered. Possibly unstable solution.');
    x = xSingleStart;
end




% Fit raw analyzer position versus intensity, data + fit
predictedIntensity = nan(size(IntensitySweep,1),1);
for bLoop = 1:size(IntensitySweep,1)
    predictedIntensity(bLoop) = fitFcn(x,IntensitySweep(bLoop,1),IntensitySweep(bLoop,2));
end
figure('color','w','units','centimeters','OuterPosition',[10 10 16 16]);
plot(rad2deg(IntensitySweep(:,1)), IntensitySweep(:,3),'ob')
hold on
plot(rad2deg(IntensitySweep(:,1)), predictedIntensity,'rd')
xlim([0 360])
ylim(1.25.*[min(IntensitySweep(:,3)) max(IntensitySweep(:,3))])
xlabel('Analyzer position [rad]')
ylabel('Intensity [a.u.]')
legend('Raw data','Fitted model','location','best')


% Sweep over solution space to draw error contours
mfaToTry = -40:0.2:40;
wallToTry = 0.5:0.1:8;
[X,Y] = meshgrid(mfaToTry,wallToTry);
Z = nan(size(X));
for aLoop = 1:size(X,1)
    for bLoop = 1:size(Y,2)
        Z(aLoop,bLoop) = costFcn([X(aLoop,bLoop) Y(aLoop,bLoop)]');
    end
end
figure('color','w','units','centimeters','OuterPosition',[10 10 16 16]);
contourf(X,Y,Z,round(linspace(0.2,max(max(Z)),20),2)) 
hold on
plot(inputs.mfa,inputs.wallTkn*1e6,'c^','markerfacecolor','c')
plot(x(1),x(2),'dm','markerfacecolor','m')
plot(chunYeSet1(:,1),chunYeSet1(:,2),'sr','markerfacecolor','r')
plot(chunYeSet2(:,1),chunYeSet2(:,2),'or','markerfacecolor','r')
legend('Error contours','True values','GlobalSearch est.','Chun Ye et al., (1)','Chun Ye et al., (2)')
xlabel('MFA [deg]')
ylabel('WallTkn [\mu m]')






