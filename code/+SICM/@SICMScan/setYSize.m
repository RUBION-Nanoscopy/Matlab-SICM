function varargout = setYSize (self, ysize)
    % Set the Y size  of the scan object to ysize. If available,
    % the data in ydata_lin and ydata_grid will be updated.
    if nargout == 1
        o = SICM.SICMScan.fromSICMScan_(self);
        o.setYSize(ysize)
        varargout{1} = o;
        return
    end
    self.setYSize_(ysize);
    self.update_from_ysize_()
end