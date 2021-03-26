function varargout = crop(self, varargin)
% allows to crop a piece from the scan data
%
% One can either provide a set of x, y, width, height values to crop the
% data:
%
%   scan.crop(0,0,50,50)
%
% or omit the values. In the latter case, a picture of the data is shown
% (via imagesc) and one can select a rectangular area.
%
% As always, if an output variable is specified, a new scan object is
% returned.

    if nargout == 1
        o = SICM.SICMScan.fromSICMScan_(self);
        o.crop(varargin{:})
        varargout{1} = o;
        return
    end
    
    if nargin > 1
        r= [varargin{1},...
            varargin{2},...
            varargin{3},...
            varargin{4}];
        r = round(r);
    else
        f = figure;
        imagesc(self.zdata_grid);
        r = getrect;
        close(f);
        r = round(r);
        r(1:2) = r(1:2) +1;
        if r(1) > self.xpx || r(2) > self.ypx 
            warning('SICMScan:DataOutsideRange', ...
                'Data cannot be cropped.');
            return
        end
    end
    self.zdata_grid = self.zdata_grid(r(2):r(2)+r(4), r(1):r(1)+r(3));
    self.ydata_grid = self.ydata_grid(r(2):r(2)+r(4), r(1):r(1)+r(3));
    self.xdata_grid = self.xdata_grid(r(2):r(2)+r(4), r(1):r(1)+r(3));
        
    self.zdata_lin = self.zdata_grid(:);
    self.xdata_lin = self.xdata_grid(:);
    self.ydata_lin = self.ydata_grid(:);
        
    self.xpx = r(4)+1;
    self.ypx = r(3)+1;
        
    self.xsize = self.xpx * self.stepx;
    self.ysize = self.ypx * self.stepy;
   
    
    
%+BEGIN GUIMETADATA: Do not delete
%+GMD Type: 'meth'
%+GMD Name: 'Crop'
%+GMD FixedArgs: {}
%+GMD VarArgs: {}
%+GMD Depends: {}
%+GMD Changes: {'x','y','z'}
%+GMD Immediate: 0
%+GMD Menu: 'Simple Manipulations'
%+END GUIMETADATA
    