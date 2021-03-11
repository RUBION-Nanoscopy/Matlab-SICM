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
            
    %self.GUI.Axes.Scan.NextPlot = 'add';
            
    x0 = self.Scan.ydata_grid(1,lp);
    xE = self.Scan.ydata_grid(end,lp);
            
            
    dy = 2*(self.Scan.xdata_grid(1,2) - self.Scan.xdata_grid(1,1));
    y0 = self.Scan.xdata_grid(1,lp);
    yE = self.Scan.xdata_grid(end,lp);
            
    sz = size(self.Scan.zdata_grid);
	self.linemarker = drawline(self.GUI.Axes.Scan, ...
        'Position', [0 lp; sz(1) lp],... 
        'Color', [1 0 1], ...
        'InteractionsAllowed', 'none' ...
    );
    %self.linemarker.FaceColor = [1 0 0];
    %%self.linemarker.FaceAlpha = .5;
    %self.linemarker.LineStyle = 'none'; 
    
	%self.GUI.Axes.Scan.NextPlot = 'replace';
end