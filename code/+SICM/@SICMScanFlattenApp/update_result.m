function update_result ( self )
	xg = self.Scan.xdata_grid;
	yg = self.Scan.ydata_grid;
	zg = self.Result;
            
	self.surface(self.GUI.Axes.Result, xg,yg,zg);
end