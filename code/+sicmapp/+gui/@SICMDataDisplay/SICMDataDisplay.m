classdef SICMDataDisplay < matlab.ui.componentcontainer.ComponentContainer
    properties
        Value
        SICMScanInterface
    end
    events (HasCallbackProperty, NotifyAccess = protected)
        ValueChanged % ValueChangedFcn callback property will be generated
        MenuChanged % Fired when the figure menu has been changed
        
    end

    
    properties (Access = protected, Transient, NonCopyable)
        %NumericField (1,4) matlab.ui.control.NumericEditField
        Grid matlab.ui.container.GridLayout
        Displays sicmapp.gui.SICMSingleDataDisplay
    end
    methods (Access = protected)
        function setup(self)
            self.Grid = uigridlayout(self, [1,1]);
        end
        function update(self)
            if ~isempty(self.Value)
                nData = 0;
                for val_idx = 1:numel(self.Value)
                    node = self.Value(val_idx);
                    nData = nData + length(node.NodeData.SelectedContentType);
                end
                nRows = ceil(sqrt(nData));
                cRows = cell(nRows, 1);
                cRows(:) = {'1x'};
                self.Grid.RowHeight = cRows;
                self.Grid.ColumnWidth = cRows;
                % empty grid
                delete(self.Grid.Children);
                self.Displays = sicmapp.gui.SICMSingleDataDisplay.empty();
                count = 0;
                for val_idx = 1:numel(self.Value)
                    
                    node = self.Value(val_idx);
                    
                    for cn_idx = 1:numel(node.NodeData.SelectedContentType)
                    	count = count+1;
                        scan = node.NodeData.Scan(cn_idx);
                        self.Displays(count) = sicmapp.gui.SICMSingleDataDisplay(...
                            self.Grid, 'Title', node.Text, ...
                            'AxPropsChangedFcn', @(~,~)self.on_axprops_changed(count, node, cn_idx), ...
                            'MenuChangedFcn', @self.bubble_menu_changed, ...
                            'SICMScanInterface', self.SICMScanInterface);
                        
                        if isfield(node(cn_idx).NodeData, 'AxProps')
                            self.Displays(count).AxProps = node(cn_idx).NodeData.AxProps;
                        end
                        self.Displays(count).Value = scan;
                        node(cn_idx).NodeData.AxProps = self.Displays(count).AxProps;
                    end
                end
            end
        end
        
        function on_axprops_changed(self, count, node, cn_idx)
            node(cn_idx).NodeData.AxProps = self.Displays(count).AxProps;
        end
        
        function bubble_menu_changed(self, obj, varargin)
            notify(self, 'MenuChanged');
        end
    end
end