classdef SICMSingleDataDisplay < matlab.ui.componentcontainer.ComponentContainer
    properties
        Value (1,1) SICM.SICMScan
        DisplayType sicmapp.gui.SICMDataDisplayTypes
        IsActive = true 
        SICMScanInterface
    end
    properties (Dependent)
        AxProps
        Title
        
    end
    events (HasCallbackProperty, NotifyAccess = protected)
        ValueChanged % ValueChangedFcn callback property will be generated
        AxPropsChanged
        MenuChanged
    end
    

    
    properties (Access = public, Transient, NonCopyable)
        
        Grid matlab.ui.container.GridLayout
        
        Axes matlab.ui.control.UIAxes
        Panel matlab.ui.container.Panel
        Modal matlab.ui.Figure
        HasTopoMenu = false
        TopoMenuStructure
        TmpVarArgs
        OnUpdateAdjustCLim matlab.ui.container.Menu
        OnUpdateAdjustCRange matlab.ui.container.Menu
        OnUpdateAdjustZLim matlab.ui.container.Menu
        OnUpdateAdjustZRange matlab.ui.container.Menu
        AxesInteractionMenu (1,:) matlab.ui.container.Menu
        InterpolateSurface matlab.ui.container.Menu
        PropWindow
    end
    methods
        function p = get.AxProps(self)
            p = struct();
            for prop = properties(self.Axes)'
                pname = prop{1};
                p.(pname) = self.Axes.(pname);
            end
        end
        function set.AxProps(self, value)
            for field = fieldnames(value)'
                fname = field{1};
                try
                    self.Axes.(fname) = value.(fname);
                catch
                end
            end
        end
        function t = get.Title(self)
            t = self.Panel.Title;
        end
        function set.Title(self, t)
            self.Panel.Title = t;
        end
        
        function delete(self)
            if ~isempty(self.PropWindow)
                delete(self.PropWindow);
            end
            delete@matlab.ui.componentcontainer.ComponentContainer(self);
        end
    end
    methods (Access = protected)
        function setup(self)    
            self.Panel = uipanel(self);
            self.Grid = uigridlayout(self.Panel, [1,1], 'Padding', 0, 'RowHeight', {'1x'});
            
            self.Axes = uiaxes(self.Grid);
            %self.readTopoMenuStructure();
        end
        
        
        function update(self)
            if ~isempty(self.Value)
                if self.IsActive
                    self.Panel.FontWeight = 'bold';
                else
                    self.Panel.FontWeight = 'normal';
                end
                self.Panel.Title = self.Title;
                if isempty(self.DisplayType)
                    self.DisplayType = sicmapp.gui.SICMDataDisplayTypes.HEIGHT3D;
                end
                
                self.replot()
            end
        end
    end
    methods
        function replot(self)
           
            
            switch self.DisplayType
                case sicmapp.gui.SICMDataDisplayTypes.HEIGHT3D
                    self.Axes.NextPlot = 'replacechildren';
                    s = [];
                    if ~isempty(self.Axes.Children)
                        for child = self.Axes.Children'
                            if isa(child, 'matlab.graphics.chart.primitive.Surface')
                                s = child;
                                break
                            end
                        end
                    end
                    if ~isempty(s)
                        zrange = max(s.ZData(:)) - min(s.ZData(:));
                        crange = max(s.CData(:)) - min(s.CData(:));
                    else
                        zrange = 0;
                        crange = 0;
                    end
                    
                    if ~isempty(self.OnUpdateAdjustCRange) && ~isempty(self.OnUpdateAdjustCLim)
                        if self.OnUpdateAdjustCRange.Checked && self.OnUpdateAdjustCLim.Checked
                            self.Axes.CLimMode = 'auto';
                        else
                            self.Axes.CLimMode = 'manual';
                        end
                    end
                    
                    if ~isempty(self.OnUpdateAdjustZLim) && ~isempty(self.OnUpdateAdjustZRange)
                        if self.OnUpdateAdjustZLim.Checked && self.OnUpdateAdjustZRange.Checked
                            self.Axes.ZLimMode = 'auto';
                        else
                            self.Axes.ZLimMode = 'manual';
                        end
                    end
                    
                    
                    vw = self.Axes.View;
                    % SICMScan.plot calls SICMScan.surface, which uses
                    % surface instead of surf to generate the plot. This
                    % does not delete old children etc. Thus, I use surf
                    % here:
                    
                    s = surf(self.Axes, ...
                        self.Value.xdata_grid, ...
                        self.Value.ydata_grid, ...
                        self.Value.zdata_grid, ...
                        'EdgeColor', 'none');
                    
                    if ~isempty(self.InterpolateSurface) && self.InterpolateSurface.Checked
                        s.FaceColor = 'interp';
                    end
                    self.Axes.View = vw;
                    self.prepareAxes(s, crange, zrange);
                    
                case sicmapp.gui.SICMDataDisplayTypes.HEIGHT2D
                    img = imagesc(self.Axes, self.Value.zdata_grid);
                    img.XData = self.Value.xdata_grid(1,:);
                    img.YData = self.Value.ydata_grid(:,1);
                    self.Axes.XLim = [min(self.Value.xdata_lin) max(self.Value.xdata_lin)];
                    self.Axes.YLim = [min(self.Value.ydata_lin) max(self.Value.ydata_lin)];
                    self.Axes.View = [0 90];
                	
                case sicmapp.gui.SICMDataDisplayTypes.SLOPE
                    sl = self.Value.slope();
                    self.Axes.Colormap = gray(256);
                    imagesc(self.Axes, sl);
                    self.Axes.XLim = self.Axes.Children(1).XData;
                    self.Axes.YLim = self.Axes.Children(1).YData;
                    self.Axes.ZLim = [min(min(self.Axes.Children(1).CData)) max(max(self.Axes.Children(1).CData))];
                    m = max(abs(self.Axes.ZLim));
                    
                    self.Axes.CLim = [-m m];
                    
            end 
        end
        
        
        
        
        function prepareAxes(self, s, oldcrange, oldzrange)
            self.addTopoMenu();
            self.Axes.Interactions = [];    
            for menu = self.AxesInteractionMenu
                if menu.Checked
                    self.Axes.Interactions = [menu.UserData];
                end
            end
            
            self.Axes.XLim = [min(self.Value.xdata_lin), max(self.Value.xdata_lin)];
            self.Axes.YLim = [min(self.Value.ydata_lin), max(self.Value.ydata_lin)];
            if strcmp(self.Axes.CLimMode, 'manual') 
                if isempty(self.OnUpdateAdjustCRange) || self.OnUpdateAdjustCRange.Checked 
                    crange = max(s.CData(:)) - min(s.CData(:));
                else
                    crange = oldcrange;
                end
                if isempty(self.OnUpdateAdjustCLim) || self.OnUpdateAdjustCLim.Checked
                    self.Axes.CLim(1) = min(s.CData(:));
                end
                self.Axes.CLim(2) = self.Axes.CLim(1) + crange;
            end
            if strcmp(self.Axes.ZLimMode, 'manual') 
                if isempty(self.OnUpdateAdjustZRange) || self.OnUpdateAdjustZRange.Checked 
                    zrange = max(s.ZData(:)) - min(s.ZData(:));
                else
                    zrange = oldzrange;
                end
                if isempty(self.OnUpdateAdjustZLim) || self.OnUpdateAdjustZLim.Checked
                    self.Axes.ZLim(1) = min(s.ZData(:));
                end
                self.Axes.ZLim(2) = self.Axes.ZLim(1) + zrange;
            end
            
            self.Axes.Toolbar = [];
            

