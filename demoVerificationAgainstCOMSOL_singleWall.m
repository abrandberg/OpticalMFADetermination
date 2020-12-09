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

ctrl.opticalModel = 'singleWall'; 
% Choice of system:
% 'fiber'       -> Polarizer - Fiber wall - Fiber wall - Analyzer 
%                 (uses fitFunctionYeColor.m)
% 'singleWall'  -> Polarizer - Fiber wall - Analyzer
%                 (uses fitFunctionYeColorSingleWall.m)

%% Precomputed response from COMSOL model. Uncomment one.
resultDir = 'precomputedData';
resultToImport = 'precomputed_MFA=-12_WALL=2_Amoving_SingleWall.mat';
% resultToImport = 'precomputed_MFA=-12_WALL=2_Pmoving_SingleWall.mat';             
% resultToImport = 'precomputed_MFA=-12_WALL=2_Pmoving_0.4Pol_SingleWall.mat';        % 40% polarized light
load([resultDir filesep resultToImport])


if size(IntensitySweep,2) == 4 
    fprintf('%s\n','Legacy save format. Polarizer position fixed.');
    IntensitySweep(:,3) = [];
    sizeOfArray = size(IntensitySweep);
    IntensitySweep = [[deg2rad(inputs.mfa) inputs.wallTkn inputs.PolarizerOrientation].*ones(sizeOfArray(1),1) IntensitySweep];
else
    fprintf('%s\n','Latest format.');
    fprintf('%s\n','Columns of IntensitySweep:');
    fprintf('%20s %10s %10s %10s %10s %10s %10s %10s\n','',legendIntensitySweep{:});
    IntensitySweep(:,6) = [];
end

% Deselect all but three wavelengths
% BLUE = 450 nm
% RED = 650 nm
% GREEN = 500 nm
lambdaSel = ismembertol(IntensitySweep(:,5),[450 500 650].*1e-9,10e-9);
IntensitySweep = IntensitySweep(lambdaSel,:);


%% Demo of Chun Ye et al. method. See function "chunYe" for input/output documentation
% Use Chun Ye et al. minimum viable model (Equation 9 to 11 in [1])

if strcmp(ctrl.opticalModel,'fiber')
    if length(unique(IntensitySweep(:,3))) ~= 1 && length(unique(IntensitySweep(:,4))) == 1      % Polarizer is moving
        [chunYeSet1,chunYeSet2] = chunYe(IntensitySweep(:,[3 5 6]),'P');
    elseif length(unique(IntensitySweep(:,3))) == 1 && length(unique(IntensitySweep(:,4))) ~= 1  % Analyzer is moving
        [chunYeSet1,chunYeSet2] = chunYe(IntensitySweep(:,[4 5 6]),'A');
    else
        error('Inconsistent data format. Stopping.')
    end
else
    disp('Skipping Chun Ye method.')
    chunYeSet1 = nan(1,2);
    chunYeSet2 = nan(1,2);
end

%% Use the equations from Chun Ye but use all the data to fit.
I0 = 1000*0.5;
x0 = [4 2]; 
% Starting guess (MFA = 4 deg, tf = 2 um)
[x, fitFcn, costFcn] = globalSearchRoutineMFA_TF(IntensitySweep,I0, x0, ctrl);
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
predictedIntensity(:) = fitFcn(x,IntensitySweep(:,3),IntensitySweep(:,4),IntensitySweep(:,5),I0);


%% Plot  fit for each wavelength
uniqueWavelengths = unique(IntensitySweep(:,5));
figure('color','w','units','centimeters','OuterPosition',[10 10 16 16]);
for cLoop = 1:length(uniqueWavelengths)
    selIdx = IntensitySweep(:,5) == uniqueWavelengths(cLoop);
    plot(rad2deg(xAxisIntensitySweep(selIdx)), IntensitySweep(selIdx,6),'b','marker',ctrl.markerChain{cLoop},'markerfacecolor','b')
    hold on
    plot(rad2deg(xAxisIntensitySweep(selIdx)), predictedIntensity(selIdx),'r','marker',ctrl.markerChain{cLoop},'markersize',3,'markerfacecolor','r')    
end
xlim([-40 400])
ylim([0.75.*min(IntensitySweep(:,6)) 1.25.*max(IntensitySweep(:,6))])
text(0,min(550,1.15.*max(IntensitySweep(:,6))),strrep(resultToImport,'_',' '),'interpreter',ctrl.interpreter,'HorizontalAlignment','left','FontSize',12);
xlabel('Analyzer position [deg]','interpreter',ctrl.interpreter)
ylabel('Intensity [a.u.]','interpreter',ctrl.interpreter)
legend('Raw data','Fitted model','location','best','interpreter',ctrl.interpreter)
set(gca,'TickLabelInterpreter',ctrl.interpreter,'YMinorGrid',1,'XMinorTick',1)
print(['plots' filesep 'fitQuality'],'-dpng')


%% Use costFcn to calculate a rough goodness-of-fit for a given (MFA,tf) combination
% Sweep over solution space to draw error contours
mfaToTry = -40:0.5:40;
wallToTry = 0.5:0.25:8;
[X, Y, Z] = globalSweep(mfaToTry,wallToTry,costFcn);

figure('color','w','units','centimeters','OuterPosition',[10 10 16 16]);
contourf(X,Y,Z);
hold on
plot(rad2deg(IntensitySweep(1,1)),IntensitySweep(1,2)*1e6,'c^','markerfacecolor','c',lineInstructions{:})
plot(x(1),x(2),'dm','markerfacecolor','m',lineInstructions{:})
plot(chunYeSet1(:,1),chunYeSet1(:,2),'sr','markerfacecolor','r',lineInstructions{:})
plot(chunYeSet2(:,1),chunYeSet2(:,2),'or','markerfacecolor','r',lineInstructions{:})
title(strrep(resultToImport,'_',' '),'interpreter',ctrl.interpreter)
legend('Error contours','True values','GlobalSearch est.','Chun Ye et al., (1)','Chun Ye et al., (2)','interpreter',ctrl.interpreter)
xlabel('$MFA$ [deg]','interpreter',ctrl.interpreter)
ylabel('$t_f$ [$\mu$m]','interpreter',ctrl.interpreter)
set(gca,'TickLabelInterpreter',ctrl.interpreter)
print(['plots' filesep 'errorContourf'],'-dpng')



