function varargout = transposeXY(self)
% Transposes the xdata_grid and ydata_grid    
    if nargout == 0
        self.xdata_grid = self.xdata_grid';
        self.ydata_grid = self.ydata_grid';
        self.xdata_lin = self.xdata_grid(:);
        self.ydata_lin = self.ydata_grid(:);
        tmp = self.xsize;
        self.xsize = self.ysize;
        self.ysize = tmp;
    else
        o = SICM.SICMScan.fromSICMScan_(self);
        o.transposeXY();
        varargout{1} = o;
    end
    