function b = isDEC(self)
% returns whether the direction of the approach curve is DEC

    b = self.direction == SICM.SICMAppCurve.directions.DEC;