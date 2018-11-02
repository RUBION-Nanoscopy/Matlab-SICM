function varargout = normalizeData(self, varargin)
% Normalize the y-data
%
% If no argument is specified, the mean of last 10% of the data points is
% used to normalize the data. Note that since this class assumes that the
% change in conductance occurs at smaller x-values, the mena is calcultaed
% at the end of the y-data

    if nargout == 1
        o = SICM.SICMAppCurve.fromSICMAppCurve_(self);
        o.normalizeData(varargin{:});
        varargout{1} = o;
        return
    end
    n = round(length(self.ydata)/10);
    if nargin > 1
        n = varargin{1};
    end
    m = mean(self.ydata(end-n:end));
    self.ydata = self.ydata./m;