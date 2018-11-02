function varargout = setFitFunc(self, handle)
% Sets the fit function handle used for the object.
%
% Examples:
%    ffunc = @(U0, C, d, x) (U0*(1+C/(x-d))
%
%    obj.setFitFunc(ffunc);
%
%      Sets the fit function to the function ffunc
%
%   newobj = obj.setFitFunc(ffunc);
%
%      Returns a new object with fit function ffunc

    if nargout == 1
        o = SICM.SICMAppCurve.fromSICMAppCurve_(self);
        o.setFitFunc(handle);
        varargout{1} = o;
        return
    end
    self.fitfunc = handle;
end
    
