function varargout = setXSize (self, xsize)
    % Set the X size  of the scan object to xsize. If available,
    % the data in xdata_lin and xdata_grid will be updated.
    if nargout == 1
        o = SICM.SICMScan.fromSICMScan_(self);
        o.setXSize(xsize)
        varargout{1} = o;
        return
    end

    self.setXSize_(xsize);
    self.update_from_xsize_();
end