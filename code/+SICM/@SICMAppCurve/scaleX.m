function scaleX ( self, factor, varargin )
    data = self.xdata;
    if nargin > 2
        data = data - varargin{1};
    end
    data = data * factor;
    self.xdata = data;
end