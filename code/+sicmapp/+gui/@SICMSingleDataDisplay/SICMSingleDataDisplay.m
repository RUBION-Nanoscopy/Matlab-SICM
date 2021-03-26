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
    

    
    properties (Access = protected, Transient, NonCopyable)
        %NumericField (1,4) matlab.ui.control.NumericEditField
        Grid matlab.ui.container.GridLayout
        
        Axes matlab.ui.control.UIAxes
        Panel matlab.ui.container.Panel
        Modal matlab.ui.Figure
        TopoMenuStructure
        TmpVarArgs
        OnUpdateAdjustCLim matlab.ui.container.Menu
        OnUpdateAdjustCRange matlab.ui.container.Menu
        OnUpdateAdjustZLim matlab.ui.container.Menu
        OnUpdateAdjustZRange matlab.ui.container.Menu
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
        
        function replot(self)
           
            
            switch self.DisplayType
                case sicmapp.gui.SICMDataDisplayTypes.HEIGHT3D
                    self.Axes.NextPlot = 'replacechildren';
                    s = [];
                    if ~isempty(self.Axes.Children)
                        for child = self.Axes.Children'
                            if isa(child, 'matlab.graphics.primitive.Surface')
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
                    
                    s = self.Value.plot(self.Axes);
                    
                    self.prepareAxes(s, crange, zrange);
                    
                case sicmapp.gui.SICMDataDisplayTypes.HEIGHT2D
                    imagesc(self.Axes, self.Value.zdata_grid);
                	
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
            self.Axes.Interactions = [];    
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
            self.Axes.DataAspectRatioMode = 'manual';
            xratio = self.Value.xsize / self.Value.xpx;
            yratio = self.Value.ysize / self.Value.ypx;
            ratio = max(yratio, xratio);
            zrange = max(self.Value.zdata_lin) - min(self.Value.zdata_lin); 
            self.Axes.DataAspectRatio = [1 1 (zrange*ratio)];
            self.Axes.Toolbar = [];
            self.addTopoMenu();

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
            fig = sicmapp.gui.get_figure_handle(self);
            
            self.cleanMenu(fig);
            % Interaction menu
            imenu = uimenu(fig, 'Text', 'Plot interaction', ...
                'UserData', struct('IsMajorMenu', false));
            
            uimenu(imenu, 'Text', 'Rotate', 'Checked', true, ...
                'MenuSelectedFcn', @(el, data)self.on_set_ax_interaction(el, data, rotateInteraction));
            uimenu(imenu, 'Text', 'Pan', 'Checked', false, ...
                'MenuSelectedFcn', @(el, data)self.on_set_ax_interaction(el, data, panInteraction));
            uimenu(imenu, 'Text', 'Zoom', 'Checked', false, ...
                'MenuSelectedFcn', @(el, data)self.on_set_ax_interaction(el, data, zoomInteraction));
            
            viewmenu = uimenu(fig, 'Text', 'View', ...
                'UserData', struct('IsMajorMenu', false));
            uimenu(viewmenu, 'Text', 'Hide axis content', 'Checked', false,...
                'MenuSelectedFcn', @self.on_toggle_content);
            uimenu(viewmenu, 'Text', 'Hide axes', 'Checked', false, ...
                'MenuSelectedFcn', @self.on_toggle_axvis);
            updview = uimenu(viewmenu, 'Text', 'When updated...');
            
            self.OnUpdateAdjustCLim = uimenu(updview, 'Text', 'Auto-adjust Color Limits', 'Checked', 'on');
            self.OnUpdateAdjustCRange = uimenu(updview, 'Text', 'Auto-adjust Color Range', 'Checked', 'on');
            self.OnUpdateAdjustZLim = uimenu(updview, 'Text', 'Auto-adjust z-Limits', 'Checked', 'on');
            self.OnUpdateAdjustZRange = uimenu(updview, 'Text', 'Auto-adjust z-Range', 'Checked', 'on');
            uimenu(viewmenu, 'Text', 'Restore view', 'Separator', 'on');
            modemenu = uimenu(viewmenu, 'Text', 'Mode...');
            uimenu(modemenu, 'Text', '3D', 'Checked', true, ...
                'MenuSelectedFcn', @(src, data) self.on_select_displaytype(src, data, sicmapp.gui.SICMDataDisplayTypes.HEIGHT3D));
            uimenu(modemenu, 'Text', '2D', 'Checked', false, ...
                'MenuSelectedFcn', @(src, data) self.on_select_displaytype(src, data, sicmapp.gui.SICMDataDisplayTypes.HEIGHT2D));
            uimenu(modemenu, 'Text', 'Slope', 'Checked', false, ...
                'MenuSelectedFcn', @(src, data) self.on_select_displaytype(src, data, sicmapp.gui.SICMDataDisplayTypes.SLOPE));
            
            uimenu(viewmenu, 'Text', 'Aspect ratio', 'Separator', 'on');
            
            manipulate = uimenu(fig, 'Text', 'Manipulate data', 'UserData', struct('IsMajorMenu', false));
            
            self.makeInterfaceMenu(manipulate);
            
            notify(self, 'MenuChanged');
        end
        
        function makeInterfaceMenu(self, menu)
            if ~isempty(self.SICMScanInterface) && isstruct(self.SICMScanInterface) && isfield(self.SICMScanInterface, 'meth')
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
                    if isfield(udata, 'VarArgs') && ~isempty(udata.VarArgs)
                        varArgs = self.getVarArgs(udata.VarArgs{index});
                    end
                else
                    error('SICMSingleDataDisplay:IncorrectData', 'I need an index to call the method.');
                end
            else
                
                if isfield(udata, 'FixedArgs')
                    fixedArgs = udata.FixedArgs;
                end
                
                if isfield(udata, 'VarArgs') && ~isempty(udata.VarArgs)
                    varArgs = self.getVarArgs(udata.VarArgs);
                end
            end
            if iscell(varArgs)
                allArgs = [fixedArgs(:)', varArgs(:)'];
                self.Value.(call)(allArgs{:});
                if any(strcmp(udata.Changes, {'x', 'y', 'z'}))
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
            
        function on_set_ax_interaction(self, menu, data, action)
            if ~menu.Checked 
                self.Axes.Interactions = [action];
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