function varargout = surface(self, varargin)
% Plots an (interpolated) 3D plot of the data. 
%
%    Example:
%      foo = SICMScan.FromExampleData;
%      surface(foo);
% 
%        Generates a plot of the example data in `foo`. 
%
%
%      surface(foo, 5);
% 
%        Generates a plot of the example data in `foo`, with 5
%        interpolation steps between the pixels.
%
%      You can pass optional arguments to the original surface-function,
%      however, in this case you have provide an interpolation:
%
%      surface(foo, 5, 'EdgeColor', [0 0 0]);
% 
%        Generates a plot of the example data in `foo`, with 5
%        interpolation steps between the pixels and a black EdgeColor.
%
%      surface(foo, 1, 'EdgeColor', [0 0 0]);
% 
%        Generates a plot of the example data in `foo` without
%        interpolation between the pixels and a black EdgeColor.

    interp = 1;
    start = 0;
    ax = gca;
    if nargin > 1
        if isa(varargin{1},'matlab.graphics.axis.Axes')
            ax = varargin{1};
            if nargin > 2
                interp = varargin{2};    
                start = 3;
            end
        else
            interp = varargin{1};
            start = 2;
        end
        
    end
    [xg, yg] = self.generate_xygrids_(interp);
    zg = self.zdata_grid;
    if interp > 1
        zg = griddata(self.xdata_lin,self.ydata_lin, self.zdata_lin, xg, yg);
    end
    
    if start > 0
        a = surface(ax, xg,yg,zg,'EdgeColor','None',varargin{start:end});
    else
        a = surface(ax, xg,yg,zg,'EdgeColor','None');
    end
    if nargout > 0
        varargout{1} = a;
    end
end
