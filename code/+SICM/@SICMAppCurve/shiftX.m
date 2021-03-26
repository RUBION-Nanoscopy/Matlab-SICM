function varargout = shiftX(self, offset)
% Shifts the xdata by /offset/
%
%    Examples:
%      
%      obj.shiftX(100)
%
%        Shifts the xdata by 100.
%
%      newobj = obj.shiftX(100)
%
%        returns a new SICMAppCurve object with shifted xdata.

    if nargout == 1
        o = SICM.SICMAppCurve.fromSICMAppCurve_(self);
        o.shiftX(offset);
        varargout{1}=o;
        return
    end
    self.xdata = self.xdata + offset;
end