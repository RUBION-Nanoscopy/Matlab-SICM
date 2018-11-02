function varargout = generate_xygrids_(self, varargin)
% Helper function: Generate (interpolated) x- and y-grids
%
%    Examples: 
%      self.generate_xygrids_()
%   
%        Generates the x- and y-data grids of the object `self`. It considers 
%        self.stepx and self.stepy, if available, otherwise uses a step 
%        size of 1 (corresponding to values as pixels numbers). This also
%        updates xdata_lin and ydata_lin.
%
%      [xg, yg] = self.generate_xygrids_()
%
%        As above, but instead of changing the object `self`, it returns
%        the grids.
%
%      [xg, yg] = self.generate_xygrids_(interp)
%
%        As above, but the grids are interpolated. Instead of generating a
%        grid with spacing 1, the spacing is 1/interp

    interp = 1;
    if nargin > 1
        interp = varargin{1};
    end
    stepx_ = self.stepx;
    stepy_ = self.stepy;
    if isnan(stepx_)
        stepx_ = 1;
    end
    if isnan(stepy_)
        stepy_ = 1;
    end
    
    xoff = 0;
    yoff = 0;
    if ~isnan(self.xdata_lin)
        xoff = min(self.xdata_lin);
    end
    if ~isnan(self.ydata_lin)
        yoff = min(self.ydata_lin);
    end
    
    [xg, yg] = meshgrid((0:1/interp:self.xpx-1)*stepx_, (0:1/interp:self.ypx-1)*stepy_);
    xg = xg' + xoff;
    yg = yg' + yoff;
    if nargout == 0
        self.xdata_grid = xg;
        self.ydata_grid = yg;
        self.xdata_lin = xg(:);
        self.ydata_lin = yg(:);
    else
        varargout{1}=xg;
        varargout{2}=yg;
    end
end