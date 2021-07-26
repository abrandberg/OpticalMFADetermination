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

% Various input options. In general, do not touch.
clear; close all; clc
format compact
reportFormat = '%20s %10.1f          %10.1f %10.1f\n';

ctrl.interpreter = 'latex';
ctrl.markerChain = {'<','>','^','o','s','d'};
lineInstructions = {'markersize',8};
ctrl.fontsize = 12;

ctrl.opticalModel = 'QuarterWaveplate'; %2xQuarterWaveplate
% Choice of system:
% 'fiber'       -> Polarizer - Fiber wall - Fiber wall - Analyzer 
%                 (uses fitFunctionYeColor.m)
% 'singleWall'  -> Polarizer - Fiber wall - Analyzer
%                 (uses fitFunctionYeColorSingleWall.m)
% 'QuarterWaveplate' -> Same as singleWall, but with known retardance

% Precomputed response from COMSOL model. Uncomment one.
resultDir = 'precomputedData';


resultToImport = 'precomputed_MFA=15_Pmoving_QuarterWaveplate_REF=YES.mat';
% resultToImport = 'precomputed_MFA=15_Pmoving_0.4Pol_QuarterWaveplate_REF=YES.mat';
load([resultDir filesep resultToImport])
% load('precomputed_MFA=15QWave4.25Ret.mat')
load('precomputed_MFA=15QWave90Ret.mat')

pathToExperiment{1} = 'C:\Users\augus\Downloads\OneDrive_2021-01-21\polarization verification_consolidatedData\Exp_Results_1WP -15.mat'; % Low sensitivity, moderate accuracy
pathToExperiment{2} = 'C:\Users\augus\Downloads\OneDrive_2021-01-21\polarization verification_consolidatedData\Exp_Results_1WP +15.mat'; % Low sensitivity, moderate accuracy
pathToExperiment{3} = 'C:\Users\augus\Downloads\OneDrive_2021-01-21\polarization verification_consolidatedData\Exp_Results_1WP 10.mat'; % Perfect fit, wrong answer
pathToExperiment{4} = 'C:\Users\augus\Downloads\OneDrive_2021-01-21\polarization verification_consolidatedData\Exp_Results_1WP 16.mat'; % Low sensitivity, moderate accuracy
pathToExperiment{5} = 'C:\Users\augus\Downloads\OneDrive_2021-01-21\polarization verification_consolidatedData\Exp_Results_1WP 30.mat'; %
pathToExperiment{6} = 'C:\Users\augus\Downloads\OneDrive_2021-01-21\polarization verification_consolidatedData\Exp_Results_2WP 10.mat'; %
pathToExperiment{7} = 'C:\Users\augus\Downloads\OneDrive_2021-01-21\polarization verification_consolidatedData\Exp_Results_2WP 16.mat'; %

preString = 'C:\Users\augus\Downloads\OneDrive_2021-02-04\polarization verification_consolidatedData\';
pathToExperiment{8} = [preString 'Exp_Results_Ex4 half inch WP 0.mat'];
pathToExperiment{9} = [preString 'Exp_Results_Ex4 one inch WP 0.mat'];
% pathToExperiment{10} = [preString 'Exp_Results_Ex4 half inch WP 0.mat'];
% pathToExperiment{11} = [preString 'Exp_Results_Ex4 half inch WP 0.mat'];
% pathToExperiment{12} = [preString 'Exp_Results_Ex4 half inch WP 0.mat'];
% 

preString = 'C:\Users\augus\Downloads\OneDrive_2021-02-19\polarization verification_consolidatedData\'
% clear pathToExperiment

pathToExperiment{10} = [preString 'Exp_Results_Ex5 1WP 10.mat'];
pathToExperiment{11} = [preString 'Exp_Results_Ex5 1WP 16.mat'];
pathToExperiment{12} = [preString 'Exp_Results_Ex5 1WP 30.mat'];
pathToExperiment{13} = [preString 'Exp_Results_Ex5 2WP 10.mat'];
pathToExperiment{14} = [preString 'Exp_Results_Ex5 2WP 16.mat'];
pathToExperiment{15} = [preString 'Exp_Results_Ex5 2WP 30.mat'];


