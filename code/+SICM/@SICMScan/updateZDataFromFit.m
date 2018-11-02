function varargout = updateZDataFromFit(self, T)
% This function updates the z-data from the fitobjects in the
% approachcurves property.
%

if nargout == 1
    o = SICM.SICMScan.fromSICMScan_(self);
    o.updateZDataFromFit(T);
    varargout{1} = o;
    return
end

self.zdata_grid = cellfun(...
    @(x)(x.inversefitfunc(...
        x.fitobject.I0,...
        x.fitobject.C,...
        x.fitobject.D,...
        x.fitobject.I0 * T)), ...
        self.approachcurves);

end