classdef AxesDataAspectRatioEdit < matlab.ui.componentcontainer.ComponentContainer
    properties
        Axes (1,1) matlab.ui.control.UIAxes
    end
    properties  (Access = protected, Transient, NonCopyable)
        Grid matlab.ui.container.GridLayout
        Checkbox matlab.ui.control.CheckBox
        XEdit matlab.ui.control.NumericEditField
        XLabel matlab.ui.control.Label
        YEdit matlab.ui.control.NumericEditField
        YLabel matlab.ui.control.Label
        ZEdit matlab.ui.control.NumericEditField
        ZLabel matlab.ui.control.Label
    end
    methods (Access = protected)
        
        function setup(self)
            self.Grid = uigridlayout(self, [5,3], 'Padding', 0, 'RowHeight', {22,1,22,22,32, '1x'}, 'RowSpacing', 2);
            ig = uigridlayout(self.Grid, [1,2], 'Padding', 0, 'ColumnWidth', {'fit', '1x'});
            ig.Layout.Column = [1,3];
            uilabel(ig, 'Text', 'Use the automatic mode?');
            
            self.Checkbox = uicheckbox(ig, 'Text', '', 'ValueChangedFcn', @self.mode_value_changed);
            
            cbar = uigridlayout(self.Grid, [1,1], 'BackgroundColor', self.Grid.BackgroundColor * 0.9);
            cbar.Layout.Column = [1,3];
            self.XLabel =  uilabel(self.Grid, 'Text', sprintf('X-Size'));
            self.YLabel =  uilabel(self.Grid, 'Text', sprintf('Y-Size'));
            self.ZLabel =  uilabel(self.Grid, 'Text', sprintf('Z-Size'));
            self.XEdit = uieditfield(self.Grid, 'numeric', 'Limits', [0, Inf], ...
                'LowerLimitInclusive', false, ...
                'Tooltip', 'This number of units in z is displayed as the same visual length as one unit in x or y',...
                'ValueChangedFcn', @self.manual_value_changed ...
            );

            
            self.YEdit = uieditfield(self.Grid, 'numeric', 'Limits', [0, Inf], ...
                'LowerLimitInclusive', false, ...
                'Tooltip', 'This number of units in z is displayed as the same visual length as one unit in x or y',...
                'ValueChangedFcn', @self.manual_value_changed ...
            );
            
            self.ZEdit = uieditfield(self.Grid, 'numeric', 'Limits', [0, Inf], ...
                'LowerLimitInclusive', false, ...
                'Tooltip', 'This number of units in z is displayed as the same visual length as one unit in x or y',...
                'ValueChangedFcn', @self.manual_value_changed ...
            );
        end
        function update(self)
            if ~isempty(self.Axes)
                s = [];
                for child = self.Axes.Children'
                    
                    if isa(child, 'matlab.graphics.chart.primitive.Surface')
                        s = child;
                        break;
                    end
                end
                self.Checkbox.Value = strcmp(self.Axes.DataAspectRatioMode, 'auto');
                if self.Checkbox.Value
                    self.Checkbox.Text = 'yes';
                else
                    self.Checkbox.Text = 'no';
                end
                
                self.XEdit.Enable = ~self.Checkbox.Value;
                self.YEdit.Enable = ~self.Checkbox.Value;
                self.ZEdit.Enable = ~self.Checkbox.Value;
                self.XEdit.Value = self.Axes.DataAspectRatio(1);
                self.YEdit.Value = self.Axes.DataAspectRatio(2);
                self.ZEdit.Value = self.Axes.DataAspectRatio(3);
                if ~isempty(s)
                    self.XEdit.Tooltip = sprintf('Current range of XData: %g', max(s.XData(:)) - min(s.XData(:))); 
                    self.YEdit.Tooltip = sprintf('Current range of YData: %g', max(s.YData(:)) - min(s.YData(:)));
                    self.ZEdit.Tooltip = sprintf('Current range of ZData: %g', max(s.ZData(:)) - min(s.ZData(:)));
                else
                    self.XEdit.Tooltip = '';
                    self.YEdit.Tooltip = '';
                    self.ZEdit.Tooltip = '';
                end
                    
            end
        end
        
        function mode_value_changed(self, cb, data)
            if data.Value
                cb.Text = 'yes';
                self.Axes.DataAspectRatioMode = 'auto';
            else
                cb.Text = 'no';
                self.Axes.DataAspectRatioMode = 'manual';
            end
            self.XEdit.Enable = ~data.Value;
            self.YEdit.Enable = ~data.Value;
            self.ZEdit.Enable = ~data.Value;
        end
        function manual_value_changed(self, ed, data)
            switch ed
                case self.XEdit
                    idx = 1;
                case self.YEdit
                    idx = 2;
                case self.ZEdit
                    idx = 3;
            end
            self.Axes.DataAspectRatio(idx) = data.Value;
        end
    end
end