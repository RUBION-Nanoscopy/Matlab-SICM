function c = centroid(self, threshold)
% Compute the centroid of a projection of the data equal or exceeding
% threshold to the z=0 plane. 
%
%    Example 
%      c = obj.centroid(2)
%
%        Computes the centroid of the projection of the data points equal
%        or larger than 2.
%
%        c is in the form [x-coordinate, y-coordinate]

    % Compute the projection
    proj = self.zdata_grid > threshold;

    % Number of points in the projection
    n = sum(proj(:));
    
    % If the projection does not contain any values, return NaN
    if n == 0
        c = [NaN, NaN];
        return
    end
    
    x_tmp = self.xdata_grid .* proj;
    y_tmp = self.ydata_grid .* proj;
    
    x_coord = sum(x_tmp(:)) / n;
    y_coord = sum(y_tmp(:)) / n;
    
    c = [x_coord, y_coord];
end
    
    
