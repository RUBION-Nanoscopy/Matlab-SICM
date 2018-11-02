function varargout = frequencyPlot( self )
    if ~isnan(self.SamplingRate)
        dFrq = self.SamplingRate / length(self.ydata);
        freq = 0 : dFrq : self.SamplingRate/2;
    else
        freq = 0 : floor(length(self.ydata)/2)+1;
    end
    Y = fft(self.ydata);
    
    p = semilogx(freq, abs(Y(1:length(freq))));
    if nargout > 0
        varargout = p;
    end
        
end