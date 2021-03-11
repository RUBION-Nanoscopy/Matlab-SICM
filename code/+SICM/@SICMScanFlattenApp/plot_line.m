function plot_line(self, varargin)
            
    x = 1:numel(self.line);
    if nargin > 1
        plot(self.GUI.Axes.Profile, [min(x)-5 max(x)+5], varargin{1}, 'r:');
        self.GUI.Axes.Profile.NextPlot = 'add';
    end
            
    plot(self.GUI.Axes.Profile, x, self.line, '-', 'Color', [.5 .5 .5]);    
    self.GUI.Axes.Profile.NextPlot = 'add';
    plot(self.GUI.Axes.Profile, x(self.selection), self.line(self.selection), 'ko', 'MarkerSize', 4);

            
    self.GUI.Axes.Profile.NextPlot = 'replace';
    if strcmp(self.GUI.Controls.Menu.ProfileAx.YLimMinMaxScan.Checked, 'on')
        self.GUI.Axes.Profile.YLim = [self.Scan.min, self.Scan.max];
    end
    if strcmp(self.GUI.Controls.Menu.ProfileAx.YLimMinMaxLine.Checked, 'on')
        self.GUI.Axes.Profile.YLim = [min(self.line) max(self.line)];
    end
    
    self.GUI.Axes.Profile.XLim = [min(x)-18 max(x)+18];
            
	if nargin > 1
    	self.plot_threshold_marker(min(x) - 5, varargin{1}(1), 1);
        self.plot_threshold_marker(max(x) + 5, varargin{1}(2), -1);
	end
    if strcmp(self.GUI.Controls.Menu.DataAutoFit.Checked, 'on') ...
            && ( isempty(self.old_selection) ...
                || any(self.selection ~= self.old_selection)...
            )   
                
        [a,b] = self.do_fit(false);
        self.GUI.Axes.Profile.NextPlot = 'add';
        plot(self.GUI.Axes.Profile, b, a, 'b-');
        self.GUI.Axes.Profile.NextPlot = 'replace';
    end
end