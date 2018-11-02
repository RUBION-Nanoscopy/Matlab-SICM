function a = area(self)
% Computes the area of the scan.
%
% Example: 
%   a = scan.area()




% If the data does not contain NaNs, use this method, it is fast
if sum(isnan(self.zdata_grid(:))) == 0

    [m, n] = size(self.zdata_grid);

    dx = self.stepx;
    dy = self.stepy;
    Z = self.zdata_grid;

    areas = ...
        0.5*sqrt((dx*dy)^2 + (dy*(Z(1:m-1,2:n) - Z(1:m-1,1:n-1))).^2 + ...
        (dx*(Z(2:m,1:n-1) - Z(1:m-1,1:n-1))).^2)...
        +...
        0.5*sqrt((dx*dy)^2 + (dx*(Z(1:m-1,2:n) - Z(2:m,2:n))).^2 + ...
        (dy*(Z(2:m,1:n-1) - Z(2:m,2:n))).^2);

    a = sum(areas(:));
    
else
    if sum(isnan(self.zdata_grid(:))) == length(self.zdata_grid(:))
        a = 0;
        return
    end
    fprintf('NaNs detected in surface data. Calculation may take long.\n');
    a = 0;
    X = self.xdata_grid;
    Y = self.ydata_grid;
    Z = self.zdata_grid;
    lX = length(X);
    lY = length(Y);
    for nx = 1:lX-1
        for ny = 1:lY-1

            eX = [X(ny,nx)   X(ny,nx+1) 
                  X(ny+1,nx) X(ny+1,nx+1)];
            eY = [Y(ny,nx)   Y(ny,nx+1) 
                  Y(ny+1,nx) Y(ny+1,nx+1)];
            eZ = [Z(ny,nx)   Z(ny,nx+1) 
                  Z(ny+1,nx) Z(ny+1,nx+1)];

            % take two triangles, calculate the cross product to get the surface area
            % and sum them.
            v1 = [eX(1,1) eY(1,1) eZ(1,1)];
            v2 = [eX(1,2) eY(1,2) eZ(1,2)];
            v3 = [eX(2,1) eY(2,1) eZ(2,1)];
            v4 = [eX(2,2) eY(2,2) eZ(2,2)];
            if ~(isnan(eZ(1,1)) || isnan(eZ(1,2)) || isnan(eZ(2,1)))
                a  = a + norm(cross(v2-v1,v3-v1))/2;
            end
            if ~(isnan(eZ(2,2)) || isnan(eZ(1,2)) || isnan(eZ(2,1)))
                a  = a + norm(cross(v2-v4,v3-v4))/2;
            end
        end
    end
end


%+BEGIN GUIMETADATA: Do not delete
%+GMD Type: 'prop'
%+GMD Name: 'Area'
%+GMD Depends: {'x','y','z'}
%+GMD Changes: {}
%+GMD Immediate: 0
%+END GUIMETADATA