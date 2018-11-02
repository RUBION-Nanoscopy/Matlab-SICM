function varargout = setMode(self, mode)
% Sets the mode (CC or VC) of an approach curve
%
%    Examples:
%      
%      obj.setMode(SICM.SICMAppCurve.modes.VC)
%
%        Sets the mode of `obj` to VC.
%
%      newobj = obj.setMode(SICM.SICMAppCurve.modes.VC)
%
%        returns a new SICMAppCurve object with mode VC.

    if nargout == 1
        o = SICM.SICMAppCurve.fromSICMAppCurve_(self);
        o.setMode(mode);
        varargout{1}=o;
        return
    end
    self.mode = mode;
end
