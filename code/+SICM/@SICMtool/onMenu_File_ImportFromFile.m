function onMenu_File_ImportFromFile( self, elem, action )
    scan = SICM.SICMScan.FromFile();
    id = self.dataManager.addData(scan);
    self.gui.addPlot(scan, id);
    self.gui.setActivePlot(id);
    