function varargout = addYOffset(self, yoffset)
% Shifts the data by `yoffset` in y-direction
%
%    Examples:
%
%      obj.addYOffset(2)
%
%        Shifts the data in `obj` by 2 length units.
%
%      newobj = obj.addYOffset(2)
%
%        As above, but reutrns a new object instead of modifying `obj`.

    if nargout == 1
        o = SICM.SICMScan.fromSICMScan_(self);
        o.addYOffset(yoffset);
        varargout{1} = o;
        return
    end
    
    self.ydata_grid = self.ydata_grid + yoffset;
    self.ydata_lin = self.ydata_grid(:);
end