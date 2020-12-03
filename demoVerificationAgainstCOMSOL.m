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

ctrl.interpreter = 'latex';
ctrl.markerChain = {'<','>','^','o','s','d'};
lineInstructions = {'markersize',8};

resultDir = 'precomputedData';
% Import pre-computed data (uncomment one)
% resultToImport = 'precomputed_MFA=8_WALL=3_YE.mat';
% resultToImport = 'precomputed_MFA=14_WALL=3_YE.mat';
% resultToImport = 'precomputed_MFA=14_WALL=1_YE.mat';

% resultToImport = 'precomputed_MFA=17_WALL=4.mat';
% resultToImport = 'precomputed_MFA=17_WALL=4_Pmoving.mat';

% resultToImport = 'precomputed_MFA=17_WALL=4_Pmoving_0.1Pol.mat';
% resultToImport = 'precomputed_MFA=17_WALL=4_Pmoving_0.2Pol.mat';
% resultToImport = 'precomputed_MFA=17_WALL=4_Pmoving_0.4Pol.mat';
% resultToImport = 'precomputed_MFA=17_WALL=4_Pmoving_0.6Pol.mat';
resultToImport = 'precomputed_MFA=17_WALL=4_Amoving_0.4Pol.mat';
load(['precomputedData' filesep resultToImport])


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




% selIdx = ismembertol(IntensitySweep(:,4),[0 pi/4 2*pi/4 3*pi/4],1e-3);

% IntensitySweep = IntensitySweep(selIdx,:);
% Use Chun Ye et al. minimum viable model (Equation 9 to 11 in [1])
if length(unique(IntensitySweep(:,3))) ~= 1 & length(unique(IntensitySweep(:,4))) == 1% Polarizer is moving
    [chunYeSet1,chunYeSet2] = chunYe(IntensitySweep(:,[3 5 6]),'P');
elseif length(unique(IntensitySweep(:,3))) == 1 & length(unique(IntensitySweep(:,4))) ~= 1% Analyzer is moving
    [chunYeSet1,chunYeSet2] = chunYe(IntensitySweep(:,[4 5 6]),'A');
else
    disp('Inconsistent data format. Stopping.')
end



% Use Chun Ye et al. model with over-sampling
fitFcn  = @(x, A,wavelength,P) fitFunctionYeColor(x,A,wavelength,P);
costFcn = @(x) sqrt(1/size(IntensitySweep,1)*sum((fitFcn(x,IntensitySweep(:,4),IntensitySweep(:,5),IntensitySweep(:,3)) - IntensitySweep(:,6)').^2));
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
if length(unique(IntensitySweep(:,3))) ~= 1 & length(unique(IntensitySweep(:,4))) == 1% Polarizer is moving
    xAxisIntensitySweep = IntensitySweep(:,3);
elseif length(unique(IntensitySweep(:,3))) == 1 & length(unique(IntensitySweep(:,4))) ~= 1% Analyzer is moving
    xAxisIntensitySweep = IntensitySweep(:,4);
else
    disp('Inconsistent data format. Stopping.')
end


predictedIntensity = nan(size(IntensitySweep,1),1);
for bLoop = 1:size(IntensitySweep,1)
    predictedIntensity(bLoop) = fitFcn(x,IntensitySweep(bLoop,4),IntensitySweep(bLoop,5),IntensitySweep(bLoop,3));
end

uniqueWavelengths = unique(IntensitySweep(:,5));

figure('color','w','units','centimeters','OuterPosition',[10 10 16 16]);
for cLoop = 1:length(uniqueWavelengths)
    selIdx = IntensitySweep(:,5) == uniqueWavelengths(cLoop);
    plot(rad2deg(xAxisIntensitySweep(selIdx)), IntensitySweep(selIdx,6),'b','marker',ctrl.markerChain{cLoop},'markerfacecolor','b')
    hold on
    plot(rad2deg(xAxisIntensitySweep(selIdx)), predictedIntensity(selIdx),'r','marker',ctrl.markerChain{cLoop},'markersize',3,'markerfacecolor','r')    
end
xlim([-40 400])
ylim(1.25.*[min(IntensitySweep(:,6)) max(IntensitySweep(:,6))])
text(0,550,strrep(resultToImport,'_',' '),'interpreter',ctrl.interpreter,'HorizontalAlignment','left','FontSize',12);
xlabel('Analyzer position [deg]','interpreter',ctrl.interpreter)
ylabel('Intensity [a.u.]','interpreter',ctrl.interpreter)
legend('Raw data','Fitted model','location','best','interpreter',ctrl.interpreter)
set(gca,'TickLabelInterpreter',ctrl.interpreter,'YMinorGrid',1,'XMinorTick',1)
print(['plots' filesep 'fitQuality'],'-dpng')

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
contourf(X,Y,Z);%,round(linspace(0.2,max(max(Z)),20),2)) 
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



