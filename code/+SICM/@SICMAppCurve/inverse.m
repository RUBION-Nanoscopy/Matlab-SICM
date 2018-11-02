function varargout = inverseData(self)
% Inverse the y-data: Data becomes 1/data

    if nargout == 1
        o = SICM.SICMAppCurve.fromSICMAppCurve_(self);
        o.inverseData();
        varargout{1} = o;
        return
    end
    
    self.ydata = 1./self.ydata(:);