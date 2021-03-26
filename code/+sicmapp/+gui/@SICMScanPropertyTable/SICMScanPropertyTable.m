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
        SelectedDataChanged 
        
    end
    properties  (Access = protected, Transient, NonCopyable)
        Grid matlab.ui.container.GridLayout
        Table matlab.ui.control.Table
        UpdBtn matlab.ui.control.Button
        
    end
    methods (Access = protected)
        function setup(self)
            if isempty(self.SICMScanInterface)
                self.SICMScanInterface = SICM.SICMScan().getInterfaceInformation();
            end
            self.Grid = uigridlayout(self, [2,1], 'Padding', 0, 'RowHeight', {22,'1x'});
            self.UpdBtn = uibutton(self.Grid, 'Text', 'Update', 'Enable', 'off', 'ButtonPushedFcn', @(~,~)self.recalc);
            self.Table = uitable(self.Grid);
        end
        function update(self)
            if ~isempty(self.Value)
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
                    if pr.Immediate
                        data{k,2} = self.Value.(pr.file)();
                    else
                        data{k,2} = [];
                    end
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
                
            end
            
        end
        
        function recalc(self)
            
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
