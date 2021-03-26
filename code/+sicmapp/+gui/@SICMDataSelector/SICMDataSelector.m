classdef SICMDataSelector < matlab.ui.componentcontainer.ComponentContainer
    % A tree with informarion about loaded SICM Scans
    properties
        Value matlab.ui.container.TreeNode
        Scans
        
    end
    events (HasCallbackProperty, NotifyAccess = protected)
        ValueChanged % ValueChangedFcn callback property will be generated
        ScansChanged 
    end

    
    properties (Access = protected, Transient, NonCopyable)
        %NumericField (1,4) matlab.ui.control.NumericEditField
        Grid matlab.ui.container.GridLayout
        Tree matlab.ui.container.Tree
        TreeNodes matlab.ui.container.TreeNode
        
    end
    methods (Access = protected)
        
        
        
        function setup(self)
            self.Grid = uigridlayout(self, [1, 1], 'Padding', 0);
            self.Tree = uitree(self.Grid, ...
                'Multiselect', 'on', ...
                'SelectionChangedFcn', @self.selection_changed);
        end
        function update(self)
            if ~isempty(self.Scans)
                toDelete = nan(size(self.TreeNodes));
                node2scanmap = nan(size(self.TreeNodes));
                scan_handles = cellfun(@(x) handle(x), self.Scans);
                for node_idx = 1:numel(self.TreeNodes)
                    node = self.TreeNodes(node_idx);
                    if ~ishandle(node)
                        continue; % might be a deleted one
                    end
                    % NoteData.Scan should(!) hold a copy of the scan
                    [~, idx] = find(scan_handles == handle(node.NodeData.Scan), 1, 'first');
                    if isempty(idx) 
                        % No scan for the node
                        toDelete(node_idx) = node_idx;
                    else
                        node2scanmap(node_idx) = idx;
                        % @TODO Maybe implement (re-)ordering here?!
                    end
                end
                % Every scan in node2scanmap has a corresponding node.
                % Process the remaining ones...
                lastNode = matlab.ui.container.TreeNode.empty();
                for scan_idx = 1:numel(self.Scans)
                    if ~any(node2scanmap == scan_idx)
                        lastNode(1) = self.addTreeNode(self.Scans{scan_idx});
                    end
                    % select the last added scan as current 
                    
                end
                % 
                if ~isempty(lastNode)
                    self.Value = lastNode(1);
                    self.Value.expand();
                    self.value_changed();
                    
                end
                
                for del_idx = toDelete(~isnan(toDelete))
                    delete(self.TreeNodes(del_idx));
                end
            else
                % Scans is empty, delete all TreeNodes
                delete(self.TreeNodes);
            end
                
        end
        
        function node = addTreeNode(self, scan)
            node = uitreenode(self.Tree);
            fname = scan.getInfo('filename', 'Data from unknown file');
            [~,f,~] = fileparts(fname);
            fname = f;
            count = 0;
            while strcmp([self.TreeNodes.Text], fname)
                count = count+1;
                fname = sprintf("%s (%g)", f, count);
            end
            node.Text = fname;
            node.NodeData = struct('Scan', scan);
            node.NodeData.IsSelected = false;
            % As long as SICM.SICMScan does not provide any tools for
            % multiple data sets in one file, let's assume the data is
            % topography. Add some information about this to the node:
            subnode = uitreenode(node, 'Icon', sicmapp.icons.SICMAppSVGIcons.SQUARECHECK.FileName);
            node.NodeData.ContentTypes = SICM.SICMContentTypes.TOPOGRAPHY;
            node.NodeData.SelectedContentType = 1;
            subnode.Text = sprintf('Topography (%gµm×%gµm@%ipx×%ipx)', ...
                scan.xsize, scan.ysize, scan.xpx, scan.ypx);
            subnode.NodeData = struct('Colormap', parula(256));
            
            
            node = self.decorateTreenode(node);
            
            
            self.TreeNodes(end+1) = node;
        end
        
        function node = decorateTreenode(self, node)
            % Context menu for node
            % get handle to figure
            f = self;
            while ~isa(f, 'matlab.ui.Figure')
                f = f.Parent;
            end
            node.Icon = sicmapp.icons.SICMAppSVGIcons.FOLDERCHECK.FileName;
            menu = uicontextmenu(f);
            info = uimenu(menu, 'Text', 'Show/Edit information', ...
                'MenuSelectedFcn', @(menu, data)self.on_nm_show_information(menu, data, node));
            delete = uimenu(menu, 'Text', 'Remove', ...
                'MenuSelectedFcn', @self.on_nm_remove_node);
            
            import = uimenu(menu, 'Text','Import...', 'Separator', 'on');
            m1 = uimenu(import, 'Text', 'Fluorescence Image', ...
                'MenuSelectedFcn', @self.on_nm_add_fluorescence);
            m2 = uimenu(import, 'Text', 'Other image',...
                'MenuSelectedFcn', @self.on_nm_add_other);
            m3 = uimenu(import, 'Text', 'Resolution map', ...
                'MenuSelectedFcn', @self.on_nm_add_map);
            export = uimenu(menu, 'Text', 'Export...');
            m4 = uimenu(export, 'Text', 'As new *.sicm file', ...
                'MenuSelectedFcn', @self.on_nm_exp_sicm);
            m4 = uimenu(export, 'Text', sprintf('Override %s.sicm', node.Text), ...
                'MenuSelectedFcn', @self.on_nm_exp_original);
            node.ContextMenu = menu;
            
        end
        
        % Callbacks for node menu
        function on_nm_show_information(self, menu, data, node)
            fig = sicmapp.gui.get_pseudo_modal(menu, [600, 400]);
            grid = uigridlayout(fig, [1,1]);
            fig.Name = 'Property Editor';
            info = sicmapp.gui.SICMScanInfoEditor(grid, ...
                'Value', node.NodeData.Scan, ...
                'ValueChangedFcn', @self.bubble_scans_changed);
            fig.Visible = 'on';
        end
        function on_nm_remove_node(self, node, data)
        end
        function on_nm_add_fluorescence(self, node, data)
        end
        function on_nm_add_other(self, node, data)
        end
        function on_nm_add_map(self, node, data)
        end
        function on_nm_exp_sicm(self, node, data)
        end
        function on_nm_exp_original(self, node, data)
        end
        % internal callbacks
        function selection_changed(self, tree, ~)
            % First,visually unselect all nodes
            
            for node = self.TreeNodes
                node.Icon = sicmapp.icons.SICMAppSVGIcons.FOLDER.FileName;
                for child = node.Children
                    child.Icon = sicmapp.icons.SICMAppSVGIcons.SQUARE.FileName;
                end
            end
            
            val = matlab.ui.container.TreeNode.empty();
            % one cannot select a parent node, only subnodes
            
            
            
            % since multiselect is allowed, tree.SelectedNodes might
            % contain more than one node. Loop through them
            
            
            for node_idx = 1:numel(tree.SelectedNodes)
                node = tree.SelectedNodes(node_idx);
                if any(self.TreeNodes == node)
                    % top level node was selected
                    val(end+1) = node;
                    node.Icon = sicmapp.icons.SICMAppSVGIcons.FOLDERCHECK.FileName;
                    % all subnodes are selected, too
                    for child = node.Children
                        child.Icon = sicmapp.icons.SICMAppSVGIcons.SQUARECHECK.FileName;
                    end
                    
                else
                    % subnode was selected 
                    val(end+1) = node.Parent;
                    node.Icon = sicmapp.icons.SICMAppSVGIcons.SQUARECHECK.FileName;
                    node.Parent.Icon = sicmapp.icons.SICMAppSVGIcons.FOLDERCHECK.FileName;
                    % 
                end
                
            end
            self.Value = unique(val);
            self.value_changed();
        end
        % internal value changed method
        function value_changed(self)
            % update the SelectedNodes prop of the tree
            selected  = matlab.ui.container.TreeNode.empty();
            if ~isempty(self.Value)
                for node = self.Value
                    selected(end+1) = node.Children(node.NodeData.SelectedContentType);
                end
            else
                
            end
            
            self.Tree.SelectedNodes = selected;
            notify(self, 'ValueChanged');
        end
        function bubble_scans_changed(self, ~, data)
            % simply bubbles value changed
            
            notify(self, 'ScansChanged', data);%, varargin{:});
        end
        
    end
end