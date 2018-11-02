function varargout = eachAppCurve(self, fhandle)
% This function applies the function handle provided by handle to each of
% the approach curves. For example, to fit all approach curves, use:
%
%   obj.eachAppCurve(@fit)
%
% This function is quite similar to the build-in cellfun function. However,
% the first arguments that is passed to the function is the SICMAppCurve
% object.
%
% See also CELLFUN

    if nargout == 1
        o = SICM.SICMScan.fromSICMScan_(self);
        o.eachAppCurve(fhandle);
        varargout{1} = o;
        return
    end
    %for i = 1:length(self.approachcurves)
    %    feval(fhandle, self.approachcurves{i}, varargin{:});
    %end
    
    cellfun(fhandle, self.approachcurves);
