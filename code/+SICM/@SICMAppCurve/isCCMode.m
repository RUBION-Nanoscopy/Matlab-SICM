function b = isCCMode(self)
% returns whether the mode of the approach curve is CC

    b = self.mode == SICM.SICMAppCurve.modes.CC;