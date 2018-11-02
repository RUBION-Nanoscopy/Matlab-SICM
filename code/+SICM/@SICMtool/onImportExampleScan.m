function onImportExampleScan(self, ~, ~)
    self.data.Scan = SICM.SICMScan.FromExampleData();
    self.update();