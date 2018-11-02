function varargout = setDirection(self, direction)
% Sets the direction (INC or DEC) of an approach curve
%
%    Examples:
%      
%      obj.setDirection(SICM.SICMAppCurve.directions.INC)
%
%        Sets the direction of `obj` to INCC.
%
%      newobj = obj.setDirection(SICM.SICMAppCurve.directions.INC)
%
%        returns a new SICMAppCurve object with direction INC.

    if nargout == 1
        o = SICM.SICMAppCurve.fromSICMAppCurve_(self);
        o.setDirection(direction);
        varargout{1}=o;
        return
    end
    self.direction = direction;
end
