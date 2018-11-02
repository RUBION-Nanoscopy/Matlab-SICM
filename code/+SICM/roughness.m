function [r, varargout] = roughness(data, varargin);
%ROUGHNESS - Compute the roughness of the data
%
%    Currently, the following method is used:
%
%    1) Subtract a paraboloid from the data
%    2) Remove outliers
%    3) Compute the RMSE of the data
%
%
%
%    Examples:
%  
%    r = roughness(data)
%    
%      Computes and returns the roughness
%
%
%    [r, outliers_removed] = roughness(data)
%     
%      Computes the roughness and returns the data without outliers.
%      Instead of the outlieres, NaN is inserted
%
%
%    [r, outliers_removed, fo] = roughness(data)
%
%      As above, but additionally returns the  fitobject.
%
%    [r, outliers_removed, fo, go] = roughness(data)
%
%      As above, but additionally returns the goodness of the fit.
%
%    SEE ALSO: SUBTRACTPARABOLOID, MEDIAN, BOXPLOT
pxsz = 1;
if nargin > 1
    pxsz = varargin{1};
end

[flat, fo, go] = subtractParaboloid(data, pxsz);

p75 = prctile(flat(:), 75);
p25 = prctile(flat(:), 25);

% Every data point beyond 1.5 IQRs is an outlier
upperlimit = p75 + 1.5 * (p75 - p25);
lowerlimit = p25 - 1.5 * (p75 - p25);

no_outliers = flat(flat >= lowerlimit & flat <= upperlimit);
r = rmse(no_outliers(:));
if nargout > 1
    tmp = flat;
    tmp(tmp<lowerlimit | tmp > upperlimit) = NaN;
    varargout{1} = tmp;
end
if nargout > 2
    varargout{2} = fo;
end
if nargout > 3
    varargout{3} = go;
end




