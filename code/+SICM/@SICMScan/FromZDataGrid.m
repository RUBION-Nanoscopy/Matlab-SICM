function o = FromZDataGrid(zdatagrid)
	% Convert a grid of z-data into a SICMScan object.
    %
    % See also SICMSCAN, FROMFILE
    o = SICM.SICMScan();
    o.zdata_grid = zdatagrid';
    o.zdata_lin = zdatagrid(:);
    sz = size(zdatagrid);
    o.setPx(sz(2), sz(1));
    o.setXSize(sz(2));
    o.setYSize(sz(1));
end