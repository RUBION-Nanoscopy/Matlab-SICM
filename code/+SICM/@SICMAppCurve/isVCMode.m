function b = isVCMode(self)
% returns whether the mode of the approach curve is VC

    b = self.mode == SICM.SICMAppCurve.modes.VC;