function varargout = normalize(self)
% Normalizes the z-data
%
%    Examples:
%
%       obj.normaliez()
%
%         Normalizes the z-data of `obj`to be between 0 and 1.
%
%       newobj = obj.normalize()
%
%         As above, but returns a new SICMScan object instead of modifying
%         the data of `obj`.

    if nargout == 1
        o = SICM.SICMScan.fromSICMScan_(self);
        o.normalize();
        varargout{1} = o;
        return
    end
    
    self.subtract_(min(self));
    self.multiply_(1./max(self));
end