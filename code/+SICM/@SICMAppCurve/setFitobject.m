function varargout = setFitobject(self, fitobject)
% Set's the fitobject of the approach Curve
if nargout == 1
    o = SICM.SICMAppCurve.fromSICMAppCurve_(self);
    o.setFitobject(fitobject);
    varargout{1} = o;
    return
end

self.fitobject = fitobject;
self.fitproblems = 0;