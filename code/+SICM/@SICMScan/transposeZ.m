function varargout = transposeZ(self)
% Transposes the zdata_grid 
    if nargout == 0
        self.zdata_grid = self.zdata_grid';
        self.zdata_lin = self.zdata_grid(:);
    else
        o = SICM.SICMScan.fromSICMScan_(self);
        o.transposeZ();        
        varargout{1} = o;
    end
    
%+BEGIN GUIMETADATA: Do not delete
%+GMD Type: 'meth'
%+GMD Name: 'Transpose Z'
%+GMD FixedArgs: {}
%+GMD VarArgs: {}
%+GMD Depends: {}
%+GMD Changes: {'z'}
%+GMD Immediate: 0
%+GMD Menu: 'Simple Manipulations'
%+END GUIMETADATA