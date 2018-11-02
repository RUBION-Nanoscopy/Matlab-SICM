function varargout = transposeAll(self)
% Transposes the xdata_grid and ydata_grid    
    if nargout == 0
        self.xdata_grid = self.xdata_grid';
        self.ydata_grid = self.ydata_grid';
        self.zdata_grid = self.zdata_grid';
        self.xdata_lin = self.xdata_grid(:);
        self.ydata_lin = self.ydata_grid(:);
        self.zdata_lin = self.zdata_grid(:);
    else
        o = SICM.SICMScan.fromSICMScan_(self);
        o.transposeAll();        
        varargout{1} = o;
    end
    