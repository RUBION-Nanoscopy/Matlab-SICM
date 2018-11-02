function varargout = reverseData(self)
% Reverse the y-data

    if nargout == 1
        o = SICM.SICMAppCurve.fromSICMAppCurve_(self);
        o.reverseData();
        varargout{1} = o;
        return
    end
    
    self.ydata = self.ydata(end:-1:1);