% clear pathToExperiment
% load('6deg_2xWaveplate.mat')
% % load('6deg_2xWaveplate_20degrot.mat')
% % load('6deg_2xWaveplate_45degrot.mat')
% % New measurements


counter = 1;
for hLoop = 1:numel(pathToExperiment)

    [IntensitySweep,legendIntensitySweep] = importTampereExperiments(pathToExperiment{hLoop});

    if hLoop < 10
        IntensitySweep(:,3) = IntensitySweep(:,3) + deg2rad(50)+ deg2rad(1);
        IntensitySweep(:,4) = IntensitySweep(:,4) + deg2rad(50)+ deg2rad(1);
        configLoc = 101;
    else
        IntensitySweep(:,3) = IntensitySweep(:,3);
        IntensitySweep(:,4) = -IntensitySweep(:,4);
        configLoc = 105;
    end


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
            I0 = (max(IntensitySweep(:,6))+min(IntensitySweep(:,6))) *ones(size(IntensitySweep,1),1);
        end
    end

    selCol = (abs(IntensitySweep(:,5) - 525e-9) < 100e-9); %624,525,457

    Iref = Iref(selCol);
    I0 = I0(selCol);
    IntensitySweep = IntensitySweep(selCol,:);
    IntensitySweepSave = IntensitySweep;

    wavelengthsToUse = unique(IntensitySweepSave(:,5));

    for gLoop = 1:length(wavelengthsToUse)

        IntensitySweep = IntensitySweepSave;
        selCol = (abs(IntensitySweep(:,5) - wavelengthsToUse(gLoop)) < 1e-9);
        IntensitySweep = IntensitySweep(selCol,:);

    % Use the equations from Chun Ye but use all the data to fit.

    if pathToExperiment{hLoop}(configLoc) == '1'
        ctrl.opticalModel = 'QuarterWaveplate';
    elseif pathToExperiment{hLoop}(configLoc) == '2'
        ctrl.opticalModel = '2xQuarterWaveplate';
        [outputSet1, outputSet2] = chunYe(IntensitySweepSave(:,[3 5 6]),'P');
    else
        ctrl.opticalModel = 'QuarterWaveplate';
    end

    x0 = [+10 0];
    [x, fitFcn, costFcn] = globalSearchRoutineMFA_TF_QuarterWaveplate(IntensitySweep,I0, x0, ctrl);
    disp(x)



    % Plotting of fit.
    % Fit raw analyzer position versus intensity, data + fit
    if length(unique(IntensitySweep(:,3))) ~= 1 && length(unique(IntensitySweep(:,4))) == 1% Polarizer is moving
        xAxisIntensitySweep = IntensitySweep(:,3);
    elseif length(unique(IntensitySweep(:,3))) == 1 && length(unique(IntensitySweep(:,4))) ~= 1% Analyzer is moving
        xAxisIntensitySweep = IntensitySweep(:,4);
    else
        error('Inconsistent data format. Stopping.')
    end

    predictedIntensity(:) = fitFcn(x,IntensitySweep(:,3),IntensitySweep(:,4),IntensitySweep(:,5),I0,pi/2);

    % Plot  fit for each wavelength
    uniqueWavelengths = unique(IntensitySweep(:,5));
    figure('color','w','units','centimeters','OuterPosition',[10 10 16 16]);


    % Use costFcn to calculate a rough goodness-of-fit for a given (MFA,tf) combination
    % Sweep over solution space to draw error contours
    mfaToTry = -80:0.25:80;
    wallToTry = pi/2;   % Not important, only here to preserve code structure % pi/2;% 
    [X, Y, Z] = globalSweep(mfaToTry,wallToTry,costFcn);
    plot(X,Z,'linewidth',1.5);
    hold on
    plot(rad2deg(IntensitySweep(1,1)),0,'c^','markerfacecolor','c',lineInstructions{:})
    plot(x(1),0,'dm','markerfacecolor','m',lineInstructions{:})
    legend('Error contours','True values','GlobalSearch est.','location','best','interpreter',ctrl.interpreter)
    xlabel('Plate orientation [deg]','interpreter',ctrl.interpreter)
    ylabel('Cost Fcn','interpreter',ctrl.interpreter)
    set(gca,'TickLabelInterpreter',ctrl.interpreter)

    residVal(counter,1) = min(IntensitySweep(:,6));
    residVal(counter,2) = costFcn(x);
    residVal(counter,3) = min(Iref);
    residVal(counter,4) = max(Iref);

    saveArray(counter,1) = rad2deg(IntensitySweep(1,1));
    saveArray(counter,2) = x(1);
    saveArray(counter,3) = str2double(pathToExperiment{hLoop}(configLoc)); %(101)

    if pathToExperiment{hLoop}(configLoc) == '1'
        saveArray(counter,4) = nan;
        saveArray(counter,5) = nan;
    else
        saveArray(counter,4) = mean(outputSet1(:,1));
        saveArray(counter,5) = mean(outputSet2(:,1));
    end
    counter = counter + 1;

    end
