function varargout = addXOffset(self, xoffset)
% Shifts the data by `xoffset` in x-direction
%
%    Examples:
%
%      obj.addXOffset(2)
%
%        Shifts the data in `obj` by 2 length units.
%
%      newobj = obj.addXOffset(2)
%
%        As above, but reutrns a new object instead of modifying `obj`.

    if nargout == 1
        o = SICM.SICMScan.fromSICMScan_(self);
        o.addXOffset(xoffset);
        varargout{1} = o;
        return
    end
    
    self.xdata_grid = self.xdata_grid + xoffset;
    self.xdata_lin = self.xdata_grid(:);
    
    