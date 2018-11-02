function varargout = guessCurveType(self, varargin)
% 
%
% This function tries to ananlyze the data and to find out whether the
% curve was recorded in CC or VC mode and whether the chnage in conductance
% occurs at smaller x-values or larger x-values.
     if nargout == 1
        o = SICM.SICMAppCurve.fromSICMAppCurve_(self);
        o.guessCurveType(varargin{:});
        varargout{1} = o;
        return;
    end
    self.guessMode(varargin{:});
    self.guessDirection(varargin{:});
    self.guessFitFunc(varargin{:});
end
