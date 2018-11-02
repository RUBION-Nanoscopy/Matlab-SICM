function R = appCurveRel(z, h0, d0)
%
% SICM.appCurve
%
% Calculates 1 + h0/(z-d0)
%
% R = SICM.appCurve(z, h0, d0)
%
% Calculates the relative resistance R for all values in the vector z and
% the corresponding constants h0 and d0.

R = 1 + h0./(z-d0);