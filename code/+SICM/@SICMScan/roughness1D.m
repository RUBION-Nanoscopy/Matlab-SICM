function r = roughness1D(self, width, n, varargin)
% roughness1D  Computes the roughness linewise
%
% Arguments
%   width: number of pixels to take into account. Should be odd.
%   n: degree of the polynomial subtracted from the data
%   varargin: p,v pairs. Currently:
%          'Callback': function_handle
%          Called when the roughness for one line has finished. Parameters
%          are current line count and total line count
% Examples:
%   r = scan.roughness1D(11,5)
%   

    if mod(width,2) == 0
        warning('SICMScan:ParameterNotOdd', 'Increasing n by one!');
        width = width + 1;
    end
    cb = [];
    if nargin > 3
        if strcmp(varargin{1}, 'Callback')
            cb = varargin{2};
        end
    end

    halfwidth = (width-1) / 2;
    for y = 1:self.ypx
        if ~isempty(cb)
            cb(y, self.ypx);
        end
        for x = halfwidth+1:self.xpx-halfwidth
            l = self.zdata_grid(x-halfwidth:x+halfwidth, y);
            xcoords = (-halfwidth:halfwidth)';
            ftr = polyfit(xcoords, l, n);
            pvals = polyval(ftr, xcoords);
            yvals = l - pvals;
            er = (yvals-mean(yvals)).^2;
            r(x-halfwidth, y) = sqrt(mean(er));
            
        end
        
    end
    if ~isempty(cb)
        cb(y, self.ypx);
    end
end