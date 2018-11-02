function generateAxes(self)

    
    l = self.gui.layout;
    %a.ScanAxes = axes('Parent', uicontainer('Parent', l.hboxScanAxes));
    %a.AppAxes = axes('Parent', uicontainer('Parent', l.hboxAppAxes));
    self.gui.axes.ScanContainer = uicontainer( ...
            'Parent', l.hboxScanAxes );
    self.gui.axes.AppContainer = uicontainer( ...
            'Parent', l.hboxAppAxes );
    %self.gui.axes = a;

