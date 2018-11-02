function app = getAppCurve(self, idx, varargin)
% return the approach curve with index idx

if nargin == 3
    idx2 = varargin{1};
    app = self.approachcurves{idx, idx2};
else
    app = self.approachcurves{...
            ind2sub(size(self.zdata_grid), idx)...
        };
end