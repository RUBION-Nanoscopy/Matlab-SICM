function varargout = changeXY(self)
% Changes x and y values
    if nargout == 0
        tmp_y = self.xdata_grid;
        self.xdata_grid = self.ydata_grid;
        self.ydata_grid = tmp_y;
        self.xdata_lin = self.xdata_grid(:);
        self.ydata_lin = self.ydata_grid(:);
    else
        o = SICM.SICMScan.fromSICMScan_(self);
        o.changeXY();
        varargout{1} = o;
    end
    