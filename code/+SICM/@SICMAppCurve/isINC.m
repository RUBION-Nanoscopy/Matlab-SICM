function b = isINC(self)
% returns whether the direction of the approach curve is INC

    b = self.direction == SICM.SICMAppCurve.directions.INC;