function varargout = plot(obj, varargin)
    % -
    %
    % SICM.plot
    % =========
    %
    % Synopsis:
    %
    %   h = SICM.plot(SICM)
    %
    %     Displays a surface of the data in SICM.xgrid, SICM.ygrid and
    %     SICM.zgrid. For more information about an SICM-struct see
    %     SICM.read. The handle returned by the surface function is
    %     returned.
    %
    %   h = SICM.plot(SICM,interpolation)
    %
    %     As above, but the data is displayed interpolated by cubic
    %     splines. interpolations provides the number of pixels 
    %     interpolated between to recorded values.
    %
    %   h = SICM.plot(SICM,interpolation, method)
    %
    %     As above, but the interpolation is done using method from the
    %     griddata function
    %
    %   [h,ixgrid] = SICM.plot(SICM,interpolation, ...)
    %
    %     As above, additionally the interpolated xgrid is returned.
    %
    %   [h,ixgrid,iygrid] = SICM.plot(SICM,interpolation, ...)  
    % 
    %     As above, additionally the interpolated ygrid is returned.
    %
    %   [h,ixgrid,iygrid,izgrid] = SICM.plot(SICM,interpolation, ...)  
    % 
    %     As above, additionally the interpolated zgrid is returned.
    %
    % Updates:
    %
    %   2014/10/18: Make the interpolated plot use the data from the zgrid
    %   property, not from the z property, which allows storing data in the 
    %   zgrid property and subsequently plotting it interpolated
    %
    % See also SICM.read griddata
if nargin == 3
    method = varargin{2};
else
    method = 'cubic';
end

if nargin==1 || (nargin==2 &&  varargin{1} == 1)
    g1 = obj.xgrid;
    g2 = obj.ygrid;
    g3 = obj.zgrid;
else
    interpolation = varargin{1};
    [g1, g2] = meshgrid (min(obj.x):obj.Dx/interpolation:max(obj.x), min(obj.y):obj.Dy/interpolation:max(obj.y));
    tmpz = obj.zgrid';
    g3 = griddata(obj.x, obj.y, tmpz(:), g1, g2,method);
    
end


if nargout > 1
    varargout{2} = g1;
end
if nargout > 2
    varargout{3} = g2;
end
if nargout > 3
    varargout{4} = g3;
end
figure;
h = surface(g1,g2,g3,'EdgeColor','none');
axis image;
varargout{1} = h;