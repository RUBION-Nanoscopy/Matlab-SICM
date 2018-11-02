function g = appCurveG(z, C, H, G0)
%
% SICM.appCurve
%
% Calculates G0.*(1 + (C./(z-H))^-1)
%
% G = SICM.appCurveG(z, C, H, G0)
%
% Calculates the conductances for all values in the vector z and
% the corresponding constants C, H and G0.

g = G0.*(1 + (C./(z-H))^-1);