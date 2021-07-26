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

%% Various input options. In general, do not touch.
clear; close all; clc
format compact
reportFormat = '%20s %10.1f          %10.1f %10.1f\n';
% options = optimoptions(@fminunc,'Display','iter');

ctrl.interpreter = 'latex';
ctrl.markerChain = {'<','>','^','o','s','d'};
lineInstructions = {'markersize',8};

ctrl.opticalModel = 'QuarterWaveplate'; %2xQuarterWaveplate
% Choice of system:
% 'fiber'       -> Polarizer - Fiber wall - Fiber wall - Analyzer 
%                 (uses fitFunctionYeColor.m)
% 'singleWall'  -> Polarizer - Fiber wall - Analyzer
%                 (uses fitFunctionYeColorSingleWall.m)
% 'QuarterWaveplate' -> Same as singleWall, but with known retardance

%% Precomputed response from COMSOL model. Uncomment one.
resultDir = 'precomputedData';


resultToImport = 'precomputed_MFA=15_Pmoving_QuarterWaveplate_REF=YES.mat';
% resultToImport = 'precomputed_MFA=15_Pmoving_0.4Pol_QuarterWaveplate_REF=YES.mat';
load([resultDir filesep resultToImport])
% load('precomputed_MFA=15QWave4.25Ret.mat')
% load('precomputed_MFA=15QWave90Ret.mat')

pathToExperiment = 'C:\Users\augus\Downloads\OneDrive_2021-01-21\polarization verification_consolidatedData\Exp_Results_1WP -15.mat'; % Low sensitivity, moderate accuracy
pathToExperiment = 'C:\Users\augus\Downloads\OneDrive_2021-01-21\polarization verification_consolidatedData\Exp_Results_1WP +15.mat'; % Low sensitivity, moderate accuracy
pathToExperiment = 'C:\Users\augus\Downloads\OneDrive_2021-01-21\polarization verification_consolidatedData\Exp_Results_1WP 10.mat'; % Perfect fit, wrong answer
% pathToExperiment = 'C:\Users\augus\Downloads\OneDrive_2021-01-21\polarization verification_consolidatedData\Exp_Results_1WP 16.mat'; % Low sensitivity, moderate accuracy
% pathToExperiment = 'C:\Users\augus\Downloads\OneDrive_2021-01-21\polarization verification_consolidatedData\Exp_Results_1WP 30.mat'; %
% pathToExperiment = 'C:\Users\augus\Downloads\OneDrive_2021-01-21\polarization verification_consolidatedData\Exp_Results_2WP 10.mat'; %
% pathToExperiment = 'C:\Users\augus\Downloads\OneDrive_2021-01-21\polarization verification_consolidatedData\Exp_Results_2WP 16.mat'; %
% 
[IntensitySweepReal,legendIntensitySweep] = importTampereExperiments(pathToExperiment);
[IntensitySweep,legendIntensitySweep] = importTampereExperiments(pathToExperiment);


IntensitySweep(:,3) = IntensitySweep(:,3) + deg2rad(50)+ deg2rad(1);
IntensitySweep(:,4) = IntensitySweep(:,4) + deg2rad(50)+ deg2rad(1);




if size(IntensitySweep,2) == 4 
    fprintf('%s\n','Legacy save format. Polarizer position fixed.');
    IntensitySweep(:,3) = [];
    sizeOfArray = size(IntensitySweep);
    IntensitySweep = [[deg2rad(inputs.mfa) inputs.wallTkn inputs.PolarizerOrientation].*ones(sizeOfArray(1),1) IntensitySweep];
else
    fprintf('%s\n','Latest format.');
    fprintf('%s\n','Columns of IntensitySweep:');
    fprintf('%20s %10s %10s %10s %10s %10s %10s %10s %10s\n','',legendIntensitySweep{:});
    IntensitySweep(:,6) = [];
    
    if size(IntensitySweep,2) == 7
        fprintf('%s\n','Dual system with reference intensity detected. Splitting matrix.')
        Iref = IntensitySweep(:,7);
        IntensitySweep(:,7) = [];
        
        I0 = 170*ones(size(IntensitySweep,1),1); % COMMENT ME TO CHECK NEW CODE
    end
end

