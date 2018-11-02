function u = appCurve(z, h0, d0, U0)
%
% SICM.appCurve
%
% Calculates U0.*(1 + h0./(z-d0))
%
% R = SICM.appCurve(z, h0, d0, U0)
%
% Calculates the voltages for all values in the vector z and
% the corresponding constants h0, d0 and U0.

u = U0.*(1 + h0./(z-d0));