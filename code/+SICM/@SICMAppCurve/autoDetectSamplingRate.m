function varargout = autoDetectSamplingRate( self, varargin )
    if nargout == 1
       o = SICM.SICMAppCurve.fromSICMAppCurve_(self);
       o.autoDetectSamplingRate( varargin{:} );
       varargout{1} = o;
       return;
    end
     
    Y = fft(self.ydata);
    
    real_part = abs(Y(1:floor(length(self.ydata)/2)+1));
    idx = find(real_part == max(real_part(2:end)))-1;
    f = 50;
    if nargin > 1
        f = varargin{1};
    end
    % fprintf('The maximum peak in frequency is in bin %g, maybe the sampling frequency was %g\n', idx, 2*f*(length(real_part)-1)/idx);
    self.setSamplingRate(2*f*(length(real_part)-1)/idx);
    
end