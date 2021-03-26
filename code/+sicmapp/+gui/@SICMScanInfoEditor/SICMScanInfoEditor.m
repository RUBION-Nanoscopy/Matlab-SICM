classdef SICMScanInfoEditor < matlab.ui.componentcontainer.ComponentContainer
    properties
        Value SICM.SICMScan
    end
	events (HasCallbackProperty, NotifyAccess = protected)
        ValueChanged % ValueChangedFcn callback property will be generated
    end

    
    properties (Access = protected, Transient, NonCopyable)
        
        Grid matlab.ui.container.GridLayout
        UpperGrid matlab.ui.container.GridLayout
        Tables matlab.ui.control.Table
        TabGroup matlab.ui.container.TabGroup
        Tabs matlab.ui.container.Tab
        TopoInfo matlab.ui.control.Label
        FluoInfo matlab.ui.control.Label
        OtherInfo matlab.ui.control.Label
        MapInfo matlab.ui.control.Label
        FileName matlab.ui.control.Label
        ExistsInfo matlab.ui.control.Label
        LastModified matlab.ui.control.Label
        
        
    end
    
    methods (Access = protected)
        function setup(self)
            self.Grid = uigridlayout(self, [2,1], ...
                'Padding', 0, ...
                'RowHeight', {'fit', '1x'});
            p = uipanel(self.Grid, 'Title', 'General Information');
            self.UpperGrid = uigridlayout(p, [7,2], ...
                'Padding', 10, ...
                'RowHeight', {22, 22, 22, 22, 22, 22, 22}, ...
                'RowSpacing', 2, ...
                'ColumnWidth', {200, '1x'}...
                );
            uilabel(self.UpperGrid, 'Text', 'Filename:', 'FontWeight', 'bold');
            self.FileName = uilabel(self.UpperGrid, 'Text', '');
            uilabel(self.UpperGrid, 'Text', 'File exists on disk?', 'FontWeight', 'bold');
            self.ExistsInfo = uilabel(self.UpperGrid, 'Text', '');
            uilabel(self.UpperGrid, 'Text', 'Last modification:', 'FontWeight', 'bold');
            self.LastModified = uilabel(self.UpperGrid, 'Text', '');
            uilabel(self.UpperGrid, 'Text', 'File contains topography?', 'FontWeight', 'bold');
            self.TopoInfo = uilabel(self.UpperGrid, 'Text', '');
            uilabel(self.UpperGrid, 'Text', 'Number of fluorescence images', 'FontWeight', 'bold');
            self.FluoInfo = uilabel(self.UpperGrid, 'Text', '');
            uilabel(self.UpperGrid, 'Text', 'Number of other images', 'FontWeight', 'bold');
            self.OtherInfo = uilabel(self.UpperGrid, 'Text', '');
            uilabel(self.UpperGrid, 'Text', 'Contains resolution map', 'FontWeight', 'bold');
            self.MapInfo = uilabel(self.UpperGrid, 'Text', '');
            self.TabGroup = uitabgroup(self.Grid);
            
        end
        function update(self)
            if ~isempty(self.Value)
                if ~isempty(self.Value.zdata_grid)
                    tfTopo = true;
                    self.TopoInfo.Text = "Yes";
                else
                    tfTopo = false;
                    self.TopoInfo.Text = "no (huh?)";
                end
                if ~isempty(self.Value.info)
                    if isfield(self.Value.info, 'filename')
                        fn = self.Value.info.filename;
                        self.FileName.Text = fn;
                        if exist(fn, 'file')
                            self.ExistsInfo.Text = 'Yes';
                            listing = dir(fn);
                            modTime = listing.datenum;
                            self.LastModified.Text = datestr(modTime);
                        else
                            self.ExistsInfo.Text = 'No';
                            self.LastModified.Text = 'unknown';
                        end
                    else
                        self.FileName.Text = 'unknown';
                        self.ExistsInfo.Text = 'of course not';
                        self.LastModified.Text = 'unknown';
                    end
                end
                if ~isprop(self.Value, 'FluorescenceImages')
                    nFluo = 0;
                else 
                    nFluo = numel(self.Value.FluorescenceImages);
                end
                self.FluoInfo.Text = num2str(nFluo);
                if ~isprop(self.Value, 'OtherImages')
                    nOther = 0;
                else
                    nOther = numel(self.Value.OtherImages);
                end
                self.OtherInfo.Text = num2str(nOther);
                
                if ~isprop(self.Value, 'ResolutionMap')
                    tfMap = false;
                else
                    if numel(self.Value.ResolutionMap) > 0
                        tfMap = true;
                    else
                        tfMap = false;
                    end
                end
                if tfMap
                    self.MapInfo.Text = "Yes";
                else
                    self.MapInfo.Text = "No";
                end
                
                % make Tabs
                for tab = self.Tabs
                    delete(tab);
                end
                for table = self.Tables
                    delete(table);
                end
                self.Tabs = matlab.ui.container.Tab.empty();
                self.Tables = matlab.ui.control.Table.empty();
                if tfTopo
                    self.makeTopoTab()
                end
                if tfMap
                    self.makeMapTab();
                end
                for k = 1:nFluo
                    self.makeFluoTab(k);
                end
                for k = 1:nOther
                    self.makeOtherTab(k);
                end
                
            end
            
            
        end
        function makeTopoTab(self)
            self.Tabs(end+1) = uitab(self.TabGroup, 'Title', 'Topography');
            grid = uigridlayout(self.Tabs(end), [1,1], 'Padding', 0);
            
            if isnan(self.Value.starttime)
                starttime = "-";
            
            elseif isdatetime(self.Value.starttime)
                starttime = datestr(self.Value.starttime);
            
            else
                starttime = num2str(self.Value.starttime);
            
            end
            if isnan(self.Value.endtime)
                endtime = "-";
            
            elseif isdatetime(self.Value.endtime)
                endtime = datestr(self.Value.endtime);
            
            else
                endtime = num2str(self.Value.endtime);
            
            end 
            values= {...
                self.Value.xsize; ...
                self.Value.ysize; ...
                self.Value.xpx; ...
                self.Value.ypx; ...
                starttime; ...
                endtime; ...
                self.Value.duration ...
            };
            
            fnames = ["X-Size/µm"; "Y-Size/µm"; "Pixels in x"; 
                "Pixels in y"; "Start time"; "End time"; "Duration"];
            
            noeditstyle = uistyle('FontColor','#666666');
            for fn = fieldnames(self.Value.info)'
                fname = fn{1};
                if strcmpi(fname, 'filename')
                    continue
                end
                fnames(end+1) = string(fname);
                values{end+1} = self.Value.info.(fname);
            end
            fnames(end+1) = "";
            values{end+1} = "";
            tbl = table(fnames, values);
            tbl.Properties.VariableNames = {'Field','Value'};
            
            self.Tables(end+1) = uitable(grid, 'Data', table2array(tbl), ...
                'ColumnEditable', [true, true], ...
                'CellEditCallback', @self.on_cell_edit,...
                'ColumnName', ["Fieldname", "Value"], ...
                'UserData', struct(...
                    'NonEditableRows', 1:7, ...
                    'StructToEdit', 'info', ...
                    'StructToEditIndex', 1 ...
            ));
            addStyle(self.Tables(end), noeditstyle, 'row', 1:7);
            
        end
        
        function on_cell_edit(self, table, data)
            row = data.Indices(1);
            col = data.Indices(2);
            if ~isempty(table.UserData) && isstruct(table.UserData) && isfield(table.UserData, 'NonEditableRows')
                if any(table.UserData.NonEditableRows == row)
                    table.Data(row, col) = data.PreviousData;
                    uialert(sicmapp.gui.get_figure_handle(table), 'You cannot edit this value', 'Protected value');
                    return;
                end
            end
            
            isfieldname = col == 1;
            if isfieldname
                [validfieldname, changed] = matlab.lang.makeValidName(data.NewData);
                table.Data(row, col) = validfieldname;
                if sum(strcmpi(table.Data(:,1), validfieldname)) > 1
                    if ~changed
                        uialert(sicmapp.gui.get_figure_handle(table), 'The fieldname needs to be unique.', 'Invalid input');
                    else
                        uialert(sicmapp.gui.get_figure_handle(table), 'I had to change the fieldname to be valid, but this fieldname already exists.', 'Invalid input');
                    end
                    table.Data(row, col) = data.PreviousData;
                    return;
                end
                if changed
                    uialert(sicmapp.gui.get_figure_handle(table), 'The fieldname needs to be a valid MATLAB identifier. I have changed it.', 'Invalid input');
                    
                end
                value = table.Data(row, 2);
                datasize = size(table.Data);
                islast = row == datasize(1);
                if islast
                    table.Data(end+1, :) = ["", ""];
                end
            else
                validfieldname = table.Data(row, 1);
                value = data.NewData;
                if strcmp("", validfieldname)
                    uialert(sicmapp.gui.get_figure_handle(table), 'Please enter the fieldname first.', 'Invalid input.');
                    table.Data(row, col) = data.PreviousData;
                    return
                end
            end
            propname = table.UserData.StructToEdit;
            if isprop(self.Value, propname) 
                if isstruct(self.Value.(propname))
                    self.Value.(propname).(validfieldname) = value;
                    eventData = SICM.SICMScanChangedData(propname, false);
                    notify(self, 'ValueChanged', eventData);
                else 
                    
                end
            end
            
            
        end
    end
end