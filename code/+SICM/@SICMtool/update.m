function update( self )
    local_updateApp( self.gui, self.handles, self.data );
    local_updateScan( self.gui, self.handles, self.data );
end

function local_updateScan( gui, handles,  data )
    if ~isfield (data, 'Scan')
        return
    end
    if isfield (handles, 'ScanAxes') && ishandle( handles.ScanAxes )
        delete( [allchild( handles.ScanAxes ) handles.ScanAxes] );
    end
    
    fig = figure('Visible','Off');
    data.Scan.surface();
    axis image;
    handles.ScanAxes = gca();
    set( handles.ScanAxes, 'Parent', gui.axes.ScanContainer);
    close(fig);
    
end

function local_updateApp( gui, handles, data )
    if ~isfield( data, 'App')
        return
    end

    if isfield (handles, 'AppAxes') && ishandle( handles.AppAxes )
        delete( [allchild( handles.AppAxes ) handles.AppAxes] );
    end
    fig = figure('Visible','Off');
    data.App.plot();
    handles.AppAxes = gca();
    set( handles.AppAxes, 'Parent', gui.axes.AppContainer);
    close(fig);
end
