function do_fit_lines(self)
    rois = self.GUI.ROIList.getSelectedROIs();
    if isempty(rois), return; end
    sz = size(self.Scan.zdata_grid);
    mask = zeros(sz);
    for roi = rois
        r = roi{1};
        mask = mask | poly2mask(r.Position(:,1), r.Position(:,2), sz(1), sz(2)); 
    end
    line_idx = find(any(mask,2)==true);
    x = 1:sz(2);
    data = self.Scan.zdata_grid;
    for lp = line_idx'
        
        
        
        
        
        line_mask = mask(lp, :);
        line = self.Scan.zdata_grid(lp,line_mask);
        if numel(line) < 2, continue; end
        x2 = x(line_mask);
        result = polyfit(x2,line,1);
        data(lp,:) = data(lp,:) - polyval(result, x);
        
        
    end
    self.Result = data;
    
end