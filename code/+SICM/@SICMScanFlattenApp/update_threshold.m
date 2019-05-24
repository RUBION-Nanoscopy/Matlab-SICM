function update_threshold(self)
	thr = zeros(1,2);
    for j = 1:2
        thr(j) = min(self.line) + self.threshold(j) * ...
        	(max(self.line) - min(self.line)); 
    end
    x = 0:numel(self.line)-1;
	y = polyval([diff(thr)/(x(end)-x(1)), thr(1)], x);
            
	self.old_selection = self.selection;
            
	self.selection = self.line <= y; 
	self.selection(self.manual_selection == 1) = 1;
	self.selection(self.manual_selection == -1) = 0;
	self.plot_line(thr); 
       
end