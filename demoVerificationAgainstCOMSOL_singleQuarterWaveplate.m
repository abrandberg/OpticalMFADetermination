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

ctrl.opticalModel = 'QuarterWaveplate'; 
% Choice of system:
% 'fiber'       -> Polarizer - Fiber wall - Fiber wall - Analyzer 
%                 (uses fitFunctionYeColor.m)
% 'singleWall'  -> Polarizer - Fiber wall - Analyzer
%                 (uses fitFunctionYeColorSingleWall.m)
% 'QuarterWaveplate' -> Same as singleWall, but with known retardance

%% Precomputed response from COMSOL model. Uncomment one.
resultDir = 'precomputedData';


resultToImport = 'precomputed_MFA=15_Pmoving_QuarterWaveplate_REF=YES.mat'
resultToImport = 'precomputed_MFA=15_Pmoving_0.4Pol_QuarterWaveplate_REF=YES.mat'



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
    
    if size(IntensitySweep,2) == 7
        fprintf('%s\n','Dual system with reference intensity detected. Splitting matrix.')
        Iref = IntensitySweep(:,7);
        IntensitySweep(:,7) = [];
        
        I0 = compensateIntensityVariation(IntensitySweep(:,3), IntensitySweep(:,4), Iref);
%         I0 = 1000*0.5*ones(size(IntensitySweep,1),1); % COMMENT ME TO CHECK NEW CODE
    end
end






%% Use the equations from Chun Ye but use all the data to fit.
x0 = [4]; 
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
predictedIntensity(:) = fitFcn(x,IntensitySweep(:,3),IntensitySweep(:,4),IntensitySweep(:,5),I0,IntensitySweep(:,5)./(4*0.05*1e-6*2*pi));


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
wallToTry = 0; % Not important, only here to preserve code structure
figure('color','w','units','centimeters','OuterPosition',[10 10 16 16]);
[X, ~, Z] = globalSweep(mfaToTry,wallToTry,costFcn);
plot(X,Z,'linewidth',1.5);
hold on
plot(rad2deg(IntensitySweep(1,1)),0,'c^','markerfacecolor','c',lineInstructions{:})
plot(x(1),0,'dm','markerfacecolor','m',lineInstructions{:})
legend('Error contours','True values','GlobalSearch est.','interpreter',ctrl.interpreter)
title(strrep(resultToImport,'_',' '),'interpreter',ctrl.interpreter)
xlabel('Plate orientation [deg]','interpreter',ctrl.interpreter)
ylabel('Cost Fcn','interpreter',ctrl.interpreter)
set(gca,'TickLabelInterpreter',ctrl.interpreter)