% selInf = isinf(I0);
% I0(selInf) = [];
% IntensitySweep(selInf,:) = [];
% % 
selCol = (abs(IntensitySweep(:,5) - 525e-9) < 100e-9); %624,525,457

Iref = Iref(selCol);
I0 = I0(selCol);
IntensitySweep = IntensitySweep(selCol,:);


%% Use the equations from Chun Ye but use all the data to fit.
x0 = [+10 0]; % 0.4178
[x, fitFcn, costFcn] = globalSearchRoutineMFA_TF_QuarterWaveplate(IntensitySweep,I0, x0, ctrl);
disp(x)



%% Plotting of fit.
% Fit raw analyzer position versus intensity, data + fit
if length(unique(IntensitySweep(:,3))) ~= 1 && length(unique(IntensitySweep(:,4))) == 1% Polarizer is moving
    xAxisIntensitySweep = IntensitySweep(:,3);
elseif length(unique(IntensitySweep(:,3))) == 1 && length(unique(IntensitySweep(:,4))) ~= 1% Analyzer is moving
    xAxisIntensitySweep = IntensitySweep(:,4);
else
    error('Inconsistent data format. Stopping.')
end

% x = 15;
% predictedIntensity(:) = fitFcn(x,IntensitySweep(:,3),IntensitySweep(:,4),IntensitySweep(:,5),I0,IntensitySweep(:,5)./(4*0.05*1e-6*2*pi));
predictedIntensity(:) = fitFcn(x,IntensitySweep(:,3),IntensitySweep(:,4),IntensitySweep(:,5),I0,pi/2);

predictedIntensityReal(:) = fitFcn([rad2deg(IntensitySweep(1,1)),0],IntensitySweep(:,3),IntensitySweep(:,4),IntensitySweep(:,5),I0,pi/2);
% predictedIntensity(:) = fitFcn(x,IntensitySweep(:,3),IntensitySweep(:,4),IntensitySweep(:,5),I0);

%% Plot  fit for each wavelength
uniqueWavelengths = unique(IntensitySweep(:,5));
figure('color','w','units','centimeters','OuterPosition',[10 10 16*2 16]);
subplot(1,2,1)
for cLoop = 1:length(uniqueWavelengths)
    selIdx = IntensitySweep(:,5) == uniqueWavelengths(cLoop);
    plot(rad2deg(xAxisIntensitySweep(selIdx)), IntensitySweep(selIdx,6),'b','marker',ctrl.markerChain{cLoop},'markerfacecolor','b')
    hold on
    plot(rad2deg(xAxisIntensitySweep(selIdx)), predictedIntensity(selIdx),'r','marker',ctrl.markerChain{cLoop},'markersize',3,'markerfacecolor','r')    
    plot(rad2deg(xAxisIntensitySweep(selIdx)), predictedIntensityReal(selIdx),'m','marker',ctrl.markerChain{cLoop},'markersize',3,'markerfacecolor','m')  
end
xlim([-40 400])
ylim([-0 1.5.*max(IntensitySweep(:,6))])
xlabel('Analyzer position [deg]','interpreter',ctrl.interpreter)
ylabel('Intensity [a.u.]','interpreter',ctrl.interpreter)
set(gca,'TickLabelInterpreter',ctrl.interpreter,'YMinorGrid',1,'XMinorTick',1)

%% Use costFcn to calculate a rough goodness-of-fit for a given (MFA,tf) combination
% Sweep over solution space to draw error contours
mfaToTry = -50:0.25:50;
wallToTry = pi/2;% 0:0.2:10; % Not important, only here to preserve code structure
subplot(1,2,2)
[X, Y, Z] = globalSweep(mfaToTry,wallToTry,costFcn);
plot(X,Z,'linewidth',1.5);
hold on
plot(rad2deg(IntensitySweep(1,1)),0,'c^','markerfacecolor','c',lineInstructions{:})
plot(x(1),0,'dm','markerfacecolor','m',lineInstructions{:})
legend('Error contours','True values','GlobalSearch est.','location','best','interpreter',ctrl.interpreter)
title(strrep(resultToImport,'_',' '),'interpreter',ctrl.interpreter)
xlabel('Plate orientation [deg]','interpreter',ctrl.interpreter)
ylabel('Cost Fcn','interpreter',ctrl.interpreter)
set(gca,'TickLabelInterpreter',ctrl.interpreter)






