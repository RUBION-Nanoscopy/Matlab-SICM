function result_as_base( self )
    
    scan = self.result_as_SICMScan();
    self.GUI.ROIList.prepareUpdate();
    self.Scan = scan;
    
    self.Result = self.Scan.zdata_grid - self.Scan.min;
    self.Fits = zeros(size(self.Result, 1), 2);
    self.update_scan();
    self.update_result();
    self.linepointer = 1;
    self.update_profile();
    
    
    
    
    
    self.GUI.ROIList.updateROIs();
    
    
    
    
end