function [X, Y, Z] = globalSweep(mfaToTry,wallToTry,costFcn)
%function globalSweep calculates the error for a given input combination and cost function.
%
% INPUTS:
%       NAME                        TYPE                    SIZE
%       mfaToTry                    {Numeric matrix}        [n x 1] or [1 x n], n = number of mfa's to try
%           Vector of MFA's to try.
%
%       wallToTry                   {Numeric matrix}        [m x 1] or [1 x m], m = number of wall thickness' to try
%           Vector of wall thickness' to try.
%
%       costFcn                     {Anon. function}        n/a
%           Cost function reference for the fitting. This is the usually some variation on error minimization,
%           and can be used e.g. to plot the residual error for various combinations, or for use in further
%           optimization calls.
%
%
% OUTPUTS:
%       NAME                        TYPE                    SIZE
%       X                           {Numeric matrix}        [n x m] (see def. above)
%           Grid coordinate for MFA.
%
%       Y                           {Numeric matrix}        [n x m] (see def. above)
%           Grid coordinate for wall thickness.
%       Z                           {Numeric matrix}        [n x m] (see def. above)
%           Cost as calculated by the cost function. Typically a residual.
%
% REFERENCES:
%
%
% ABOUT:
%       Visualize with
%       
%           figure;
%           contourf(X,Y,Z)
%
%
% Created by: August Brandberg augustbr at kth dot se
% Date: 2020-12-09

[X,Y] = meshgrid(mfaToTry,wallToTry);
Z = nan(size(X));

for aLoop = 1:size(X,1)
    for bLoop = 1:size(Y,2)
        Z(aLoop,bLoop) = costFcn([X(aLoop,bLoop) Y(aLoop,bLoop)]);
    end
end