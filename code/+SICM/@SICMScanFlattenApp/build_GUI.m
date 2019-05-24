function build_GUI(self)
            
    % Getting the screensize is always annoying, should make a
    % public helper function out of this. Make figure 3/4 of
    % screen height/width, or, if 1024×768 or smaller, fullscreen
    scsz = get(0, 'screensize'); w = 3 * scsz(3) / 4; 
    h = 3 * scsz(4) / 4; l = w/6; t = h/6;
    if scsz(3) <= 1024, w = scsz(3); l = 1; end
    if scsz(4) <= 768, w = scsz(4); t = 1; end

    self.Figure = figure(...
        'Visible', 'off', 'Name', 'Flatten SICM Scan', ...
        'NumberTitle', 'Off', 'Menubar', 'none', ...
        'Toolbar', 'none', 'Position', [l,t,w,h]);
    self.make_menu();
    
    
    self.GUI.MainVB = uix.VBox('Parent', self.Figure );
    self.make_toolbar();
    hb = uix.HBox('Parent', self.GUI.MainVB  );
    self.GUI.MainVB.Heights = [80 -1];
    
    vb_controls = uix.VBox('Parent', hb);
    
    self.GUI.ROIList = SICMAppHelpers.SicmFlattenAppROIList(...
        'Parent', uix.Panel('Parent', vb_controls, 'Title','ROI Manager', 'Padding', 10) ...
        );
    
    
    vb = uix.VBoxFlex('Parent', hb);
    hb.Widths = [220, -1];
    hb2 = uix.HBox('Parent', vb);
    pax1 = uix.Panel('Parent', hb2);
    pax2 = uix.Panel('Parent', hb2);

    self.GUI.Axes.Scan = axes('Parent', pax1);
    title('Original');

    self.GUI.Axes.Result = axes('Parent', pax2);
    title('Result');

    self.GUI.ROIList.RoiAx = self.GUI.Axes.Scan;
    
    self.GUI.Axes.Profile = axes('Parent', uix.Panel('Parent', vb));
    title('Profile');

    vb.Heights = [-5 -2];
    
end