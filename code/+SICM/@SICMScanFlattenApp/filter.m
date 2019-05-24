function filter ( self, filter, varargin)
    switch filter
        case 'median'
            scan = self.Scan.filter('median', varargin{:});
        case 'mean'
            scan = self.Scan.filter('mean', varargin{:});
    end
    
    self.Result = scan.zdata_grid;
end