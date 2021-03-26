function varargout = shiftY(self, offset)
% Shifts the xdata by /offset/
%
%    Examples:
%      
%      obj.shiftY(100)
%
%        Shifts the ydata by 100.
%
%      newobj = obj.shiftY(100)
%
%        returns a new SICMAppCurve object with shifted ydata.

    if nargout == 1
        o = SICM.SICMAppCurve.fromSICMAppCurve_(self);
        o.shiftY(offset);
        varargout{1}=o;
        return
    end
    self.ydata = self.ydata + offset;
end