end


saveArray(22:27,1) = 0;
saveArray(22:27,3) = 1;

selSingle = saveArray(:,3) == 1;
selDouble = saveArray(:,3) == 2;

figure('color','w','units','centimeters','OuterPosition',[10 10 16 16]);
tlt2 = tiledlayout(2, 2,'Padding','none');
nexttile;
plot(saveArray(selSingle,1),saveArray(selSingle,2),'ob','linewidth',1.0,lineInstructions{:},'DisplayName','Data 1x WP')
hold on
plot(40.*[-1 1],40.*[-1 1],'k-.','linewidth',1.5,'DisplayName','Equality')
xlim([-40 40])
ylim([-40 40])
xlabel('Supplied Answer [deg]','interpreter',ctrl.interpreter)
ylabel('Calculated Answer [deg]','interpreter',ctrl.interpreter)
legend('location','northwest','interpreter',ctrl.interpreter)
set(gca,'TickLabelInterpreter',ctrl.interpreter,'fontsize',ctrl.fontsize)


nexttile;
hold on
plot(saveArray(selDouble,1),saveArray(selDouble,2),'or','linewidth',1.0,lineInstructions{:},'DisplayName','Data 2x WP')
plot(40.*[-1 1],40.*[-1 1],'k-.','linewidth',1.5,'DisplayName','Equality')
xlim([-40 40])
ylim([-40 40])
xlabel('Supplied Answer [deg]','interpreter',ctrl.interpreter)
ylabel('Calculated Answer [deg]','interpreter',ctrl.interpreter)
legend('location','northwest','interpreter',ctrl.interpreter)
set(gca,'TickLabelInterpreter',ctrl.interpreter,'fontsize',ctrl.fontsize)


nexttile;
hold on
plot(saveArray(selDouble,1),saveArray(selDouble,4),'dm','linewidth',1.0,lineInstructions{:},'DisplayName','Chun Ye 1')
plot(40.*[-1 1],40.*[-1 1],'k-.','linewidth',1.5,'DisplayName','Equality')
xlim([-40 40])
ylim([-40 40])

xlabel('Supplied Answer [deg]','interpreter',ctrl.interpreter)
ylabel('Calculated Answer [deg]','interpreter',ctrl.interpreter)
legend('location','northwest','interpreter',ctrl.interpreter,'box',false)
set(gca,'TickLabelInterpreter',ctrl.interpreter,'fontsize',ctrl.fontsize)

print(['plots' filesep 'tempValid_1'],'-dpng')

