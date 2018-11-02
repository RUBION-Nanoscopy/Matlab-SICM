function importScan(self)
    try 
        s = SICM.SICMScan.FromFile();
    catch
        
    end
    self.data.Scan = SICM.SICMScan.fromSICMScan_(s);