function r = rms(self)
% Compute the root mean square of the scan:

    delta = self.zdata_lin - mean(self.zdata_lin);
    
    r = sqrt(mean(delta.^2));
    
end