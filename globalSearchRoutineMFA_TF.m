function [x, fitFcn, costFcn] = globalSearchRoutineMFA_TF(IntensitySweep, I0, x0)
%function globalSearchRoutineMFA_TF minimizes the error between observed and expected output intensity,
%with the goal of finding the MFA and the wall thickness of the fiber.
%
% INPUTS:
%       NAME                        TYPE                    SIZE
%       IntensitySweep              {Numeric matrix}        [n x 6], n = number of measurements
%           Collection of results
%           Columns:
%           [:,1]           True MFA, if known (only the case when exporting from comsol). Otherwise nan.
%           [:,2]           True tf, if known (only the case when exporting from comsol). Otherwise nan.
%           [:,3]           Polarizer position in radians
%           [:,4]           Analyzer position in radians
%           [:,5]           Wavelength of the light used in the experiment, in SI units.
%           [:,6]           Output intensities measured during the experiment
%
%       I0                          {Numeric matrix}        [n x 1] or [1 x n] or [1 x 1], n = number of measurements
%           Ray intensity exiting the polarizer. If scalar is supplied, function expands it to a vector.
%           Typically given in W/m^2 (Joule per second per square meter).
%
%       x0                          {Numeric matrix}        [1 x 2] or [2 x 1]
%           Starting guess
%           Columns:
%           [1]             Micro-fibril angle, in degrees.
%           [2]             Wall thickness, in um (10^-6 * m)  
%
%
% OUTPUTS:
%       NAME                        TYPE                    SIZE
%       x                           {Numeric matrix}        [2 x 1]
%           Optimal solution
%           Columns:
%           [1]             Micro-fibril angle, in degrees.
%           [2]             Wall thickness, in um (10^-6 * m)  
%
%       fitFcn                      {Anon. function}        n/a
%           Function reference for the fitting. For example if you want to use the "fitFunctionYeColor.m"
%           function as a model of your system, then fitFcn will return an anaonymous handle which allows 
%           you to call this function elsewhere.
%
%       costFcn                     {Anon. function}        n/a
%           Cost function reference for the fitting. This is the usually some variation on error minimization,
%           and can be used e.g. to plot the residual error for various combinations, or for use in further
%           optimization calls.
%
% REFERENCES:
%
%
% ABOUT:
%       The globalSearch algorithm requires the optimization toolbox. If this toolbox is not installed, the
%       function degrades to standard fminunc, which has worse performance. Consider calling the function several
%       times with different starting guesses if you do not have the optimization toolbox.
%
%
% Created by: August Brandberg augustbr at kth dot se
% Date: 2020-12-09

fitFcn  = @(x, polarizerPosition, analyzerPosition, wavelength, I0) fitFunctionYeColor(x, polarizerPosition, analyzerPosition, wavelength,I0);
costFcn = @(x) sqrt(1/size(IntensitySweep,1)*sum((fitFcn(x,IntensitySweep(:,3),IntensitySweep(:,4),IntensitySweep(:,5),I0) -  IntensitySweep(:,6)).^2));



% Use Chun Ye et al. model with restarting (less dependent on x0 guess)
if license('test', 'Optimization_Toolbox')
    gs = GlobalSearch;
    problem = createOptimProblem('fmincon','x0',x0,'objective',costFcn,'lb',[-40,1],'ub',[40,8]);
    x = run(gs,problem);
else
    fprintf('%s\n','Global Search Optimization toolbox not found. Using xSingleStart');
    fprintf('%s\n','Exercise caution if this if this warning has been triggered. Possibly unstable solution.');
    xSingleStart = fminunc(costFcn,x0);
    x = xSingleStart;
end