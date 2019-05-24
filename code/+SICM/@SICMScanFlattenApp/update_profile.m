function update_profile( self )
            
	lp = self.linepointer; 
            
    self.line = self.Scan.zdata_grid(lp, :);    

    self.manual_selection = zeros(1, numel(self.line));
	
    if all(isnan(self.threshold)) % Very first run
        self.threshold = [.2 .2];
        self.update_threshold();
    else
    	self.threshold = [.2 .2];
    end
    delete(self.linemarker);
            
    self.GUI.Axes.Scan.NextPlot = 'add';
            
    x0 = self.Scan.ydata_grid(1,lp);
    xE = self.Scan.ydata_grid(end,lp);
            
            
    dy = 2*(self.Scan.xdata_grid(1,2) - self.Scan.xdata_grid(1,1));
    y0 = self.Scan.xdata_grid(1,lp);
    yE = self.Scan.xdata_grid(end,lp);
            
	self.linemarker = patch(self.GUI.Axes.Scan, ...
        'XData', [x0 x0 xE xE],... 
        'YData', [y0+dy yE-dy yE-dy y0+dy] ,... 
    	'ZData', ones(4,1) * 1.1 * self.Scan.max ...
    );
    self.linemarker.FaceColor = [1 0 0];
    self.linemarker.FaceAlpha = .5;
    self.linemarker.LineStyle = 'none'; 
	self.GUI.Axes.Scan.NextPlot = 'replace';
end