function varargout = setSamplingRate(self, rate)
                         
    if nargout == 1
        o = SICM.SICMAppCurve.fromSICMAppCurve_(self);
        o.setSamplingRate( rate );
        varargout{1} = o;
        return;
    end
    
    self.SamplingRate = rate;
end