function generateLayout(self)
    l = struct();
    l.outerHBox = uix.HBoxFlex('Parent', self.gui.Window);
    l.tabInfo = uix.TabPanel('Parent', l.outerHBox);
    l.vboxAxes = uix.VBoxFlex('Parent', l.outerHBox);
    l.hboxScanAxes = uix.HBox('Parent', l.vboxAxes);
    l.hboxAppAxes = uix.HBox('Parent', l.vboxAxes);
    set(l.outerHBox,'Width',[-1 -3]);
    self.gui.layout = l;