%             addlistener(self.Axes, 'XLim', 'PostSet', @self.on_ax_update);
%             addlistener(self.Axes, 'YLim', 'PostSet', @self.on_ax_update);
%             addlistener(self.Axes, 'ZLim', 'PostSet', @self.on_ax_update);
%             addlistener(self.Axes, 'View', 'PostSet', @self.on_ax_update); 
            
            
        end
        
        function cleanMenu(self, fig)
            % cleans the figure menu
            for child = fig.Children'
                if isa(child, 'matlab.ui.container.Menu')
                    if isstruct(child.UserData) && isfield(child.UserData, 'IsMajorMenu') && ~child.UserData.IsMajorMenu
                        delete(child);
                    end
                end
            end
        end
        function addTopoMenu(self)
            
            if (self.HasTopoMenu)
                return
            end
            fig = sicmapp.gui.get_figure_handle(self);
            
            self.cleanMenu(fig);
            % Export menu
            emenu = uimenu(fig, 'Text', 'Export', 'UserData', struct('IsMajorMenu', false));
            ecmenu = uimenu(emenu, 'Text', 'To clipboard...');
            
            uimenu(ecmenu, 'Text', 'As bitmap (.png)', 'MenuSelectedFcn', @(menu, data) self.on_export_clipboard('image'));
            
            uimenu(ecmenu, 'Text', 'As vector graphic (.pdf)', 'MenuSelectedFcn', @(menu, data) self.on_export_clipboard('vector'));
            
            efmenu = uimenu(emenu, 'Text', 'To File...');
            %uimenu(efmenu, 'Text', 'As bitmap (.png)', 'MenuSelectedFcn', @(menu, data) self.on_export_file('png', 'bitmap'));
            %uimenu(efmenu, 'Text', 'As bitmap (.tiff)', 'MenuSelectedFcn', @(menu, data) self.on_export_file('tiff', 'bitmap'))
            %uimenu(efmenu, 'Text', 'As bitmap (.pdf)', 'MenuSelectedFcn', @(menu, data) self.on_export_file('pdf', 'bitmap'));
            %uimenu(efmenu, 'Text', 'As vector graphic (.pdf)', 'MenuSelectedFcn', @(menu, data) self.on_export_file('png', 'vector'));
            
            % Interaction menu
            imenu = uimenu(fig, 'Text', 'Plot interaction', ...
                'UserData', struct('IsMajorMenu', false));
            
            self.AxesInteractionMenu(1) = uimenu(imenu, 'Text', 'Rotate', 'Checked', true, ...
                'MenuSelectedFcn', @(el, data)self.on_set_ax_interaction(el, data), ...
                'UserData', rotateInteraction);
            self.AxesInteractionMenu(2) = uimenu(imenu, 'Text', 'Pan', 'Checked', false, ...
                'MenuSelectedFcn', @(el, data)self.on_set_ax_interaction(el, data), ...
                'UserData', panInteraction);
            self.AxesInteractionMenu(3) = uimenu(imenu, 'Text', 'Zoom', 'Checked', false, ...
                'MenuSelectedFcn', @(el, data)self.on_set_ax_interaction(el, data), ...
                'UserData', zoomInteraction);
            
            viewmenu = uimenu(fig, 'Text', 'View', ...
                'UserData', struct('IsMajorMenu', false));
            uimenu(viewmenu, 'Text', 'Hide axis content', 'Checked', false,...
                'MenuSelectedFcn', @self.on_toggle_content);
            uimenu(viewmenu, 'Text', 'Hide axes', 'Checked', false, ...
                'MenuSelectedFcn', @self.on_toggle_axvis);
            updview = uimenu(viewmenu, 'Text', 'When updated...');
            
            self.OnUpdateAdjustCLim = uimenu(updview, 'Text', 'Auto-adjust Color Limits', 'Checked', 'on', 'MenuSelectedFcn', @self.on_toggle_menu);
            self.OnUpdateAdjustCRange = uimenu(updview, 'Text', 'Auto-adjust Color Range', 'Checked', 'on', 'MenuSelectedFcn', @self.on_toggle_menu);
            self.OnUpdateAdjustZLim = uimenu(updview, 'Text', 'Auto-adjust z-Limits', 'Checked', 'on', 'MenuSelectedFcn', @self.on_toggle_menu);
            self.OnUpdateAdjustZRange = uimenu(updview, 'Text', 'Auto-adjust z-Range', 'Checked', 'on', 'MenuSelectedFcn', @self.on_toggle_menu);
            uimenu(viewmenu, 'Text', 'Restore view', 'Separator', 'on');
            modemenu = uimenu(viewmenu, 'Text', 'Mode...');
            uimenu(modemenu, 'Text', '3D', 'Checked', true, ...
                'MenuSelectedFcn', @(src, data) self.on_select_displaytype(src, data, sicmapp.gui.SICMDataDisplayTypes.HEIGHT3D));
            uimenu(modemenu, 'Text', '2D', 'Checked', false, ...
                'MenuSelectedFcn', @(src, data) self.on_select_displaytype(src, data, sicmapp.gui.SICMDataDisplayTypes.HEIGHT2D));
            uimenu(modemenu, 'Text', 'Slope', 'Checked', false, ...
                'MenuSelectedFcn', @(src, data) self.on_select_displaytype(src, data, sicmapp.gui.SICMDataDisplayTypes.SLOPE));
            
            uimenu(viewmenu, 'Text', 'Aspect ratio', 'Separator', 'on', 'MenuSelectedFcn', @self.on_aspect_ratio);
            self.InterpolateSurface = uimenu(viewmenu, 'Text', 'Interpolate surface', 'Separator', 'on', 'Checked', false, 'MenuSelectedFcn', @self.on_interpolate_surface);
            uimenu(viewmenu, 'Text', 'Adjust Limits', 'MenuSelectedFcn', @self.on_adjust_limits);
            cmmenu = uimenu(viewmenu, 'Text', 'Colormap...');
            uimenu(cmmenu, 'Text', 'Select Colormap', 'MenuSelectedFcn', @self.on_select_colormap);
            uimenu(cmmenu, 'Text', 'Edit Colormap', 'MenuSelectedFcn', @self.on_edit_colormap);
            manipulate = uimenu(fig, 'Text', 'Manipulate data', 'UserData', struct('IsMajorMenu', false));
            measurements = uimenu(fig, 'Text', 'Measurements', 'UserData', struct('IsMajorMenu', false));
            properties = uimenu(fig, 'Text', 'Properties', 'MenuSelectedFcn', @self.on_properties_selected,...
                'UserData', struct('IsMajorMenu', false));
            self.makeInterfaceMenu(manipulate, measurements);
            
            self.HasTopoMenu = true;
            notify(self, 'MenuChanged');
        end
        
        % export callbacks
        
        function on_export_clipboard(self, format)
            args = {'ContentType', format};
            switch format
                case 'image'
                    args(3:4) = {'Resolution', 300};
            end
            
                
            copygraphics(self.Axes,args{:});
        end
        function on_select_colormap(self, menu, data)
            modal = sicmapp.gui.get_pseudo_modal(menu, [300, 400]);
            g = uigridlayout(modal, [1,1], 'Padding', 0);
            sel = phutils.gui.R2020b.ColormapSelector(g, 'Axes', self.Axes);
            modal.Visible = 'on';
        end
        function on_edit_colormap(self, menu, data)
            f = sicmapp.gui.get_figure_handle(menu);
            f.HandleVisibility='on';
            

            colormapeditor
        end
        function on_upd_cm(self, prop, data)
            self.Axes.Colormap = data.AffectedObject.Colormap;
            
            
        end
        function on_toggle_menu(self, menu, data)
            menu.Checked = ~menu.Checked;
        end
        function on_interpolate_surface(self, menu, data)
            menu.Checked = ~menu.Checked;
            if menu.Checked
                self.Axes.Children(1).FaceColor = 'interp';
            else
                self.Axes.Children(1).FaceColor = 'flat';
            end
        end
        
        function on_aspect_ratio(self, menu, data)
            f = sicmapp.gui.get_pseudo_modal(menu, [500,300]);
            g = uigridlayout(f, [2,2], 'RowHeight', {'1x', 32});
            oldMode = self.Axes.DataAspectRatioMode;
            oldZ = self.Axes.DataAspectRatio(3);
            editor = sicmapp.gui.AxesDataAspectRatioEdit(g, 'Axes', self.Axes);
            editor.Layout.Column = [1 2];
            f.Visible = 'on';
            waitfor(f);
        end
        function on_properties_selected(self, menu, data)
            
            if isempty(self.PropWindow) || ~isvalid(self.PropWindow)
                self.PropWindow = uifigure('Name', sprintf('Properties of %s', self.Panel.Title), 'Visible', 'off');
                g = uigridlayout(self.PropWindow, [1,1], 'Padding', 0);
                sicmapp.gui.SICMScanPropertyTable(g, 'AllowSelection', true, 'SelectionFieldLabel', 'Add to Results table', 'Value', self.Value);
                
            else
                figure(self.PropWindow);
            end
            self.PropWindow.Visible = 'on';
        end
        
        function makeInterfaceMenu(self, menu, measmenu)
            if ~isempty(self.SICMScanInterface) && isstruct(self.SICMScanInterface) 
                if isfield(self.SICMScanInterface, 'meth') 
                    meth = self.SICMScanInterface.meth;
                    mstr = struct();
                    for k = meth
                        item = k{1};
                        if isfield(item, 'Menu')
                            menuname = matlab.lang.makeValidName(item.Menu);
                            if ~isfield(mstr, menuname)
                                mstr.(menuname) = uimenu(menu, 'Text', sprintf('%s...', item.Menu));
                            end
                            curr = mstr.(menuname);
                        else
                            curr = menu;
                        end
                        if iscell(item.Name)
                            for l = 1:numel(item.Name)
                                item.Index = l;
                                uimenu(curr, 'Text', item.Name{l}, 'UserData', item, ...
                                    'MenuSelectedFcn', @self.call_interface);
                            end
                        else
                            uimenu(curr, 'Text', item.Name, 'UserData', item, ...
                                'MenuSelectedFcn', @self.call_interface);
                        end
                    end
                end
                if isfield(self.SICMScanInterface, 'meas') 
                    meas = self.SICMScanInterface.meas;
                    mstr = struct();
                    for k = meas
                        item = k{1};
                        if isfield(item, 'Menu')
                            menuname = matlab.lang.makeValidName(item.Menu);
                            if ~isfield(mstr, menuname)
                                mstr.(menuname) = uimenu(measmenu, 'Text', sprintf('%s...', item.Menu));
                            end
                            curr = mstr.(menuname);
                        else
                            curr = measmenu;
                        end
                        if iscell(item.Name)
                            for l = 1:numel(item.Name)
                                item.Index = l;
                                uimenu(curr, 'Text', item.Name{l}, 'UserData', item, ...
                                    'MenuSelectedFcn', @self.call_interface);
                            end
                        else
                            uimenu(curr, 'Text', item.Name, 'UserData', item, ...
                                'MenuSelectedFcn', @self.call_interface);
                        end
                    end
                end
            end
        end
        
        
        function call_interface(self, menu, data)
            udata = menu.UserData;
            call = udata.file;
            fixedArgs = {};
            varArgs = {};
            if iscell(udata.Name)
                if isfield(udata, 'Index')
                    index = udata.Index;
                    fixedArgs = udata.FixedArgs{index};
                    if isfield(udata, 'VarArgs') && isstruct(udata.VarArgs{index}) ...
                            && numel(fieldnames(udata.VarArgs{index})) > 0
                        
                        varArgs = self.getVarArgs(udata.VarArgs{index});
                    end
                else
                    error('SICMSingleDataDisplay:IncorrectData', 'I need an index to call the method.');
                end
            else
                
                if isfield(udata, 'FixedArgs')
                    fixedArgs = udata.FixedArgs;
                end
                
                if isfield(udata, 'VarArgs') && isstruct(udata.VarArgs) && numel(fieldnames(udata.VarArgs)) > 0
                    varArgs = self.getVarArgs(udata.VarArgs);
                end
            end
            if iscell(varArgs)
                allArgs = [fixedArgs(:)', varArgs(:)'];
                self.Value.(call)(allArgs{:});
                if any(strcmp(udata.Changes, {'x'})) || any(strcmp(udata.Changes, 'y')) || any(strcmp(udata.Changes, 'z'))
                    self.replot();
                end
                notify(self, 'ValueChanged');
            end
        end
        
        function v = getVarArgs(self, varArgs)
            rows = numel(varArgs) * 2;
            h = 20+32*(rows + 1); 
            self.Modal = sicmapp.gui.get_pseudo_modal(self,[300,h]);
            rh = cell(1,rows+2);
            rh(:) = {22};
            rh(end-1) = {32};
            rh(end) = {'1x'};
            self.TmpVarArgs = cell(1,numel(varArgs));
            
            g = uigridlayout(self.Modal, [rows+2, 1], 'RowHeight', rh);
            
            for k = numel(varArgs)
                if numel(varArgs) == 1
                    argdef = varArgs;
                else
                    argdef = varArgs{k};
                end
                uilabel(g, 'Text', argdef.desc);
                switch argdef.type
                    case 'int'
                        ef = uieditfield(g, 'numeric', ...
                            'Limits', [1, Inf], ...
                            'RoundFractionalValues', 'on', ...
                            'ValueChangedFcn', @(obj, data) self.modal_set_value(obj, data, k));
                        self.TmpVarArgs{k} = ef.Value;
                end
            end
            bg = uigridlayout(g, [1,2], 'Padding', 0);
            uibutton(bg, 'Text', 'Okay', 'ButtonPushedFcn', @(obj, data) self.modal_okay);
            uibutton(bg, 'Text', 'Cancel', 'ButtonPushedFcn', @(obj, data) self.modal_cancel);
            
            self.Modal.Visible = 'on';
            uiwait(self.Modal);
            
            v = self.TmpVarArgs;
            
        end
        function modal_set_value(self, obj, data, idx)
        	if isa(obj, 'matlab.ui.control.NumericEditField')
            	self.TmpVarArgs{idx} = data.Value;
            end
        end
        function modal_cancel(self)
            self.TmpVarArgs = false;
        	delete(self.Modal);
        end
        function modal_okay(self)
            delete(self.Modal);
        end
            
        function on_set_ax_interaction(self, menu, data)
            if ~menu.Checked 
                self.Axes.Interactions = [menu.UserData];
                parent = menu.Parent;
                for child = parent.Children'
                    child.Checked = false;
                end
                menu.Checked = true;
            else
                self.Axes.Interactions = [];
                parent = menu.Parent;
                for child = parent.Children'
                    child.Checked = false;
                end
            end
        end
        
        function on_toggle_content(self, src, ~)
            switch src.Checked
                case 'off'
                    for content = self.Axes.Children
                        content.Visible = 'off';
                    end
                    src.Checked = 'on';
                case 'on'
                    for content = self.Axes.Children
                        content.Visible = 'on';
                    end
                    src.Checked = 'off';
            end
        end
        function on_toggle_axvis(self, src, ~)
            switch src.Checked
                case 'off'
                    self.Axes.Visible = 'off';
                    src.Checked = 'on';
                case 'on'
                    self.Axes.Visible = 'on';
                    src.Checked = 'off';
            end
        end
        
        
        function on_toggle_zratiomode(self, src, ~)
            switch src.Value
                case 'on'
                    self.Axes.DataAspectRatioMode = 'auto';
                case 'off'
                    self.Axes.DataAspectRatioMode = 'manual';
            end
        end
        
        function on_select_displaytype(self, src, data, dtype)
            % One cannot set "no display type", thus only respond to clicks
            % on unchecked menu items
            if ~src.Checked
                par = src.Parent;
                for child = par.Children'
                    child.Checked = false;
                end
                src.Checked = true;
                
                % Does this trigger a redraw? Yes, it does.
                self.DisplayType = dtype;
                
            end
        end
        function on_ax_update(self, ax, data)
            notify(self, 'AxPropsChanged');
        end
    end
end