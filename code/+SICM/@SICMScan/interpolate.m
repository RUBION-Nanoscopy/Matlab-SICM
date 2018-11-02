function varargout = interpolate(self, steps, varargin)

% Interpolating the data using different methods
%
%    Examples: 
%      
%      obj.interpolate(steps, method)
%        
%        interpolate the data with 'steps' interpolation steps unsing
%        method 'method'. If 'method' is not provided, 'spline' is used as
%        default.
%
%      newobj = obj.interpolate(steps, method)
%
%        As above, but returns a new SICMScan object with the interpolated
%        data.
%
%  
% The methods available are can be found in the documentation of the 
% griddedInterpolant class of Matlab.
%
% SEE ALSO: griddedinterpolant

    if nargout == 1
        o = SICM.SICMScan.fromSICMScan_(self);
        o.interpolate(steps, varargin{:})
        varargout{1} = o;
        return
    end

    method = 'spline';

    if nargin == 3
        method = varargin{1};
    end

    if self.xdata_grid(1,1) == self.xdata_grid(2,1)
        F = griddedInterpolant(self.xdata_grid', self.ydata_grid', ...
            self.zdata_grid', method);
    else
        F = griddedInterpolant(self.xdata_grid, self.ydata_grid, ...
            self.zdata_grid, method);
    end
    min_x = min(self.xdata_lin);
    min_y = min(self.ydata_lin);
    max_x = max(self.xdata_lin);
    max_y = max(self.ydata_lin);
    [xg, yg] = ...
        meshgrid(min_x:self.stepx/steps:max_x, ...
                 min_y:self.stepy/steps:max_y);
    zg = F(xg', yg');
    self.zdata_grid = zg';
    self.xdata_grid = xg;
    self.ydata_grid = yg;
    self.upd_zlin_();
    self.xdata_lin = self.xdata_grid(:);
    self.ydata_lin = self.ydata_grid(:);

    self.xpx = length(min_x:self.stepx/steps:max_x);
    self.ypx = length(min_y:self.stepy/steps:max_y);
    self.stepx = self.xsize / self.xpx;
    self.stepy = self.ysize / self.ypx;
    
