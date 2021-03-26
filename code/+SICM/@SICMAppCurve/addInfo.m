function varargout = addInfo( self, info, value)
    if nargout == 1
       o = SICM.SICMAppCurve.fromSICMAppCurve_(self);
       o.addInfo( info, value );
       varargout{1} = o;
       return;
    end
    
    self.info.(info) = value;
    
end