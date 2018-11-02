function varargout = plot(self, varargin)
% Plots the data in appCurve
    a = plot(self.xdata, self.ydata, varargin{:});
    if nargout > 1
        varargout{1} = a;
    end
    