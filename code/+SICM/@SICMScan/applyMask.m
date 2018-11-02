function varargout = applyMask(self, mask)
% Applies a binary mask to the data.
%
%    A binary mask is a two dimensional vector of zeros and ones that has
%    the same size as the zdata_grid. Applying this mask multiplies the
%    zdata_grid and the mask element by element, hence setting the zdata to
%    zero where the mask contains zero and leaving the zdata unaltered
%    where the mask is  one.
%
%    Assume the follwing mask:
%      mask = [0 1 0;...
%              1 1 1;...
%              0 1 0]
%
%    and a SICMScan object `obj` with the following zdata_grid:
%      obj.zdata_grid = [.1 .2 .3;
%                        .4 .5 .6;
%                        .7 .8 .9]
%
%    Examples:
%
%       obj.applyMask(mask);
%
%         The zdata_grid will look like this:
%           obj.zdata_grid = [ 0 .2  0;
%                             .4 .5 .6;
%                              0 .8  0]
%
%       newobj = obj.applyMask(mask)
%        
%         As above, but retruns a new object instead of modifying `obj`

    if nargout == 1
        o = SICM.SICMScan.fromSICMScan_(self);
        o.applyMask(mask);
        varargout{1} = o;
        return
    end
    
    self.zdata_grid = self.zdata_grid .* mask;
    self.upd_zlin_();
end
