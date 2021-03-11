function set_callbacks( self )
    self.addlistener('linepointer', 'PostSet', @(~, ~) self.update_profile );
    self.addlistener('Result', 'PostSet',      @(~, ~) self.update_result );
    self.addlistener('threshold', 'PostSet',   @(~, ~) self.update_threshold );

    % Menu Callbacks
    
    % Data Display
    
    controls = { ...
        self.GUI.Controls.Menu.DataDisplayHeight, ...
        self.GUI.Controls.Menu.DataDisplaySlopeSlow, ...    
        self.GUI.Controls.Menu.DataDisplaySlopeFast ...
    };

    for c = controls
        c{1}.MenuSelectedFcn = @(~, ~) ...
            local_fake_radiobuttons( controls, c{1}, @self.update_scan );
        
    end
    
    controls = { ...
        self.GUI.Controls.Menu.ResultDisplayHeight, ...
        self.GUI.Controls.Menu.ResultDisplaySlopeSlow, ...
        self.GUI.Controls.Menu.ResultDisplaySlopeFast ...
    };
    
    
    for c = controls
        c{1}.MenuSelectedFcn = @(~, ~) local_fake_radiobuttons( controls, c{1}, @self.update_result); %#ok<FXSET>
    end
    
    % Auto-Fit
    
    self.GUI.Controls.Menu.DataAutoFit.MenuSelectedFcn = @(~, ~) local_toggle(self.GUI.Controls.Menu.DataAutoFit);

    controls = { ...
        self.GUI.Controls.Menu.ProfileAx.YLimMinMaxScan, ...
        self.GUI.Controls.Menu.ProfileAx.YLimMinMaxLine, ...
        self.GUI.Controls.Menu.ProfileAx.YLimManual ...
        };
    for c = controls
        c{1}.MenuSelectedFcn = @(~, ~) local_fake_radiobuttons( controls, c{1}, @self.plot_line); %#ok<FXSET>
    end
    self.GUI.Controls.Btns.SelectNextLine.Callback = @(~, ~) self.change_linepointer(1);
    self.GUI.Controls.Btns.SelectPrevLine.Callback = @(~, ~) self.change_linepointer(-1);

    % Keyboard 
    self.Figure.KeyPressFcn  = @self.handle_keypress;
    
    % Toolbar
    self.GUI.Controls.Toolbar.NextLineBtn.Callback = @(~, ~) self.change_linepointer(1);
    self.GUI.Controls.Toolbar.PrevLineBtn.Callback = @(~, ~) self.change_linepointer(-1);
    self.GUI.Controls.Toolbar.FitProfileBtn = @(~, ~) self.do_fit();
    self.GUI.Controls.Toolbar.AddROIBtn.Callback = @(~, ~) self.GUI.ROIList.add_roi();
    
    self.GUI.Controls.Toolbar.FitLinesBtn.Callback = @(~, ~) self.do_fit_lines();
    
    self.GUI.Controls.Toolbar.DataResultAsBase.Callback = @(~, ~) self.result_as_base();
    self.GUI.Controls.Toolbar.DataFitMagic.Callback = @(~, ~) self.fit_magic();
    self.GUI.Controls.Toolbar.FilterMedian.Callback = @(~,~) self.filter('median', 3);
    self.GUI.Controls.Toolbar.FilterMean.Callback = @(~,~) self.filter('mean', 3);
    
    % Figure close
    self.Figure.CloseRequestFcn = @(~, ~) self.exec_close_request();
end

function local_fake_radiobuttons( buttonlist, selection, varargin )
    for b = buttonlist 
        btn = b{1};
        if btn ~= selection
            btn.Checked = 'off';
        end
    end
    selection.Checked = 'on';
    
    if nargin > 2
        varargin{1}();
    end
end

function local_toggle( elem )
    elem.Checked = ~strcmp(elem.Checked, 'on');
end