function scan = result_as_SICMScan(self)
    scan = SICM.SICMScan.FromZDataGrid(self.Result');
    scan.setXSize(self.Scan.xsize); 
    scan.setYSize(self.Scan.ysize); 
end