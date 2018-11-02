function generateTabs(self)
    t = struct();
    l = self.gui.layout;
    t.series = uipanel( 'Parent', l.tabInfo );
    d = local_getDataForScanTable(self);
    uitable( t.series, ...
        'RowName', {'Volume'}, ...
        'Data' , d);
    t.scan = uipanel( 'Parent', l.tabInfo );
    t.app = uipanel( 'Parent', l.tabInfo );
    l.tabInfo.TabTitles = {'Series', 'Scan', 'AppCurve'};
    l.tabInfo.TabWidth=100;
    self.gui.tabs = t;
end

function d = local_getDataForScanTable( obj )
    if isfield ( obj.data, 'Scan' )
        s = obj.data.scan;
        d = [s.volume()];
    else
        d = [NaN];
    end
end