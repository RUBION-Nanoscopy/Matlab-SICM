function scaleY ( self, factor, varargin )
    data = self.ydata;
    if nargin > 2
        data = data - varargin{1};
    end
    data = data * factor;
    self.ydata = data;
end