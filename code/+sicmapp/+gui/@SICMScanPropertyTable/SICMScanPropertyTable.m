classdef SICMScanPropertyTable < matlab.ui.componentcontainer.ComponentContainer
    properties
        Value
        SICMScanInterface
        AllowSelection (1,1) logical = true
        SelectedValues = {}
        SelectionFieldLabel = "Select"
    end
    properties (GetAccess = public, SetAccess = protected)
        SelectedData = {};
    end
    events (HasCallbackProperty, NotifyAccess = protected)
        ValueChanged % ValueChangedFcn callback property will be generated
        SelectionChanged 
        
    end
    
    
    properties  (Access = protected, Transient, NonCopyable)
        Grid matlab.ui.container.GridLayout
        Table matlab.ui.control.Table
        UpdBtn matlab.ui.control.Button
        DirtyListener
    end
    
    methods
        function delete(self)
            if ~isempty(self.DirtyListener)
                delete(self.DirtyListener);
            end
            delete@matlab.ui.componentcontainer.ComponentContainer(self);
        end
    end
    methods (Access = protected)
        function setup(self)
            if isempty(self.SICMScanInterface)
                self.SICMScanInterface = SICM.SICMScan().getInterfaceInformation();
            end
            self.Grid = uigridlayout(self, [2,1], 'Padding', 0, 'RowHeight', {22,'1x'});
            self.UpdBtn = uibutton(self.Grid, 'Text', 'Update', 'Enable', 'off', 'ButtonPushedFcn', @(~,~)self.recalc);
            self.Table = uitable(self.Grid, 'CellEditCallback', @self.on_cell_edit);
        end
        function update(self)
            if ~isempty(self.DirtyListener)
                delete(self.DirtyListener)
            end
            if ~isempty(self.Value)
                self.DirtyListener = addlistener(self.Value, 'IsDirty', 'PostSet', @(~,~)self.recalc());
            end
            if ~isempty(self.Value) && isempty(self.Table.Data)
                propsDef = self.SICMScanInterface.prop;
                nProps = numel(propsDef);
                if self.AllowSelection
                    nData = 4;
                else
                    nData = 3;
                end
                data = cell(nProps, nData);
                rownames = cell(1,nProps);
                for k = 1:nProps
                    pr = propsDef{k};
                    rownames{k} = pr.Name;
                    data{k,1} = logical(pr.Immediate);
%                     if pr.Immediate
%                         data{k,2} = self.Value.(pr.file)();
%                     else
%                         data{k,2} = [];
%                     end
                    data{k,3} = self.get_unit(pr);
                    
                    if self.AllowSelection
                        data{k,4} = false;
                    end
                end

                self.Table.Data = data;
                self.Table.RowName = rownames;
                if self.AllowSelection
                    self.Table.ColumnName = {'Compute', 'Value', 'Units', self.SelectionFieldLabel};
                    self.Table.ColumnEditable = [true, false, false, true];
                else
                    self.Table.ColumnName = {'Compute', 'Value', 'Units'};
                    self.Table.ColumnEditable = [true, false, false];
                end
                self.recalc();
            end
            
        end
        
        function recalc(self)
            if ~isempty(self.Table.Data) && ~isempty(self.SICMScanInterface)
                sz = size(self.Table.Data);
                for row = 1:sz(1)
                    
                    if self.Table.Data{row, 1}
                        self.Table.Data{row, 2} = self.Value.(self.SICMScanInterface.prop{row}.file)();
                        
                        self.Table.Data{row,3} = self.get_unit(self.SICMScanInterface.prop{row});
                    end
                end
            end
        end
        
        function on_cell_edit(self, tab, data)
            isImmediate = data.Indices(2) == 1;
            if isImmediate
                self.recalc();
                return
            end
            if self.AllowSelection
                c = {};
                sz = size(self.Table.Data);
                for k = 1:sz(1)
                    if self.Table.Data{k, 4}
                        c{end+1} = {self.Table.RowName{k}, ...
                            self.Table.Data{k,2}, ...
                            self.Table.Data{k,3}};
                    end
                    self.SelectedData = c;
                    notify(self, 'SelectionChanged');
                end
            end
        end
        
        function u = get_unit(self, pr)
            if ~isfield(pr, 'Unit')
                u = '';
                return;
            end
            u = pr.Unit;
            if ~isempty(self.Value.UnitX)
                u = strrep(u, '[x]', self.Value.UnitX);
            end
            if ~isempty(self.Value.UnitY)
                u = strrep(u, '[y]', self.Value.UnitY);
            end
            if ~isempty(self.Value.UnitZ)
                u = strrep(u, '[z]', self.Value.UnitZ);
            end
        end
    end
    
end
