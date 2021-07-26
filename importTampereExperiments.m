function [IntensitySweep,legendIntensitySweep] = importTampereExperiments(pathToExperiment)

disp(pathToExperiment)

load(pathToExperiment)

% Fill out the intensity sweep function


sizeOfArray = size(Exp_data,1);

IntensitySweep = nan(sizeOfArray*3,7);
% 624 nm - red
% 525 nm - green
% 457 nm - blue

IntensitySweep(:,1) = +deg2rad(str2double(pathToExperiment(end-6:end-4)));%-deg2rad(51)+deg2rad(str2double(pathToExperiment(end-6:end-4)));
IntensitySweep(:,2) = nan;
IntensitySweep(:,3) = deg2rad(0)+deg2rad(180)+deg2rad([Exp_data{:,1} ; Exp_data{:,1} ; Exp_data{:,1}]);                  % pAngle
IntensitySweep(:,4) = deg2rad(-45);   %deg2rad(-45);                                                              % aAngle
IntensitySweep(:,5) = 1e-9.*[624*ones(sizeOfArray,1) ; 525*ones(sizeOfArray,1) ; 457*ones(sizeOfArray,1)];        % wavelength
IntensitySweep(:,6) = nan;                                                              % time
IntensitySweep(:,7) = [Exp_data{:,7} ; Exp_data{:,6} ; Exp_data{:,5} ];                 % Intensity
IntensitySweep(:,8) = [Exp_data{:,4} ; Exp_data{:,3} ; Exp_data{:,2} ];                 % Ref. intensity
                                        
                                        
legendIntensitySweep = {'mfa','wallTkn','pAngle','aAngle','wavelength','time','Intensity','Ref intensity'};