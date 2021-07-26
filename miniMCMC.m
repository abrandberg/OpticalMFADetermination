clear all; close all; clc
format compact

ctrl.interpreter = 'latex';
ctrl.markerChain = {'<','>','^','o','s','d','+'};
lineInstructions = {'markersize',8};

ctrl.opticalModel = 'fiber';%'singleWall';%'fiber';
% Mini-MCMC generator to look at uncertainty


% COU = Coefficient of uncertainty
%
% COU = 1*std / (mean) for the property
cou.analyzerAngle = 0;
cou.polarizerAngle = 0;

cou.wallTkn1 = 0;
cou.wallTkn2 = 0.25;

cou.mfa1 = 0;
cou.mfa2 = 0.5;

cou.retardanceS1 = 0.02;
cou.retardanceS2 = 0.02;
cou.retardanceS3 = 0.02;

cou.wallS1 = 0.5;
cou.wallS3 = 0.5;

cou.wavelength = 0;

% Definition of params




params.S1Angle1 = 90;
params.S2Angle1 = 12;
params.S3Angle1 = 90;

params.S1Angle2 = -90;
params.S2Angle2 = -12;
params.S3Angle2 = -90;

params.S1Tkn1 = 0.0;
params.S2Tkn1 = 4.0;
params.S3Tkn1 = 0.0;

params.S1Tkn2 = 0.0;
params.S2Tkn2 = 4.0;
params.S3Tkn2 = 0.0;

params.Ret_S1 = 0.05; 
params.Ret_S2 = 0.05;
params.Ret_S3 = 0.05;

numSteps = 12;

wavelengthsToUse = linspace(400,700,3);%400:50:700;
wavelength = [];
analyzerPosition = [];
for tLoop = 1:numel(wavelengthsToUse)
    wavelength = [wavelength ; 1e-9*wavelengthsToUse(tLoop)*ones(numSteps,1)];
    analyzerPosition = [analyzerPosition linspace(0,2*pi,numSteps)];
end

% analyzerPosition = [linspace(0,2*pi-eps,numSteps)  linspace(0,2*pi-eps,numSteps)  linspace(0,2*pi-eps,numSteps)  linspace(0,2*pi-eps,numSteps) linspace(0,2*pi-eps,numSteps)  linspace(0,2*pi-eps,numSteps)];
polarizerPosition = 45*pi/180*ones(length(analyzerPosition),1);
% wavelength = [450e-9*ones(numSteps,1) ; 500e-9*ones(numSteps,1) ; 550e-9*ones(numSteps,1) ; 600e-9*ones(numSteps,1) ; 650e-9*ones(numSteps,1) ; 700e-9*ones(numSteps,1)];
I0 = 500;



for zLoop = 1:100

    params.S1Angle1 = 90;
    params.S2Angle1 = 12+4*(randn(1)-0.5);
    params.S3Angle1 = 90;

    params.S1Angle2 = -90;
    params.S2Angle2 = -12+4*(randn(1)-0.5);
    params.S3Angle2 = -90;

    params.S1Tkn1 = 0.0+0.0*rand(1);
    params.S2Tkn1 = 4.0-0;
    params.S3Tkn1 = 0.0+0.0*rand(1);

    params.S1Tkn2 = 0.0+0.0*rand(1);
    params.S2Tkn2 = 4.0+0;
    params.S3Tkn2 = 0.0+0.0*rand(1);

    params.Ret_S1 = 0.05; 
    params.Ret_S2 = 0.05;
    params.Ret_S3 = 0.05;

    if zLoop == 1
        params.S2Angle1 = 12;
        params.S2Angle2 = -12;
        params.S1Tkn1 = 0.0;
        params.S2Tkn1 = 4.0;
        params.S3Tkn1 = 0.0;

        params.S1Tkn2 = 0.0;
        params.S2Tkn2 = 4.0;
        params.S3Tkn2 = 0.0;
    end

    


% Step 1: Generate the forward intensity measurements
% Step 2: Back-fit the result
% Step 3: Wrap and loop
% Step 4: Present results
Intensity = fitFunctionYeColorSingleWall_mcmcVersion(params, polarizerPosition, analyzerPosition, wavelength,I0,ctrl);

IntensitySweep = nan(length(analyzerPosition),6);

IntensitySweep(:,1) = deg2rad(params.S2Angle1);
IntensitySweep(:,2) = params.S2Tkn1;
IntensitySweep(:,3) = polarizerPosition;
IntensitySweep(:,4) = analyzerPosition;
IntensitySweep(:,5) = wavelength;
IntensitySweep(:,6) = Intensity;

x0 = [4 2];

[x, fitFcn, costFcn] = globalSearchRoutineMFA_TF(IntensitySweep, I0, x0, ctrl);


fprintf('%20s %20s %20s %20s %20s %20s %20s\n','S2-Tkn1','S2-Tkn2','S1-Tkn1','S3-Tkn1','S1-Tkn2','S3-Tkn2','Delta MFA')
    fprintf('%20.2f %20.2f %20.2f %20.2f %20.2f %20.2f %20.2f\n',params.S2Tkn1,params.S2Tkn2,params.S1Tkn1,params.S3Tkn1,params.S1Tkn2,params.S3Tkn2,(x(1) - 12)./12)


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

%% Use costFcn to calculate a rough goodness-of-fit for a given (MFA,tf) combination
% Sweep over solution space to draw error contours
subplot(1,2,1)
mfaToTry = -40:0.5:40;
wallToTry = 0.5:0.25:12;
[X, Y, Z] = globalSweep(mfaToTry,wallToTry,costFcn);

if zLoop == 1
    contourf(X,Y,Z,20);
    hold on
    plot(x(1),x(2),'c^','markerfacecolor','c',lineInstructions{:})
end

hold on

plot(x(1),x(2),'dm','markerfacecolor','m',lineInstructions{:})


legend('Error contours','True values','GlobalSearch est.','interpreter',ctrl.interpreter)
if zLoop == 1

xlabel('$MFA$ [deg]','interpreter',ctrl.interpreter)
ylabel('$t_f$ [$\mu$m]','interpreter',ctrl.interpreter)
set(gca,'TickLabelInterpreter',ctrl.interpreter)

end

subplot(1,2,2)
plot(zLoop,(x(1) - 12)./12,'ob')
hold on


pause(0.25)
end

