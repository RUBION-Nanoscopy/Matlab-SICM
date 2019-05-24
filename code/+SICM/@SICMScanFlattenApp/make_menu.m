function make_menu( self )
    menu = struct();

    session = uimenu(self.Figure, 'Text','Session');
    menu.SessionApply =   uimenu(session, 'Text', 'Apply Changes');
    menu.SessionDiscard = uimenu(session, 'Text', 'Discard Changes');

    data = uimenu(self.Figure, 'Text', 'Data');

    menu.DataNextLine = uimenu(data, 'Text', 'Select Next Line');
    menu.DataPrevLine = uimenu(data, 'Text', 'Select Prev Line');
    menu.DataUndoLine = uimenu(data, 'Text', 'Undo selected line', 'Separator', true);
    menu.DataUndoAll  = uimenu(data, 'Text', 'Undo all', 'Separator', true);

    menu.DataSwitchSlowFast = uimenu(data, 'Text', 'Switch slow/fast (rotate by 90°)');
    menu.DataFit            = uimenu(data, 'Text', 'Fit'); 
    menu.DataAutoFit        = uimenu(data, 'Text', 'Auto-Fit', 'Checked', false);


    view = uimenu(self.Figure, 'Text', 'View');

    profile = uimenu(view, 'Text','Profile Axes');
    profile_ylim = uimenu(profile, 'Text', 'Y Limits');
    menu.ProfileAx = struct();
    menu.ProfileAx.YLimMinMaxScan = uimenu( profile_ylim, 'Text', 'Min/Max of Scan'); 
    menu.ProfileAx.YLimMinMaxLine = uimenu( profile_ylim, 'Text', 'Min/Max of Line'); 
    menu.ProfileAx.YLimManual     = uimenu( profile_ylim, 'Text', 'Manual'); 
    profile_yscale                = uimenu(profile, 'Text', 'Scale');
    menu.ProfileAx.YLin           = uimenu( profile_yscale, 'Text', 'Linear'); 
    menu.ProfileAx.YLog           = uimenu( profile_yscale, 'Text', 'Logarithmic'); 


    data_v = uimenu(view, 'Text','Data');
    display = uimenu( data_v, 'Text','Display');
    menu.DataDisplayHeight = uimenu(display, 'Text', 'Height', 'Checked', 'on');
    menu.DataDisplaySlopeSlow = uimenu(display, 'Text', 'Slope along slow direction');
    menu.DataDisplaySlopeFast = uimenu(display, 'Text', 'Slope along fast direction');
    result = uimenu(view, 'Text','Result');

    menu.ResultSubtractMin = uimenu(result, 'Text', 'Subtract Minimum');
    display = uimenu( result, 'Text','Display');
    menu.ResultDisplayHeight = uimenu(display, 'Text', 'Height');
    menu.ResultDisplaySlopeSlow = uimenu(display, 'Text', 'Slope along slow direction', 'Checked', 'on');
    menu.ResultDisplaySlopeFast = uimenu(display, 'Text', 'Slope along fast direction');


    self.GUI.Controls.Menu = menu;
end