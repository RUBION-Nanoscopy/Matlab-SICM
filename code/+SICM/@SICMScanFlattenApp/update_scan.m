function update_scan( self )
    xg = self.Scan.xdata_grid;
    yg = self.Scan.ydata_grid;
	zg = self.Scan.zdata_grid;
            
	self.surface(self.GUI.Axes.Scan, xg,yg,zg);
end